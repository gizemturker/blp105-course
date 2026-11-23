# Hafta 9 ders notu: DDL, tablolar, anahtarlar ve kısıtlar

> Haftanın ders notu ve metin sürümü. Buradaki bütün sorgular `robot_fleet` ve `llm_ops` veritabanlarında PostgreSQL 18 ile çalıştırılmıştır ve gösterilen sonuçlar gerçek çıktılardır (zaman damgası, `cost` ve `Buffers` gibi sayılar sende biraz farklı çıkabilir). Kurulum: [data/README.md](../../data/README.md)

> Hafta 7'de kâğıt üzerinde tasarladığın şemayı bu hafta gerçekten kuruyorsun.

## Bu haftanın haritası

```
şema kur → hata mesajını oku → şemayı dosyayla yönet
 (DDL)       (kısıt ihlalleri)     (migration)
```

Her bölümün sonunda **"Senin projende"** diye bir adım var. Örnek veritabanında gösteriyoruz, sen aynısını kendi projenin tablosunda yapıyorsun. Hafta 10'da bu şemanın içini dolduracaksın.

### Temiz başlangıç (önemli)

Bu notta bazı bölümler örnek veritabanına yeni tablo, görünüm ya da kısıt ekliyor. Bu yüzden `data/robot_fleet.sql` dosyasını tek başına yeniden çalıştırırsan **hata alabilirsin**: dosyanın başındaki `DROP TABLE robots`, ona bağlı yeni bir tablo ya da görünüm varsa reddedilir. Temiz başlamak için veritabanını baştan kur:

```bash
dropdb robot_fleet
createdb robot_fleet
psql -d robot_fleet -f data/robot_fleet.sql
```

`llm_ops` için de aynısı. Not: roller veritabanıyla değil sunucuyla ilgilidir, `dropdb` onları silmez.

Bu notta her bölüm temiz yükleme ile başlar, bir önceki bölümü yapmış olman gerekmez.

## 1. Veritabanlarını yükle ve kontrol et

```bash
createdb robot_fleet
psql -d robot_fleet -f data/robot_fleet.sql
createdb llm_ops
psql -d llm_ops -f data/llm_ops.sql
```

```sql
\dt
SELECT count(*) FROM robots;     --> 10
SELECT count(*) FROM missions;   --> 14
SELECT count(*) FROM operators;  --> 10
```

`\dt` tabloları listeler, `\d robots` tek bir tablonun sütunlarını ve kısıtlarını gösterir. Bu hafta `\d` çok işimize yarayacak.

**Senin projende:** kendi projen için boş bir veritabanı aç: `createdb benim_projem`.

## 2. DDL: tablo, tip, anahtar, kısıt

### 2.1 Bir kısıt ihlalinin hatasını okumak

Hafta 6'dan hatırla: `missions.robot_id` bir yabancı anahtar. Id'si 1 olan robotu silmeyi deneyelim; Atlas-01'in üç görevi var.

```sql
DELETE FROM robots WHERE id = 1;
```

```
ERROR:  update or delete on table "robots" violates foreign key constraint "missions_robot_id_fkey" on table "missions"
DETAIL:  Key (id)=(1) is still referenced from table "missions".
```

Hata mesajını üç parçada oku: **hangi kısıt** (`missions_robot_id_fkey`), **hangi tablo** (`missions`), **hangi değer** (`id = 1`, hâlâ referans veriliyor). Silme davranışını biz yazmadık; yazılmadığında PostgreSQL varsayılan olarak **reddeder**.

### 2.2 Eksik yabancı anahtarı sonradan eklemek

Hafta 6 notunda şöyle yazıyordu: `robots.operator_name → operators.operator_name`. Gerçekte öyle değil. Şemaya bakalım:

```sql
SELECT conname, contype FROM pg_constraint WHERE conrelid = 'robots'::regclass;
```

```
      conname       | contype
--------------------+---------
 robots_id_not_null | n
 robots_pkey        | p
(2 rows)
```

