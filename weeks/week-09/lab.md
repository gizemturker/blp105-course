# Hafta 9 laboratuvar föyü: şema, kısıt ve migration

Ad soyad: ______________________  Öğrenci no: ______________  Tarih: __________

Program (işaretle):  ☐ Yapay Zeka Operatörlüğü (`llm_ops`)  ☐ Robotik ve Yapay Zeka (`robot_fleet`)

## Başlarken

Bu föyde iki lab var: Lab 1 (kendi tabloların ve kısıt ihlali), Lab 2 (migration dosyası). İkisi de **kendi projen** üzerinde. Örnek veritabanı (`robot_fleet` / `llm_ops`) yalnızca hocanın canlı gösterimi ve yedek yol içindir. Ders notu: [ders-notu.md](ders-notu.md)

Kurallar:
- Her SQL dosyasının başında "ne yaptım, neden" yorum satırı.
- Hata mesajını silme, kopyala: hata mesajı bu föyün kanıtıdır.
- Şeman çalışmıyorsa o hafta örnek veritabanında ilerle, kendi projene evde uygula. Hocaya söyle.

Teslim edilecek kanıtlar her labın sonunda yazılıdır. Ödevin tamamı: [odev.md](odev.md)

Ortam kontrolü (herkes, 2 dk):

```sql
SELECT current_database();
\dt
```

Beklenen: kendi veritabanının adı. `\dt` henüz boş olabilir ("Did not find any relations").
Takıldıysan: veritabanı yoksa terminalde `createdb benim_projem` (kendi adın), sonra `psql -d benim_projem`.

---

## Lab 1: İlk iki tablo ve dört kısıt ihlali (35 dk)

Dosya: `odevler/odev-04/kisit-denemeleri.sql`

### 1.1. İki bağlı tablo kur (12 dk)

Ne yapılacak: ERD'ndeki bir ana tabloyla ona bağlı bir tabloyu `CREATE TABLE` ile kur. Toplamda şunlar bulunsun: iki `PRIMARY KEY`, bir `FOREIGN KEY`, en az üç `NOT NULL`, bir `UNIQUE`, bir `CHECK`, bir `DEFAULT`.

Şablon (adları kendi projene göre değiştir):

```sql
CREATE TABLE ana_tablo (
  id    integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  ad    text NOT NULL,
  kod   text NOT NULL UNIQUE,
  durum text NOT NULL DEFAULT 'aktif'
);

CREATE TABLE bagli_tablo (
  id          integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  ana_id      integer NOT NULL REFERENCES ana_tablo(id),
  miktar      integer CHECK (miktar >= 0),
  olusturma   timestamptz NOT NULL DEFAULT now()
);
```

Beklenen çıktı: iki kez `CREATE TABLE`. `\d bagli_tablo` çıktısında `Foreign-key constraints` bölümü görünür.
Takıldıysan: `syntax error at or near ...` hatasında hatanın işaret ettiği satırın bir önceki satırına bak, çoğu zaman eksik virgüldür. `relation ... does not exist` hatasında önce ana tabloyu kurmadın.
Tahmin et: `\d bagli_tablo` yazmadan önce, `ana_id` için kaç kısıt göreceğini defterine yaz (cevap: iki, `NOT NULL` ve FK; çalıştırıp kontrol et).

### 1.2. Silme davranışı kararı (3 dk)

Ne yapılacak: `bagli_tablo.ana_id` için `ON DELETE CASCADE` mi `RESTRICT` mi, bir cümleyle gerekçe yaz. Dosyaya yorum olarak koy.

Beklenen: gerekçeli bir cümle ("... sildiğinde ... kaybolur, bunu istiyorum / istemiyorum").
Takıldıysan: "Ana kaydı sildiğimde bağlı kayıtlar anlamını koruyor mu?" sorusuna evet ise `CASCADE` düşünülebilir, hayır ise `RESTRICT`.

### 1.3. Dört bilinçli ihlal (15 dk)

Ne yapılacak: Aşağıdaki dört ihlali sırayla dene. Önce tablona birkaç geçerli satır ekle (`INSERT`). Her ihlalden önce **hata mesajının ne diyeceğini tahmin et**, sonra çalıştır.

| # | İhlal | Nasıl denenir | Tahminim | Gerçek mesaj |
|---|---|---|---|---|
| 1 | Tekrar eden anahtar | `UNIQUE` sütuna aynı değeri ikinci kez ekle (kimlik sütunu otomatik olduğu için `UNIQUE` sütunu kullan) | | |
| 2 | Olmayan FK | `bagli_tablo`'ya `ana_id` olarak var olmayan bir sayı yaz | | |
| 3 | NOT NULL'a NULL | Zorunlu bir sütunu `NULL` ver | | |
| 4 | CHECK ihlali | `CHECK` koşuluna uymayan bir değer yaz | | |

