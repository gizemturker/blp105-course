# Hafta 10 laboratuvar föyü: veri yükleme, güvenli değişiklik ve alt sorgu

Ad soyad: ______________________  Öğrenci no: ______________  Tarih: __________

Program (işaretle):  ☐ Yapay Zeka Operatörlüğü (`llm_ops`)  ☐ Robotik ve Yapay Zeka (`robot_fleet`)

## Başlarken

Hafta 9'da kurduğun tablolar ve `migrations/001_create_tables.sql` dosyan bu haftanın zeminidir. Bu föyde üç lab var: Lab 1 (veri yükleme, güvenli `UPDATE`, UPSERT), Lab 2 (transaction), Lab 3 (alt sorgu ve CTE). Hepsi **kendi projen** üzerinde. Ders notu: [ders-notu.md](ders-notu.md), ödev: [odev.md](odev.md)

Kurallar:
- Her `UPDATE` ve `DELETE`'ten önce aynı `WHERE` ile `SELECT count(*)`.
- Her SQL dosyasının başında "ne yaptım, neden" yorum satırı.
- Hata mesajını silme, kopyala: hata mesajı bu föyün kanıtıdır.
- Şeman çalışmıyorsa o hafta örnek veritabanında ilerle, kendi projene evde uygula. Hocaya söyle.

Ortam kontrolü (herkes, 2 dk):

```sql
SELECT current_database();
\dt
SELECT count(*) FROM ana_tablo;   -- kendi tablo adınla
```

Beklenen: kendi veritabanının adı ve Hafta 9'da kurduğun tablolar. Tablo yoksa `psql -d benim_projem -f migrations/001_create_tables.sql` ile kur. Veritabanı yoksa `createdb benim_projem`.

---

## Lab 1: Veri yükleme, güvenli UPDATE, RETURNING, UPSERT (30 dk)

Dosya: `odevler/odev-05/dml-denemeleri.sql`

### 1.1. `\copy` ile gerçek veri (10 dk)

Ne yapılacak: Önce CSV'nin ilk satırlarına bak, sütun sırası tablonla aynı mı kontrol et. Önce ana tabloyu yükle.

```
\copy ana_tablo (ad, kod, durum) FROM 'veri/ana_tablo.csv' CSV HEADER
SELECT count(*) FROM ana_tablo;
```

Beklenen çıktı: `COPY <satır sayısı>`; `count(*)` aynı sayıyı verir.
Takıldıysan:
- `invalid input syntax for type ...`: sütun sırası ya da tarih biçimi uyuşmuyor; sütun listesini `\copy`'ye yaz ve CSV'nin ilk satırına bak.
- `null value in column ... violates not-null constraint`: CSV'de boş hücre var.
- Türkçe karakterler bozuk: dosyayı UTF-8 kaydet.
- Büyük dosya hata veriyorsa önce ilk 10 satırla dene.
- `\copy` tek satırda yazılır, satır sonunda `;` konmaz.
- Kendi CSV'n hazır değilse hocadan örnek CSV iste ya da örnek veritabanında devam et.

### 1.2. Önce say, sonra güncelle (8 dk)

Ne yapılacak: Kendi tablonda bir `UPDATE` seç. Önce aynı `WHERE` ile say, sonra güncelle, etkilenen satır sayısını karşılaştır.

```sql
SELECT count(*) FROM ana_tablo WHERE durum = 'aktif';   -- kaç satır?
UPDATE ana_tablo SET durum = 'pasif' WHERE durum = 'aktif';   -- UPDATE <n>
```

Beklenen çıktı: `UPDATE n` ve `n` ilk sayımla aynı.
Takıldıysan: Sayılar farklıysa `WHERE` iki sorguda aynı değildir. `UPDATE 0` ise koşulu sağlayan satır yok: yazım, büyük/küçük harf ve boşlukları kontrol et.
Soru: Bu `UPDATE`'te `WHERE` yazmasaydın kaç satır değişirdi? ______