`f` (foreign key) yok. Yani şu an `robots` tablosuna `operator_name = 'Mehmet'` yazabilirsin ve kimse itiraz etmez. Düzeltelim:

```sql
ALTER TABLE robots ADD FOREIGN KEY (operator_name) REFERENCES operators (operator_name);
```

```
ALTER TABLE
```

```sql
SELECT conname, contype FROM pg_constraint WHERE conrelid = 'robots'::regclass ORDER BY conname;
```

```
          conname          | contype
---------------------------+---------
 robots_id_not_null        | n
 robots_operator_name_fkey | f
 robots_pkey               | p
(3 rows)
```

Şimdi olmayan bir operatör atamayı dene:

```sql
UPDATE robots SET operator_name = 'Mehmet' WHERE id = 9;
```

```
ERROR:  insert or update on table "robots" violates foreign key constraint "robots_operator_name_fkey"
DETAIL:  Key (operator_name)=(Mehmet) is not present in table "operators".
```

Peki Mars-03'ün operatörü zaten NULL'dı; kısıt eklenirken neden hata vermedi?

```sql
SELECT id, name, operator_name FROM robots WHERE id = 9;
```

```
 id |  name   | operator_name
----+---------+---------------
  9 | Mars-03 |
(1 row)
```

**NULL, yabancı anahtarı ihlal etmez.** "Bu robotun operatörü henüz bilinmiyor" geçerli bir durumdur. Operatör atamasının zorunlu olmasını istiyorsan sütuna ayrıca `NOT NULL` koyarsın.

Sonuç olarak FK'nin ikinci yüzü de var. Zeynep'in robotu varken Zeynep'i silmeyi dene:

```sql
DELETE FROM operators WHERE operator_name = 'Zeynep';
```

```
ERROR:  update or delete on table "operators" violates foreign key constraint "robots_operator_name_fkey" on table "robots"
DETAIL:  Key (operator_name)=(Zeynep) is still referenced from table "robots".
```