Beklenen çıktı: her biri `ERROR:` ile başlayan bir mesaj; mesajda kısıt adı veya sütun adı geçer. Hiçbir satır eklenmemiş olmalı: `SELECT count(*)` ile doğrula.
Takıldıysan: Hata gelmiyorsa kısıt kurulmamış demektir; `\d tablo_adi` ile kısıtı ara. PK'yi tekrar etmek için `GENERATED ALWAYS` sütuna elle değer yazmaya çalışırsan farklı bir hata alırsın, bu da değerli bir bulgu: ne dediğini not et.
Düşün: Dört hatadan hangisi veriyi korudu, hangisi yalnızca yazım hatasıydı? ______________________

Hızlı bitirene: üçüncü bir tablo ve bir `ON DELETE SET NULL` denemesi; ana kaydı silince bağlı satırda ne olduğunu yaz.

### Lab 1 teslim kanıtı (kısa)

- [ ] `\d bagli_tablo` ekran görüntüsü ya da çıktı metni
- [ ] Dört ihlalin hata mesajları `kisit-denemeleri.sql` dosyasında yorum olarak
- [ ] Silme davranışı gerekçesi (1 cümle)


---

## Lab 2: `001_create_tables.sql` migration dosyası (20 dk)

Dosya: `migrations/001_create_tables.sql`

### 2.1. Dosyayı kur (10 dk)

Ne yapılacak: Lab 1'daki tabloları ve elinde kalanları tek dosyaya topla. Yapı: başlık yorumu, `DROP TABLE IF EXISTS` satırları (**önce bağlı tablo, sonra ana tablo**), sonra `CREATE TABLE`'lar (önce ana tablo).

```sql
-- 001_create_tables.sql
-- Ne yapar: ... projesinin tablolarını sıfırdan kurar. Neden: tekrar çalıştırılabilir olsun.
DROP TABLE IF EXISTS bagli_tablo;
DROP TABLE IF EXISTS ana_tablo;

CREATE TABLE ana_tablo ( ... );
CREATE TABLE bagli_tablo ( ... );
```

Beklenen çıktı: `DROP TABLE` ve `CREATE TABLE` satırları, hata yok.
Takıldıysan: `cannot drop table ana_tablo because other objects depend on it` hatası, DROP sırasının ters olduğunu söyler: bağlı tabloyu önce sil.

### 2.2. İki kez çalıştır (5 dk)

Ne yapılacak: Terminalde (psql'in dışında) iki kez art arda:

```
psql -d benim_projem -f migrations/001_create_tables.sql
psql -d benim_projem -f migrations/001_create_tables.sql
```

Beklenen çıktı: ikisi de aynı sonucu verir. İkinci çalıştırmada hata yoksa dosya tekrar çalıştırılabilirdir. (`NOTICE: table ... does not exist, skipping` yalnızca ilk çalıştırmada görünür, hata değildir.)
Takıldıysan: `psql: command not found` ise hocaya söyle (PATH sorunu); psql içindeysen `\i migrations/001_create_tables.sql` de olur. `No such file or directory` ise terminalin bulunduğu klasörü `pwd` ile kontrol et.
Tahmin et: ikinci çalıştırma sonucu ilkinden farklı olur mu? Yaz, sonra dene: ______

### 2.3. Kalan tablolar (5 dk)

Ne yapılacak: ERD'ndeki kalan tabloları eklemeye başla. Bitmezse eve kalır; en az iki tablo çalışıyor olmalı.

### Lab 2 teslim kanıtı (kısa)

- [ ] `001_create_tables.sql` en az iki tabloyla, iki çalıştırma da hatasız (terminal çıktısı)
- [ ] Dosyada başlık yorumu ve DROP sırasının doğru olduğu


---

## Lab sonu kontrolü

Yan komşuna `\dt` ve bir `SELECT count(*)` sonucunu göster. Kimde ne eksik, birlikte not alın; eksiklerini ödev üzerinde tamamla. Hafta 10'da bu tablolara veri yükleyeceksin, bu yüzden tabloların çalışıyor olması önemli.

Eksiklerim: ______________________________________________________________

## Kontrol listesi

- [ ] İki tablo kurdum, dört ihlali denedim
- [ ] Migration dosyam iki kez hatasız çalıştı

## YZ kullanım beyanı

YZ araçlarını kullanabilirsin; kullandıysan yaz ve çıktısını kendin doğrula.

| Adım | Araç | Ne sordun | Nasıl doğruladın |
|---|---|---|---|
| | | | |

## Takıldığın yer

Bu haftanın en şaşırtıcı hata mesajı neydi?

______________________________________________________________