### 1.3. `INSERT ... RETURNING` (4 dk)

```sql
INSERT INTO ana_tablo (ad, kod) VALUES ('deneme', 'DNM-1') RETURNING *;
```

Beklenen çıktı: eklenen satır, otomatik üretilen `id` dahil, hemen ekrana gelir.
Takıldıysan: `duplicate key value violates unique constraint` ise `kod` zaten var, başka bir değer ver.

### 1.4. UPSERT (8 dk)

Ne yapılacak: `UNIQUE` ya da `PRIMARY KEY` olan bir sütunda çakışma yaratıp güncelle.

```sql
INSERT INTO ana_tablo (ad, kod) VALUES ('yeni ad', 'DNM-1')
ON CONFLICT (kod) DO UPDATE SET ad = EXCLUDED.ad
RETURNING *;
```

Beklenen çıktı: yeni satır eklenmez, `DNM-1` kodlu satırın adı `yeni ad` olur; `INSERT 0 1`.
Takıldıysan: `there is no unique or exclusion constraint matching the ON CONFLICT specification` hatası, `ON CONFLICT (...)` içindeki sütunun `UNIQUE`/`PRIMARY KEY` olmadığını söyler.
Tahmin et: ikinci kez çalıştırırsan tabloda kaç satır olur? ______ (çalıştırıp `count(*)` ile kontrol et)

### Lab 1 teslim kanıtı (kısa)

- [ ] Kendi CSV'nden yüklenmiş en az bir tabloda `SELECT count(*)` sonucu
- [ ] Önce-say-sonra-güncelle: iki sayı yan yana (C2)
- [ ] `RETURNING` ve (yapıldıysa) UPSERT çıktısı


---

## Lab 2: Transaction (BEGIN, ROLLBACK, SAVEPOINT)

Dosya: `odevler/odev-05/dml-denemeleri.sql` 2. bölüm

### 2.1 Bilerek yanlış UPDATE, hasarı gör, geri al (10 dk)

Ne yapılacak: Kendi tablonda, **WHERE'siz** bir güncelleme yap ama transaction içinde.

```sql
SELECT count(*) FROM ana_tablo WHERE durum = 'pasif';   -- önce: ______
BEGIN;
UPDATE ana_tablo SET durum = 'pasif';                   -- WHERE yok, bilerek
SELECT count(*) FROM ana_tablo WHERE durum = 'pasif';   -- hasar: ______
ROLLBACK;
SELECT count(*) FROM ana_tablo WHERE durum = 'pasif';   -- sonra: ______
```

Beklenen çıktı: ortadaki sayı tablonun toplam satır sayısına eşit; `ROLLBACK`'ten sonra ilk sayıya döner.
Takıldıysan: `WARNING: there is no transaction in progress` ROLLBACK'i boşuna yazdığını söyler (BEGIN yoktu). `ERROR: current transaction is aborted` görürsen transaction hata yüzünden bozulmuştur; `ROLLBACK;` yaz ve baştan başla.
Tahmin et: bu sorguyu `BEGIN` olmadan çalıştırsaydın `ROLLBACK` seni kurtarır mıydı? ______

### 2.2 SAVEPOINT (5 dk)

```sql
BEGIN;
UPDATE ana_tablo SET durum = 'a' WHERE id = 1;
SAVEPOINT adim1;
UPDATE ana_tablo SET durum = 'b' WHERE id = 2;
ROLLBACK TO adim1;
COMMIT;
SELECT id, durum FROM ana_tablo WHERE id IN (1, 2);
```

Beklenen çıktı: `id = 1` değişmiş kalır, `id = 2` eski değerinde.
Takıldıysan: `savepoint "adim1" does not exist` ise `ROLLBACK TO` öncesinde transaction'ı zaten bitirmişsin.

### 2.3 Projemde ya hep ya hiç (3 dk)

Kendi projende hangi iki adım birlikte olmalı? (Örnek biçim: "bir kayıt ve onun satırları.") ______________________________