(FK'yi eklemeden önce aynı komut sessizce çalışırdı ve `robots` tablosunda sahipsiz bir "Zeynep" kalırdı. Bu denemeyi FK varken yap; temiz bir başlangıç için bu notun başındaki yöntemi kullan.)

### 2.3 FK gerçek veride neden bazen eklenemez

`llm_ops` tarafında aynı işi deneyelim. `llm_calls.model_name`, `model_catalog`'a bağlı olmalı:

```sql
ALTER TABLE llm_calls ADD FOREIGN KEY (model_name) REFERENCES model_catalog (model_name);
```

```
ERROR:  insert or update on table "llm_calls" violates foreign key constraint "llm_calls_model_name_fkey"
DETAIL:  Key (model_name)=(gemini-pro) is not present in table "model_catalog".
```

Hafta 6'daki o kayıp çağrı: `gemini-pro` kullanılmış ama katalogda yok. Mevcut bir veride kısıt eklemek, kısıtın **veriyi geriye dönük denetlemesi** demek. İki çözüm yolu var:

1. **Kataloğa ekle** (model gerçekten kullanılıyorsa). Fiyat değeri uydurmadır, gerçek fiyat değildir:

```sql
INSERT INTO model_catalog (model_name, provider, price_per_1k_usd, context_window)
VALUES ('gemini-pro', 'Google', 0.00050, 32000);
ALTER TABLE llm_calls ADD CONSTRAINT llm_calls_model_fk FOREIGN KEY (model_name) REFERENCES model_catalog (model_name);
```

```
INSERT 0 1
ALTER TABLE
```

2. **Çağrıyı düzelt** (yanlış yazılmış bir adsa).

Bundan sonra katalogda olmayan bir modelle çağrı yazılamaz:

```sql
INSERT INTO llm_calls (id, model_name, user_name, task_type, prompt_tokens, completion_tokens, latency_ms, cost_usd, created_at)
VALUES (13, 'gpt-5', 'Ece', 'chat', 100, 50, 500, 0.001, now());
```

```
ERROR:  insert or update on table "llm_calls" violates foreign key constraint "llm_calls_model_fk"
DETAIL:  Key (model_name)=(gpt-5) is not present in table "model_catalog".
```

### 2.4 Tipler hakkında iki not

| Tip | Ne zaman | Dikkat |
|---|---|---|
| `integer` / `bigint` | Sayaçlar, id'ler | `integer` yaklaşık 2 milyara kadar |
| `numeric(p,s)` | Para, tam ondalık | Yavaş ama **tam** |
| `real` / `double precision` | Ölçümler | Yaklaşık değer |
| `text` | Serbest metin | `varchar(n)` ile performans farkı yok |
| `boolean`, `date`, `timestamptz` | Evet/hayır, tarih, zamanlı olay | Zaman için `timestamptz` seç |

`double precision` ile "yaklaşık" ne demek:

```sql
SELECT 0.1::double precision + 0.2::double precision = 0.3::double precision AS double_esit_mi;
SELECT (0.1::numeric + 0.2::numeric) = 0.3::numeric AS numeric_esit_mi;
```

```
 double_esit_mi
----------------
 f

 numeric_esit_mi
-----------------
 t
```

`0.1 + 0.2`, kayan noktalı (`double precision`) sayıda 0.3'e **eşit değil**. Para tutarını `numeric` ile sakla. (`real` tipinde bu özel örnek tesadüfen `t` verir; kural yine aynı: para için `numeric`.)

### 2.5 Sıfırdan bir tablo: bütün kısıtlar bir arada

`robot_fleet` içinde robot bakım kaydı için yeni bir tablo kuralım:

```sql
CREATE TABLE maintenance_log (
  id          integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  robot_id    integer NOT NULL REFERENCES robots (id) ON DELETE CASCADE,
  ticket_no   text    NOT NULL UNIQUE,
  cost_try    numeric(10,2) NOT NULL CHECK (cost_try >= 0),
  is_done     boolean NOT NULL DEFAULT false,
  opened_on   date    NOT NULL DEFAULT current_date
);
```

```
\d maintenance_log
                         Table "public.maintenance_log"
  Column   |     Type      | Collation | Nullable |           Default
-----------+---------------+-----------+----------+------------------------------
 id        | integer       |           | not null | generated always as identity
 robot_id  | integer       |           | not null |
 ticket_no | text          |           | not null |
 cost_try  | numeric(10,2) |           | not null |
 is_done   | boolean       |           | not null | false
 opened_on | date          |           | not null | CURRENT_DATE
Indexes:
    "maintenance_log_pkey" PRIMARY KEY, btree (id)
    "maintenance_log_ticket_no_key" UNIQUE CONSTRAINT, btree (ticket_no)
Check constraints:
    "maintenance_log_cost_try_check" CHECK (cost_try >= 0::numeric)
Foreign-key constraints:
    "maintenance_log_robot_id_fkey" FOREIGN KEY (robot_id) REFERENCES robots(id) ON DELETE CASCADE
```

| Kısıt | Ne koruyor |
|---|---|
| `GENERATED ALWAYS AS IDENTITY` | Id'yi PostgreSQL üretir, sen elle vermezsin (`serial`'in modern karşılığı) |
| `REFERENCES robots (id)` | Olmayan robota bakım kaydı yazılmaz |
| `ON DELETE CASCADE` | Robot silinirse kayıtları da silinir |
| `UNIQUE` | Aynı fiş numarası iki kez girilmez |
| `CHECK (cost_try >= 0)` | Negatif maliyet girilmez |
| `DEFAULT` | Verilmeyen sütuna değer atanır |

Başarılı bir ekleme ve `RETURNING`:

```sql
INSERT INTO maintenance_log (robot_id, ticket_no, cost_try) VALUES (4, 'BK-001', 1500.50)
RETURNING id, robot_id, is_done, opened_on = current_date AS bugun_mu;
```

```
 id | robot_id | is_done | bugun_mu
----+----------+---------+----------
  1 |        4 | f       | t
```

