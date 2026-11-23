# Hafta 10 ders notu: DML, transaction ve alt sorgular

> Haftanın ders notu ve metin sürümü. Buradaki bütün sorgular `robot_fleet` ve `llm_ops` veritabanlarında PostgreSQL 18 ile çalıştırılmıştır ve gösterilen sonuçlar gerçek çıktılardır (zaman damgası, `cost` ve `Buffers` gibi sayılar sende biraz farklı çıkabilir). Kurulum: [data/README.md](../../data/README.md)

> Hafta 9'da kurduğun şemanın içini bu hafta dolduruyorsun. Bir de sorguları adım adım yazmayı öğreniyorsun.

## Bu haftanın haritası

```
veri doldur → güvenle değiştir → sorgula
  (DML)       (transaction)      (alt sorgu, CTE)
```

Her bölümün sonunda **"Senin projende"** diye bir adım var. Örnek veritabanında gösteriyoruz, sen aynısını Hafta 9'da kurduğun kendi şemanda yapıyorsun.

## 1. Başlamadan: temiz başlangıç

Bu notun bölümleri (2, 3 ve 4) örnek veritabanını **temiz** yüklenmiş varsayar: bir bölümde veriyi değiştirdiysen (ör. `UPDATE`, `INSERT`) sonraki bölümün sonuçları farklı çıkabilir. Her bölüme başlarken veritabanını baştan kurmak en güvenlisidir. `data/*.sql` dosyalarını tek başına yeniden çalıştırmak, sonradan eklediğin tablo ya da görünüm yüzünden hata verebilir; `dropdb` ve `createdb` ile baştan başla:

```bash
dropdb --if-exists robot_fleet
createdb robot_fleet
psql -d robot_fleet -f data/robot_fleet.sql
dropdb --if-exists llm_ops
createdb llm_ops
psql -d llm_ops -f data/llm_ops.sql
```

```sql
\dt
SELECT count(*) FROM robots;     --> 10
SELECT count(*) FROM missions;   --> 14
SELECT count(*) FROM operators;  --> 10
```

`\dt` tabloları listeler, `\d robots` tek bir tablonun sütunlarını ve kısıtlarını gösterir.

**Senin projende:** Hafta 9'da kurduğun veritabanı ve `migrations/001_create_tables.sql` dosyan hazır olmalı. Tablolar yoksa dosyayı yeniden çalıştır: `psql -d benim_projem -f migrations/001_create_tables.sql` (Hafta 9'da kullandığın veritabanı adıyla).

## 2. DML: veriyi eklemek, değiştirmek, silmek

### 2.1 Altın kural: önce SELECT, sonra UPDATE

Hasarı önceden görmenin en ucuz yolu aynı `WHERE` ile önce saymaktır.

```sql
SELECT count(*) FROM robots WHERE zone = 'Depo A';
```

```
 count
-------
     2
```

İki satır. Şimdi gerçek güncelleme:

```sql
UPDATE robots SET zone = 'Depo C' WHERE zone = 'Depo A';
```

```
UPDATE 2
```

`UPDATE 2` sayısı `SELECT count(*)` ile **aynı mı**? Aynı. Eğer fark olsaydı durup bakacaktın.

```sql
SELECT id, name, zone FROM robots WHERE zone = 'Depo C' ORDER BY id;
```

```
 id |   name   |  zone
----+----------+--------
  1 | Atlas-01 | Depo C
  7 | Atlas-03 | Depo C
```