Kontrol sorusu (sınıfla): `COMMIT`'ten sonra `ROLLBACK` ne yapar? Bağlantı kopsa açık transaction'a ne olur? Tahminini yaz: ______

### Lab 2 teslim kanıtı (kısa)

- [ ] Üç sayı (önce, hasar, sonra) dosyada yorum olarak
- [ ] "Ya hep ya hiç" cümlesi
- [ ] ACID'den en az A (atomiklik) ve D (kalıcılık) harfini bir örnekle açıkla (1-2 cümle)


---

## Lab 3: Alt sorgu, IN, EXISTS, CTE

Dosya: `queries/analiz-01.sql`

### 3.1 Alt sorguyla bir soru (8 dk)

Ne yapılacak: Kendi projen için bir iş sorusu seç ("ortalamanın üstünde olanlar", "bağlı kaydı olanlar" gibi). Önce JOIN'siz, `IN` veya skaler alt sorguyla yaz.

```sql
SELECT ad FROM ana_tablo
WHERE id IN (SELECT ana_id FROM bagli_tablo);
```

Beklenen çıktı: bağlı kaydı olan ana kayıtların adları.
Takıldıysan: `more than one row returned by a subquery used as an expression` hatasında alt sorgu birden fazla satır döndürüyor; `=` yerine `IN` kullan. Alt sorgunun tek başına çalışıp çalışmadığını önce ayrı dene.

### 3.2 NOT IN ve NULL tuzağı (7 dk)

Ne yapılacak: "Bağlı kaydı olmayanlar" sorusunu iki yolla yaz ve sonuçları karşılaştır.

```sql
SELECT ad FROM ana_tablo WHERE id NOT IN (SELECT ana_id FROM bagli_tablo);
SELECT ad FROM ana_tablo a
WHERE NOT EXISTS (SELECT 1 FROM bagli_tablo b WHERE b.ana_id = a.id);
```

Beklenen çıktı: alt sorgudaki sütunda `NULL` yoksa ikisi aynı satırları verir. `NULL` varsa `NOT IN` boş dönebilir. (`ana_id` `NOT NULL` tanımlıysa bunu göremezsin; hocanın örnek veritabanındaki gösterimine bak.)
Takıldıysan: İkisi aynıysa tuzak sende oluşmamış demektir, bu iyi bir şey; "NULL olsaydı ne olurdu" sorusunu yaz.
Soru: `IN` ve `EXISTS` aynı sonucu ne zaman vermez? ______________________

### 3.3 CTE ile adımlara böl

```sql
WITH ozet AS (
  SELECT ana_id, count(*) AS adet FROM bagli_tablo GROUP BY ana_id
)
SELECT a.ad, o.adet FROM ana_tablo a JOIN ozet o ON o.ana_id = a.id
WHERE o.adet > 1;
```

Beklenen çıktı: `adet` değeri 1'den büyük olan ana kayıtlar.
Takıldıysan: `relation "ozet" does not exist` ise `WITH` bloğu ile ana sorgu arasına `;` koymuşsun; `;` yalnızca en sonda olur.

### Lab 3 teslim kanıtı (kısa)

- [ ] `analiz-01.sql` içinde alt sorgu veya CTE'li en az bir sorgu, üstünde iş sorusu yorumu
- [ ] 3.2'deki iki sorgunun satır sayıları yan yana


---

## Kontrol listesi

- [ ] En az bir tabloya gerçek veri yükledim
- [ ] Her `UPDATE`'ten önce sayım yaptım
- [ ] ROLLBACK ile kendi hasarımı geri aldım
- [ ] Bir alt sorgu veya CTE yazdım

## YZ kullanım beyanı

YZ araçlarını kullanabilirsin; kullandıysan yaz ve çıktısını kendin doğrula.

| Lab | Araç | Ne sordun | Nasıl doğruladın |
|---|---|---|---|
| | | | |

## Takıldığın yer

Bu haftanın en şaşırtıcı sonucu neydi?

______________________________________________________________