### 2.6 Bilinçli dört ihlal

```sql
INSERT INTO maintenance_log (robot_id, ticket_no, cost_try) VALUES (4, 'BK-001', 200);   -- 1
INSERT INTO maintenance_log (robot_id, ticket_no, cost_try) VALUES (99, 'BK-002', 200);  -- 2
INSERT INTO maintenance_log (robot_id, ticket_no, cost_try) VALUES (4, NULL, 200);       -- 3
INSERT INTO maintenance_log (robot_id, ticket_no, cost_try) VALUES (4, 'BK-003', -5);    -- 4
```

```
ERROR:  duplicate key value violates unique constraint "maintenance_log_ticket_no_key"
DETAIL:  Key (ticket_no)=(BK-001) already exists.

ERROR:  insert or update on table "maintenance_log" violates foreign key constraint "maintenance_log_robot_id_fkey"
DETAIL:  Key (robot_id)=(99) is not present in table "robots".

ERROR:  null value in column "ticket_no" of relation "maintenance_log" violates not-null constraint
DETAIL:  Failing row contains (4, 4, null, 200.00, f, 2026-11-23).

ERROR:  new row for relation "maintenance_log" violates check constraint "maintenance_log_cost_try_check"
DETAIL:  Failing row contains (5, 4, BK-003, -5.00, f, 2026-11-23).
```

Bir de yazım hatası türü: `id`'yi elle vermeyi dene:

```sql
INSERT INTO maintenance_log (id, robot_id, ticket_no, cost_try) VALUES (1, 4, 'BK-004', 10);
```

```
ERROR:  cannot insert a non-DEFAULT value into column "id"
DETAIL:  Column "id" is an identity column defined as GENERATED ALWAYS.
HINT:  Use OVERRIDING SYSTEM VALUE to override.
```

Dikkat edersen üçüncü ve dördüncü hatadaki "Failing row" satırında `id` **4** ve **5** yazıyor. Başarısız eklemeler de sayaç numarası tüketir. Yani identity sütunlarında numaralar arasında **boşluk** olması hata değil, normal.

Bu dört hatadan üçü veriyi korudu (tekrar, olmayan robot, negatif tutar), biri (NULL) bir kuralı hatırlattı, `GENERATED ALWAYS` ise yazım disiplini. Kısıtlar, veritabanının uygulamandaki hatalara karşı **son savunma hattıdır**.

### 2.7 CASCADE ne yapar

```sql
INSERT INTO maintenance_log (robot_id, ticket_no, cost_try) VALUES (7, 'BK-005', 300);
SELECT count(*) AS log_sayisi FROM maintenance_log;
DELETE FROM robots WHERE id = 7;
SELECT count(*) AS log_sayisi_sonra FROM maintenance_log;
```

```
 log_sayisi
------------
          2

DELETE 1

 log_sayisi_sonra
------------------
                1
```