**WHERE unutursan?** Bunu bir transaction içinde gösteriyorum (Bölüm 3'te ayrıntısı var):

```sql
BEGIN;
UPDATE robots SET zone = 'Depo C';
SELECT zone, count(*) FROM robots GROUP BY zone;
ROLLBACK;
```

```
BEGIN
UPDATE 10
  zone  | count
--------+-------
 Depo C |    10
ROLLBACK
```

Hepsi 10 satır. NULL bölgeli Mars-03 bile `Depo C` oldu (`WHERE` yoksa NULL'a da yazılır). `UPDATE 10` mesajı alarm olmalı.

**Sınıf kuralı: her `UPDATE` ve `DELETE`'ten önce `SELECT count(*)`.**

### 2.2 INSERT, RETURNING, çok satır, INSERT ... SELECT

```sql
INSERT INTO operators (operator_name, phone, shift, hired_at)
VALUES ('Melis', '0532 000 0011', 'gece', '2026-11-02')
RETURNING *;
```

```
 operator_name |     phone     | shift |  hired_at
---------------+---------------+-------+------------
 Melis         | 0532 000 0011 | gece  | 2026-11-02
```

`RETURNING`, eklenen (ya da güncellenen) satırı geri verir: id'yi ayrıca sorgulamana gerek kalmaz.

Aynı anahtarla ikinci eklemeyi deneyelim:

```sql
INSERT INTO operators (operator_name, phone, shift, hired_at) VALUES ('Melis', '0532 000 0099', 'gündüz', '2026-11-03');
```

```
ERROR:  duplicate key value violates unique constraint "operators_pkey"
DETAIL:  Key (operator_name)=(Melis) already exists.
```

Çok satır ve `INSERT ... SELECT`:

```sql
INSERT INTO operators (operator_name, phone, shift, hired_at) VALUES
  ('Orhan', '0532 000 0012', 'gündüz', '2026-11-09'),
  ('Pınar', '0532 000 0013', 'gece',   '2026-11-09')
RETURNING operator_name;

CREATE TABLE gece_operatorleri AS SELECT * FROM operators WHERE false;   -- yalnızca yapıyı kopyalar
INSERT INTO gece_operatorleri SELECT * FROM operators WHERE shift = 'gece' RETURNING operator_name;
```

```
 operator_name
---------------
 Orhan
 Pınar
INSERT 0 2

SELECT 0

 operator_name
---------------
 Can
 Şule
 İsmail
 Emre
 Melis
 Pınar
INSERT 0 6
```

### 2.3 UPSERT: varsa güncelle, yoksa ekle

```sql
INSERT INTO operators (operator_name, phone, shift, hired_at)
VALUES ('Melis', '0532 000 0099', 'gündüz', '2026-11-03')
ON CONFLICT (operator_name) DO UPDATE SET phone = EXCLUDED.phone, shift = EXCLUDED.shift
RETURNING *;
```

```
 operator_name |     phone     | shift  |  hired_at
---------------+---------------+--------+------------
 Melis         | 0532 000 0099 | gündüz | 2026-11-02
```

`EXCLUDED`, "eklemeye çalıştığım satır" demek. Telefon ve vardiya güncellendi, `hired_at` bilerek güncellenmedi: **hangi sütunların güncelleneceğini sen seçersin**.

`llm_ops` üzerinde aynı iş (fiyatlar uydurmadır, gerçek fiyat değildir):

```sql
INSERT INTO model_catalog (model_name, provider, price_per_1k_usd, context_window) VALUES ('gpt-4o', 'OpenAI', 0.02000, 128000);
```

```
ERROR:  duplicate key value violates unique constraint "model_catalog_pkey"
DETAIL:  Key (model_name)=(gpt-4o) already exists.
```

```sql
INSERT INTO model_catalog (model_name, provider, price_per_1k_usd, context_window) VALUES ('gpt-4o', 'OpenAI', 0.02000, 128000)
ON CONFLICT (model_name) DO UPDATE SET price_per_1k_usd = EXCLUDED.price_per_1k_usd RETURNING *;
```

```
 model_name | provider | price_per_1k_usd | context_window
------------+----------+------------------+----------------
 gpt-4o     | OpenAI   |          0.02000 |         128000
```

Çakışmada **hiçbir şey yapma** demek istersen `ON CONFLICT (model_name) DO NOTHING` yazılır (sonuç `INSERT 0 0`).

### 2.4 DELETE ve TRUNCATE

Test için eklediğin satırı sil, sadece onu:

```sql
SELECT count(*) FROM operators WHERE operator_name = 'Orhan';
DELETE FROM operators WHERE operator_name = 'Orhan';
```

```
 count
-------
     1
DELETE 1
```

`TRUNCATE` tabloyu tamamen boşaltır, ama FK ile bağlı tabloda tek başına çalışmaz:

```sql
TRUNCATE robots;
```

```
ERROR:  cannot truncate a table referenced in a foreign key constraint
DETAIL:  Table "missions" references "robots".
HINT:  Truncate table "missions" at the same time, or use TRUNCATE ... CASCADE.
```

Doğrusu **birlikte** boşaltmak. Aşağıda transaction içinde gösteriyorum ki verini kaybetmeyelim:

```sql
BEGIN;
TRUNCATE robots, missions;
SELECT (SELECT count(*) FROM robots) AS robots, (SELECT count(*) FROM missions) AS missions;
ROLLBACK;
SELECT (SELECT count(*) FROM robots) AS robots, (SELECT count(*) FROM missions) AS missions;
```

```
 robots | missions
--------+----------
      0 |        0
ROLLBACK
 robots | missions
--------+----------
     10 |       14
```

Alternatif: önce bağlı tabloyu (`DELETE FROM missions`) sonra ana tabloyu boşalt.

### 2.5 CSV'den toplu yükleme: `\copy`

`\copy`, **psql'in kendi komutudur** (SQL değil), dosyayı senin bilgisayarından okur. Sunucu yetkisi gerekmez. Tek satır yazılır:

```
\copy tablo_adi FROM 'dosya.csv' CSV HEADER
```

Örnek: iki satırlık bir CSV'yi geçici bir tabloya yükleyelim. CSV:

```
model_name,provider,price_per_1k_usd,context_window
deneme-a,Test,0.00100,4096
deneme-b,Test,,8192
```

```sql
CREATE TEMP TABLE yuk (LIKE model_catalog);
\copy yuk FROM 'kurs.csv' CSV HEADER
SELECT * FROM yuk;
```

```
CREATE TABLE
COPY 2
 model_name | provider | price_per_1k_usd | context_window
------------+----------+------------------+----------------
 deneme-a   | Test     |          0.00100 |           4096
 deneme-b   | Test     |                  |           8192
```

Boş hücre (`,,`) NULL olarak yüklendi.

**Dört tipik sorun:**

| Sorun | Belirti | Çare |
|---|---|---|
| Sütun sırası şemadan farklı | Yanlış sütuna veri ya da tip hatası | Sütun listesini açık yaz: `\copy tablo (a, b, c) FROM ...` |
| Boş hücre | NOT NULL ihlali | O sütundaki boşluklara karar ver |
| Tarih biçimi (`27.11.2026`) | `invalid input syntax for type date` | CSV'yi ISO biçime (`2026-11-27`) çevir |
| Türkçe karakter bozuk | `ş`, `İ` yerine garip işaretler | Dosyayı UTF-8 kaydet |

Yükleme sırası: **ana tablo önce**, bağlı tablo sonra (FK sırayı belirler). Önce 10 satırla dene.

**Senin projende:** (1) Kendi CSV'nin ilk satırlarına bak: sütun sırası şemanla aynı mı? (2) `\copy` ile yükle ve `SELECT count(*)` ile satır sayısını doğrula. (3) Bir `UPDATE` için önce `SELECT count(*)`, sonra `UPDATE`. (4) `INSERT ... RETURNING` ile bir satır ekle. (5) UPSERT: aynı anahtarlı satırı `ON CONFLICT (...) DO UPDATE` ile güncelle. Hepsini `denemeler/dml-denemeleri.sql` taslağına yaz, her komutun üstüne "ne yaptım, neden" yorumu.

## 3. Transaction: ya hep ya hiç

Bir transaction, birbirine bağlı adımları tek işlem yapar. Aynı satırı iki kere değiştirmek yerine: ya **ikisi de olur** ya **hiçbiri**.

| Komut | Ne yapar |
|---|---|
| `BEGIN` | İşlemi başlat |
| `COMMIT` | Değişiklikleri kalıcı yap |
| `ROLLBACK` | Hepsini geri al |
| `SAVEPOINT ad` / `ROLLBACK TO ad` | İşlemin ortasında bir "kayıt noktası" |

### 3.1 Hasarı gör, geri al

Bilerek yanlış bir `UPDATE` yazalım (`WHERE` yok):

```sql
SELECT count(*) FILTER (WHERE battery_level = 100) AS yuz_olan,
       count(*) FILTER (WHERE battery_level IS NULL) AS bos_olan,
       count(*) AS toplam
FROM robots;
```

```
 yuz_olan | bos_olan | toplam
----------+----------+--------
        0 |        1 |     10
```

```sql
BEGIN;
UPDATE robots SET battery_level = 100;
SELECT count(*) FILTER (WHERE battery_level = 100) AS yuz_olan,
       count(*) FILTER (WHERE battery_level IS NULL) AS bos_olan
FROM robots;
ROLLBACK;
SELECT count(*) FILTER (WHERE battery_level = 100) AS yuz_olan,
       count(*) FILTER (WHERE battery_level IS NULL) AS bos_olan,
       sum(battery_level) AS toplam
FROM robots;
```

```
BEGIN
UPDATE 10
 yuz_olan | bos_olan
----------+----------
       10 |        0
ROLLBACK
 yuz_olan | bos_olan | toplam
----------+----------+--------
        0 |        1 |    381
```

Hasar: 10 robotun hepsi `100`, **Kartal-04'ün boş bataryası bile 100 oldu** (bilgi yok iken "tam dolu" bilgisi uydurduk). `ROLLBACK` sonrası 381 toplam, yani Hafta 5'te bulduğumuz değer, geri geldi.

### 3.2 SAVEPOINT

```sql
BEGIN;
UPDATE robots SET status = 'maintenance' WHERE id = 2;
SAVEPOINT adim2;
UPDATE robots SET status = 'offline';
SELECT status, count(*) FROM robots GROUP BY status ORDER BY status;
ROLLBACK TO adim2;
SELECT id, name, status FROM robots WHERE id IN (1, 2) ORDER BY id;
COMMIT;
```

```
BEGIN
UPDATE 1
SAVEPOINT
UPDATE 10
 status  | count
---------+-------
 offline |    10
ROLLBACK
 id |   name   |   status
----+----------+-------------
  1 | Atlas-01 | active
  2 | Atlas-02 | maintenance
COMMIT
```

İkinci (yanlış) adım geri alındı, birinci (Atlas-02 bakıma alındı) kaldı ve `COMMIT` ile kalıcı oldu.

### 3.3 COMMIT'ten sonra ROLLBACK ne yapar?

```sql
UPDATE robots SET status = 'charging' WHERE id = 2;
ROLLBACK;
SELECT id, status FROM robots WHERE id = 2;
```

```
UPDATE 1
WARNING:  there is no transaction in progress
ROLLBACK
 id |  status
----+----------
  2 | charging
```

`BEGIN` yazmadıysan her komut **kendi başına bir transaction'dır ve hemen COMMIT edilir** (autocommit). `ROLLBACK` bu `UPDATE`'i geri almaz. Güvenli alışkanlık: riskli işe `BEGIN` ile başla.

### 3.4 İşlem içinde hata

```sql
BEGIN;
UPDATE robots SET battery_level = 50 WHERE id = 1;
SELECT 1/0;
UPDATE robots SET battery_level = 60 WHERE id = 1;
COMMIT;
SELECT id, battery_level FROM robots WHERE id = 1;
```

```
BEGIN
UPDATE 1
ERROR:  division by zero
ERROR:  current transaction is aborted, commands ignored until end of transaction block
ROLLBACK
 id | battery_level
----+---------------
  1 |            82
```

Hata olunca transaction "bozuk" duruma geçer, sonraki komutlar reddedilir ve `COMMIT` yazsan bile `ROLLBACK` yapılır. Atlas-01'in bataryası **82** kaldı, 50 ya da 60 olmadı.

### 3.5 Atomiklik: iki adım birlikte

Bir görevi bitirmek ve robotu şarja almak birbirine bağlı iki adım:

```sql
BEGIN;
UPDATE missions SET status = 'completed', duration_min = 30 WHERE id = 7 RETURNING id, status, duration_min;
UPDATE robots SET status = 'charging' WHERE id = 3 RETURNING id, status;
COMMIT;
```

```
BEGIN
 id |  status   | duration_min
----+-----------+--------------
  7 | completed |           30
UPDATE 1
 id |  status
----+----------
  3 | charging
UPDATE 1
COMMIT
```

### 3.6 ACID, dört harf bir cümle

| Harf | Anlamı | Bu notta örnek |
|---|---|---|
| **A**tomiklik | Ya hep ya hiç | 3.1 ve 3.5 |
| **C**onsistency (tutarlılık) | Kısıtlar bozulmaz | Hata olunca işlem geri alınır, kısıtlar korunur |
| **I**solation (yalıtım) | Eşzamanlı işlemler birbirini yarım hâlde görmez | Başka bir oturum `COMMIT`'e kadar değişikliğini göremez |
| **D**urability (kalıcılık) | `COMMIT` sonrası kalır | 3.2 |

Bu derste A ve D'ye ağırlık veriyoruz.

**Senin projende:** "Projemde hangi iki adım ya hep ya hiç olmalı?" (örnek: sipariş + sipariş kalemleri). Bunu `dml-denemeleri.sql` dosyasının 2. bölümüne yaz: bilerek yanlış bir `UPDATE` yap, hasarı `SELECT` ile gör, `ROLLBACK` ile geri al.

## 4. Alt sorgu ve CTE

### 4.1 Skaler alt sorgu

"Ortalama bataryanın altındaki robotlar." Ortalamayı elle yazmak yerine sorgunun içine koy:

```sql
SELECT round(avg(battery_level), 1) AS ort FROM robots;

SELECT name, battery_level
FROM robots
WHERE battery_level < (SELECT avg(battery_level) FROM robots)
ORDER BY battery_level, name;
```

```
 ort
------
 42.3

   name    | battery_level
-----------+---------------
 Atlas-03  |             0
 Mars-02   |             9
 Atlas-02  |            15
 Kartal-01 |            18
```

`avg` NULL'ı **atlar**: Kartal-04'ün boş bataryası ortalamaya girmedi (381 / 9 = 42.3). Bu satır da sonuçta yok, çünkü `NULL < 42.3` bilinmeyen sayılır.

### 4.2 IN ve EXISTS

Görevi olan robotlar, iki farklı yazımla aynı sonuç:

```sql
SELECT name FROM robots WHERE id IN (SELECT robot_id FROM missions) ORDER BY id;

SELECT name FROM robots r
WHERE EXISTS (SELECT 1 FROM missions m WHERE m.robot_id = r.id)
ORDER BY id;
```

```
   name
-----------
 Atlas-01
 Atlas-02
 Kartal-01
 Mars-01
 Mars-02
 Kartal-03
(6 rows)
```

### 4.3 Tuzak: NOT IN ve NULL

Hiçbir robotu olmayan operatörler:

```sql
SELECT operator_name FROM operators
WHERE operator_name NOT IN (SELECT operator_name FROM robots);
```

```
 operator_name
---------------
(0 rows)
```

**Boş!** Ama Kerem'in robotu yok. Neden? `robots.operator_name` içinde Mars-03'ün NULL'ı var. `x NOT IN (a, b, NULL)` ifadesi, NULL ile karşılaştırma "bilinmiyor" döndürdüğü için hiçbir satırı geçirmez:

```sql
SELECT 1 WHERE 5 IN (1, NULL);      --> 0 satır (5, 1'e eşit değil, NULL'a eşit mi bilinmiyor)
SELECT 1 WHERE 5 NOT IN (1, NULL);  --> 0 satır
```

`NOT EXISTS` bu sorunu yaşamaz:

```sql
SELECT operator_name FROM operators o
WHERE NOT EXISTS (SELECT 1 FROM robots r WHERE r.operator_name = o.operator_name);
```

```
 operator_name
---------------
 Kerem
```

`NOT IN` yazmakta ısrar edersen alt sorguda NULL'ı ele:

```sql
SELECT operator_name FROM operators
WHERE operator_name NOT IN (SELECT operator_name FROM robots WHERE operator_name IS NOT NULL);
```

```
 operator_name
---------------
 Kerem
```

Bu, Hafta 5'teki NULL dersinin aynısı, başka bir kılıkta. Aynı yapı, NULL içermeyen sütunda sorun çıkarmaz (hiç görevi olmayan robotlar için `NOT IN (SELECT robot_id FROM missions)` doğru çalışır, çünkü `missions.robot_id` NULL içermiyor), ama bunu **garanti etmek senin işin** değil; `NOT EXISTS` yaz.

| | `IN` / `NOT IN` | `EXISTS` / `NOT EXISTS` |
|---|---|---|
| NULL içeren alt sorgu | `NOT IN` boş döner | Sorunsuz |
| Okunurluk | Basit "listede mi" | Koşullu "var mı" |

### 4.4 CTE ile sorguyu parçalara bölmek

`WITH`, bir ara sonuca isim verir. Üç ve daha çok görevi olan robotlar:

```sql
WITH gorev_sayisi AS (
  SELECT robot_id, count(*) AS n FROM missions GROUP BY robot_id
)
SELECT r.name, g.n
FROM robots r
JOIN gorev_sayisi g ON g.robot_id = r.id
WHERE g.n >= 3
ORDER BY r.name;
```

```
   name    | n
-----------+---
 Atlas-01  | 3
 Kartal-01 | 3
 Kartal-03 | 3
```

Bölge başına biten görev sayısı ve toplam süre:

```sql
WITH bitenler AS (
  SELECT robot_id, duration_min FROM missions WHERE status = 'completed'
)
SELECT r.zone, count(b.robot_id) AS biten, sum(b.duration_min) AS dk
FROM robots r
LEFT JOIN bitenler b ON b.robot_id = r.id
GROUP BY r.zone
ORDER BY biten DESC, r.zone;
```

```
   zone   | biten | dk
----------+-------+-----
 Depo B   |     3 | 215
 Dış Alan |     3 | 190
 Depo A   |     2 | 135
 Şarj     |     1 |  60
 Atölye   |     0 |
          |     0 |
```

Hafta 6'dan: `LEFT JOIN` sonrası `count(sağ.sütun)`. Atölye ve NULL bölge (Mars-03) listede kalıyor, sayıları 0.

### 4.5 CTE ile YZ tarafı: ortalamanın üstündeki modeller

Önce her modelin toplam maliyetini ara adım yap, sonra ortalamanın üstündekileri seç. (`llm_ops` veritabanında.)

```sql
WITH model_maliyet AS (
  SELECT model_name, sum(cost_usd) AS toplam, count(*) AS cagri
  FROM llm_calls GROUP BY model_name
)
SELECT model_name, toplam, cagri
FROM model_maliyet
WHERE toplam > (SELECT avg(toplam) FROM model_maliyet)
ORDER BY toplam DESC;
```

```
  model_name   | toplam | cagri
---------------+--------+-------
 claude-sonnet | 0.0384 |     2
 gpt-4o        | 0.0179 |     3
```

Ortalama model maliyeti 0.00901 (7 model, `round(avg(...), 5)` ile doğrulandı). **gpt-4o** 3 çağrı yaptı ama bir çağrının maliyeti NULL (fatura gelmedi): toplam 0.0179, yani diğer iki çağrının toplamı. Rapora bu notu eklemeyi unutma.

**Senin projende:** Hafta 3'te yazdığın beş sorudan birini seç, önce ara adımını CTE olarak yaz, sonra asıl sorguyu CTE'nin üzerine kur. Taslak dosya `queries/analiz-01.sql`. Kontrol: `IN` ve `EXISTS` aynı sonucu ne zaman vermez? (cevap: `NOT IN`'de alt sorgu NULL içerdiğinde).

## 5. Hile kâğıdı

| İş | Komut |
|---|---|
| Güvenli DML | `SELECT count(*)` aynı `WHERE` ile, sonra `UPDATE` |
| Yükleme | `\copy tablo FROM 'dosya.csv' CSV HEADER` |
| UPSERT | `INSERT ... ON CONFLICT (anahtar) DO UPDATE SET ...` |
| Geri alınabilir işlem | `BEGIN; ...; ROLLBACK;` (veya `COMMIT;`) |
| Eşleşmeyeni bul | `NOT EXISTS` (`NOT IN` değil) |
| Ara adım | `WITH ad AS (...) SELECT ...` |

## Terim sözlüğü

| English | Türkçe | Bu notta |
|---|---|---|
| DML | veri işleme dili | `INSERT`, `UPDATE`, `DELETE` |
| upsert | varsa güncelle yoksa ekle | `ON CONFLICT` |
| transaction | işlem | `BEGIN` ... `COMMIT`/`ROLLBACK` |
| ACID | atomiklik, tutarlılık, yalıtım, kalıcılık | Bölüm 3.6 |
| subquery | alt sorgu | Parantez içindeki sorgu |
| CTE | ortak tablo ifadesi | `WITH` |

## Hafta 11'e geçiş

Bu hafta veriyi yükleyip değiştirdin ve sorguladın. Hafta 11'de aynı sorguları görünüme (view) çeviriyor, indeksle hızlandırıyor, rollerle koruyor ve projene bir yapay zeka bileşeni ekliyorsun.
