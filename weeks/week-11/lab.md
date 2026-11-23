# Hafta 11 laboratuvar föyü: görünüm, indeks, rol, yedek ve YZ bileşeni

Ad soyad: ______________________  Öğrenci no: ______________  Tarih: __________

Program (işaretle):  ☐ Yapay Zeka Operatörlüğü (`llm_ops`)  ☐ Robotik ve Yapay Zeka (`robot_fleet`)

## Başlarken

Hafta 9'da kurduğun şema ve Hafta 10'da yüklediğin veri bu haftanın zeminidir. Bu föyde dört lab var: Lab 1 (view, indeks, `EXPLAIN`), Lab 2 (rol ve SQL injection), Lab 3 (yedek), Lab 4 (YZ bileşeni seçimi). Hepsi **kendi projen** üzerinde. Ders notu: [ders-notu.md](ders-notu.md), ödev: [odev.md](odev.md)

Kontrol:

```sql
\dt
SELECT count(*) FROM ana_tablo;   -- kendi tablo adınla, her tablo için
```

Beklenen: tablolarında satır var. Boş tablon varsa hocaya söyle; o lab için örnek veritabanında çalış.

Aynı kurallar sürüyor: her `UPDATE`'ten önce `SELECT count(*)`, her dosyada "ne yaptım, neden" yorumu, hata mesajı silinmez.

---

## Lab 1: VIEW, indeks, EXPLAIN

Dosyalar: `migrations/002_views.sql`, `003_indexes.sql`

### 1.1 JOIN'li bir view (8 dk)

```sql
CREATE OR REPLACE VIEW ana_ozet AS
SELECT a.id, a.ad, count(b.id) AS bagli_adet
FROM ana_tablo a LEFT JOIN bagli_tablo b ON b.ana_id = a.id
GROUP BY a.id, a.ad;

SELECT * FROM ana_ozet;
```

Beklenen çıktı: sorguyu tekrar yazmadan sonucu verir. `LEFT JOIN` ve `count(b.id)` sayesinde bağlı kaydı olmayan satırlar 0 ile görünür.
Takıldıysan: `column "a.ad" must appear in the GROUP BY clause` hatası, `GROUP BY` listesinde eksik sütun var demektir. View'in üstüne hangi iş sorusuna cevap verdiğini yorum olarak yaz.

### 1.2 İndeks ve EXPLAIN (12 dk)

Ne yapılacak: `WHERE` içinde sık kullanacağın bir sütuna indeks koy. Öncesi ve sonrasında planı karşılaştır.

```sql
EXPLAIN ANALYZE SELECT * FROM bagli_tablo WHERE ana_id = 1;
CREATE INDEX idx_bagli_ana_id ON bagli_tablo (ana_id);
EXPLAIN ANALYZE SELECT * FROM bagli_tablo WHERE ana_id = 1;
```

Beklenen çıktı: planda `Seq Scan` ya da `Index Scan` (ya da `Bitmap ...`) satırı. **Tablon küçükse PostgreSQL indeksi kullanmayıp `Seq Scan` seçebilir; bu doğru bir bulgudur, yanlış değil.** Uydurma hızlanma yazma; plandaki gerçek tarama türünü ve süreyi yaz.

| | Tarama türü | Execution Time |
|---|---|---|
| İndeksten önce | | |
| İndeksten sonra | | |

Takıldıysan: `relation "idx_..." already exists` ise indeks adını değiştir ya da önce `DROP INDEX IF EXISTS ...`. Fark görmek istiyorsan satır sayısı çok olan bir tablonda dene.
Soru: Tablon küçükse indeks neden fark yaratmaz? Bunu raporunda nasıl yazarsın? ______________________

### Lab 1 teslim kanıtı (kısa)

- [ ] `002_views.sql`'de JOIN'li bir view ve iş sorusu yorumu
- [ ] Yukarıdaki tablo (öncesi ve sonrası, gerçek çıktıdan)


---

## Lab 2: Rol ve GRANT, SQL injection

Dosya: `migrations/004_roles.sql`

### 2.1 Salt-okunur rol (8 dk)

Ne yapılacak: Rol cluster düzeyindedir, bu yüzden dosya ikinci çalıştırmada "already exists" verebilir. Kontrollü yaz. Veritabanı adını elle yazma, kendi adını kullan.

```sql
DO $$ BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'app_readonly') THEN
    CREATE ROLE app_readonly LOGIN PASSWORD 'sadece_lab_icin';
  END IF;
END $$;
GRANT CONNECT ON DATABASE benim_projem TO app_readonly;   -- kendi DB adın
GRANT USAGE ON SCHEMA public TO app_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_readonly;
```

(Şifre yalnızca lab örneğidir; gerçek projede şifre dosyaya yazılmaz.)

Beklenen çıktı: `CREATE ROLE`, üç `GRANT`. Ortak sunucuda rol adı çakışırsa hocaya söyle: adın sonuna kısaltmanı ekle (`app_readonly_xyz`).
Takıldıysan: `permission denied to create role` ise hesabının rol oluşturma yetkisi yok, hocaya söyle.

### 2.2 Rolün sınırını dene (5 dk)

Ne yapılacak: `app_readonly` ile bağlan (`psql -d benim_projem -U app_readonly`). Önce `SELECT`, sonra `UPDATE` dene.