Atlas-03 silinince bakım kaydı da **sessizce** gitti. (Atlas-03'ün görevi olmadığı için `missions` engel olmadı.) Yararlı olabilir ama tehlikeli:

| Davranış | Robot silinirse bakım kaydına ne olur | Ne zaman |
|---|---|---|
| `RESTRICT` / `NO ACTION` (varsayılan davranış) | Silme reddedilir | Geçmiş kayıt değerliyse (finans, denetim) |
| `CASCADE` | Kayıt da silinir | Kayıt tek başına anlamsızsa (sipariş ve kalemleri) |
| `SET NULL` | Kayıtta `robot_id` boşalır | Kayıt kalsın ama sahibi yok olabilsin |

**CASCADE'in kaybettirdiği:** operatörlere `CASCADE` verirsen bir operatör silindiğinde robotları da silinir. Bunu hiç istemezsin: robot filonun donanımıdır, operatör ise sadece birinin işe giriş kaydı.

### 2.8 Bağımlılık sırası

```sql
DROP TABLE robots;
```

```
ERROR:  cannot drop table robots because other objects depend on it
DETAIL:  constraint missions_robot_id_fkey on table missions depends on table robots
constraint maintenance_log_robot_id_fkey on table maintenance_log depends on table robots
HINT:  Use DROP ... CASCADE to drop the dependent objects too.
```

Önce **bağlı** tabloyu, sonra **ana** tabloyu sil:

```sql
DROP TABLE IF EXISTS maintenance_log, missions, robots;
```

`data/*.sql` dosyalarının başındaki `DROP TABLE` sırasına bak (`missions`, `robots`, `operators`): kurulumun tersi.

### 2.9 Migration: dosya iki kez çalışınca aynı sonuç

Şemayı elle değil, dosyayla yönetiriz. Başlığı şöyle bir `migrations/001_create_tables.sql`:

```sql
-- migrations/001_create_tables.sql
DROP TABLE IF EXISTS maintenance_log;
CREATE TABLE maintenance_log (
  id        integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  robot_id  integer NOT NULL REFERENCES robots (id) ON DELETE RESTRICT,
  note      text
);
ALTER TABLE maintenance_log ADD COLUMN IF NOT EXISTS opened_on date NOT NULL DEFAULT current_date;
```

```bash
psql -d robot_fleet -v ON_ERROR_STOP=1 -f migrations/001_create_tables.sql   # 1. çalıştırma: çıkış kodu 0
psql -d robot_fleet -v ON_ERROR_STOP=1 -f migrations/001_create_tables.sql   # 2. çalıştırma: çıkış kodu 0
```

`DROP TABLE IF EXISTS` olmayan bir dosyanın (yalnızca `CREATE TABLE` içeren) ikinci çalıştırması şuna benzer bir hatayla biter (tablo adı sende farklı olur):

```
ERROR:  relation "maintenance_log2" already exists
```

(`-v ON_ERROR_STOP=1` verirsen `psql` hata görünce durur ve çıkış kodu 0 olmaz; otomasyonda şart.)

Şema bir dosyada (migration), örnek veri başka bir dosyada (seed) durur: şemayı değiştirmek için veriyi silmek zorunda kalmazsın.

**Senin projende:** (1) ERD'ndeki bir ana tablo ve bağlı tablo için silme davranışını seç ve **bir cümleyle gerekçelendir** (raporundaki şema gerekçesinin ham maddesi). (2) `migrations/001_create_tables.sql` dosyasını aç, başlık yorumunu yaz, `DROP TABLE IF EXISTS` satırlarını (önce bağlı tablo!) ekle, en az iki bağlı tabloyu `CREATE TABLE` ile kur: PK, FK, 3 `NOT NULL`, 1 `UNIQUE`, 1 `CHECK`, 1 `DEFAULT`. (3) `denemeler/kisit-denemeleri.sql` dosyasına 4 bilinçli ihlali ve aldığın hata mesajlarını yorum olarak yaz.

## 3. Hile kâğıdı

| İş | Komut |
|---|---|
| Sıfırdan başla | `dropdb db; createdb db; psql -d db -f dosya.sql` |
| Kısıt eklemek | `ALTER TABLE t ADD FOREIGN KEY (c) REFERENCES p (c)` |
| Silme sırası | Önce bağlı tablo, sonra ana tablo |

## Terim sözlüğü

| English | Türkçe | Bu notta |
|---|---|---|
| DDL | veri tanımlama dili | `CREATE`, `ALTER`, `DROP` |
| constraint | kısıt | PK, FK, `NOT NULL`, `UNIQUE`, `CHECK` |
| cascade / restrict / set null | silme davranışları | FK'nin silmede ne yapacağı |
| migration | göç dosyası | Şemayı dosyayla yönetmek |

## Hafta 10'a geçiş

Bu hafta kurduğun şema boştu. Hafta 10'da ona veri yüklüyor (`INSERT`, `\copy`), güvenle değiştiriyor (`UPDATE`, transaction) ve sorguluyorsun (alt sorgu, CTE).