Beklenen çıktı: `SELECT` çalışır, `UPDATE` için `ERROR: permission denied for table ...`.
Tahmin et: `DROP TABLE` dersen ne olur? ______ (dene, mesajı yaz)
Takıldıysan: bağlanamazsan `pg_hba` ya da şifre sorunudur; zaman kaybetme, hocaya söyle, hocanın ekran gösterimini izle.

### 2.3 SQL injection: metni yazdır (5 dk, bağlantı gerekmez)

Ne yapılacak: Python'da kullanıcı girdisini sorgu metnine birleştir ve yazdır.

```python
girdi = "x' OR '1'='1"
sorgu = "SELECT * FROM kullanicilar WHERE ad = '" + girdi + "'"
print(sorgu)
```

Beklenen çıktı: `SELECT * FROM kullanicilar WHERE ad = 'x' OR '1'='1'`. Girdi veri olmaktan çıkıp sorgunun parçası oldu.
Soru: Parametreli sorguda girdi neden komuta karışamaz? ______________________
Kontrol sorusu: Bir chatbot veritabanına bağlanacak; hangi rolle, hangi yetkiyle? ______________________

### 2.4 Projemde kim ne yapar?

Projeni kimin okuyacağını, kimin yazacağını iki satırla yaz: ______________________

### Lab 2 teslim kanıtı (kısa)

- [ ] `004_roles.sql` taslağı ve `UPDATE` denemesinin `permission denied` mesajı
- [ ] Kullanıcı tipleri iki satırı


---

## Lab 3: Yedek (komut kartı)

Komutlar:

```
pg_dump -Fc benim_projem -f yedek.dump
createdb benim_projem_kopya
pg_restore -d benim_projem_kopya yedek.dump
```

Beklenen: `yedek.dump` oluşur; kopya veritabanında `\dt` aynı tabloları gösterir. **Yedek dosyası (`yedek.dump`) repoya girmez:** boyutu büyüktür ve verini içerir. Reponun `.gitignore` dosyasına `*.dump` satırını ekle.
Takıldıysan: `pg_dump: command not found` PATH sorunudur; hocaya söyle.

Kanıt: [ ] `ls -l yedek.dump` çıktısı


---

## Lab 4: YZ bileşeni seçimi

Dosya: `ai/` klasöründe bir not dosyası

### 4.1 Üç seçenek, birini seç (10 dk)

| Seçenek | Ne | Kurulum şartı |
|---|---|---|
| A. `jsonb` | JSON sütunu, `->`, `->>`, `@>` | Yok (çekirdek PostgreSQL) |
| B. pgvector | Vektör sütunu, "en yakın 5" | Eklenti kurulu olmalı (kontrol sonucu, `SELECT name FROM pg_available_extensions WHERE name = 'vector';`: ______) |
| C. Text-to-SQL | Şemayı LLM'e ver, ürettiği SQL'i test et | LLM erişimi ve ders içi kullanım kuralı |

Ne yapılacak: Projen için birini seç; gerekçeni ve sınırını yaz. A'yı seçtiysen ilk `jsonb` sütununu ekle:

```sql
ALTER TABLE ana_tablo ADD COLUMN ek_bilgi jsonb;
UPDATE ana_tablo SET ek_bilgi = '{"etiket": "deneme"}' WHERE id = 1;
SELECT ad, ek_bilgi ->> 'etiket' AS etiket FROM ana_tablo WHERE id = 1;
```

Beklenen çıktı: `etiket` sütununda `deneme`.
Takıldıysan: `invalid input syntax for type json` ise JSON'da tek tırnak ya da eksik çift tırnak vardır; JSON içinde çift, SQL metninde tek tırnak kullan. B için `extension "vector" is not available` hatası eklentinin kurulu olmadığını söyler, B'yi bu gün deneme; seçim notunu yine yaz. C'yi seçtiysen LLM'in ürettiği SQL'i **sen çalıştırmadan önce oku** ve `app_readonly` ile dene.

Düşün: "Çalışan ama yanlış" bir sorgu nasıl görünür? Aynı soruyu elle yazdığın sorguyla sonuç sayısı üzerinden karşılaştır.

Seçimim: ☐ A  ☐ B  ☐ C   Gerekçem (1-2 cümle): ______________________________

Sınırı: ______________________________

### Lab 4 teslim kanıtı (kısa)

- [ ] Seçim notu: seçenek, gerekçe, sınır
- [ ] A seçtiysen `->>` sorgusunun çıktısı


---

## Kontrol listesi

- [ ] Bir view ve bir indeks kurdum; EXPLAIN'in dediğini yazdım, beklediğimi değil
- [ ] `app_readonly` ile `UPDATE`'in reddedildiğini gördüm
- [ ] YZ bileşeni için seçim notunu yazdım

## YZ kullanım beyanı

YZ araçlarını kullanabilirsin; kullandıysan yaz ve çıktısını kendin doğrula. Özellikle Lab 4'te, text-to-SQL denediysen hangi sorguyu çalıştırmadan önce okuyup düzelttiğini belirt.

| Lab | Araç | Ne sordun | Nasıl doğruladın |
|---|---|---|---|
| | | | |

## Takıldığın yer

Bu haftanın en şaşırtıcı sonucu neydi?

______________________________________________________________
