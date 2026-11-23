# Hafta 11 ders notu: Görünümler, indeks, güvenlik, yedek ve YZ bileşeni

> Haftanın ders notu ve metin sürümü. Buradaki bütün sorgular `robot_fleet` ve `llm_ops` veritabanlarında PostgreSQL 18 ile çalıştırılmıştır ve gösterilen sonuçlar gerçek çıktılardır (zaman damgası, `cost` ve `Buffers` gibi sayılar sende biraz farklı çıkabilir). Kurulum: [data/README.md](../../data/README.md)

> Dönemin son teknik haftası. Projeni teslime hazır hale getiren parçalar: görünüm, indeks, rol, yedek ve yapay zeka bileşeni.

## Bu haftanın haritası

```
görünüm/indeks → rol → yedekle → YZ ekle
 (view, EXPLAIN)  (GRANT)  (pg_dump)  (jsonb...)
```

Her bölümün sonunda **"Senin projende"** diye bir adım var. Örnek veritabanında gösteriyoruz, sen aynısını Hafta 9'da kurduğun ve Hafta 10'da doldurduğun kendi projenin üzerinde yapıyorsun.

## 1. Başlamadan: temiz başlangıç

Bu notun bölümleri (2-5) örnek veritabanlarını **temiz** yüklenmiş varsayar (ör. `llm_ops` içinde `gemini-pro` katalogda yok). Hafta 9 ve 10'daki denemelerde veriyi değiştirdiysen sonuçlar farklı çıkabilir; baştan kur:

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

Roller veritabanına değil sunucuya aittir: `dropdb` onları silmez (Bölüm 3'te ayrıntı).

**Senin projende:** Hafta 9'daki şeman ve Hafta 10'da yüklediğin veri hazır olmalı. `\dt` ve her tablo için `SELECT count(*)` ile kontrol et.

## 2. View, indeks, EXPLAIN

### 2.1 View: adlandırılmış sorgu

Kritik robot raporunu her seferinde baştan yazmak yerine ona bir isim verelim: aktif ve bataryası %20'nin altındaki robotlar ve operatörün telefonu.

```sql
CREATE VIEW critical_robots AS
SELECT r.id, r.name, r.zone, r.battery_level, r.operator_name, o.phone
FROM robots r
LEFT JOIN operators o ON o.operator_name = r.operator_name
WHERE r.status = 'active' AND r.battery_level < 20;

SELECT * FROM critical_robots ORDER BY id;
```

```
CREATE VIEW

 id |   name    |   zone   | battery_level | operator_name |     phone
----+-----------+----------+---------------+---------------+---------------
  3 | Kartal-01 | Dış Alan |            18 | Çağla         | 0532 000 0003
  6 | Mars-02   | Depo B   |             9 | Büşra         | 0532 000 0006
```

View **veri saklamaz**; her çağrıldığında sorgu yeniden çalışır. Bu yüzden veri değişince view de değişir. Mars-03'ün bataryasını düşürelim:

```sql
UPDATE robots SET battery_level = 5 WHERE id = 9;
SELECT id, name, phone FROM critical_robots ORDER BY id;
```

```
UPDATE 1
 id |   name    |     phone
----+-----------+---------------
  3 | Kartal-01 | 0532 000 0003
  6 | Mars-02   | 0532 000 0006
  9 | Mars-03   |
```

Mars-03 görünümde, ama telefonu NULL (operatörü yok). `LEFT JOIN` sayesinde satır kaybolmadı. `INNER JOIN` kullansaydık en kritik robot rapordan sessizce düşerdi. (Denemeden sonra `battery_level`'ı eski haline, 55'e, getir.)

İkinci bir view, JOIN ve filtreli sayım:

```sql
CREATE OR REPLACE VIEW mission_summary AS
SELECT r.id AS robot_id, r.name,
       count(m.id) AS gorev,
       count(m.id) FILTER (WHERE m.status = 'failed') AS basarisiz
FROM robots r
LEFT JOIN missions m ON m.robot_id = r.id
GROUP BY r.id, r.name;

SELECT * FROM mission_summary ORDER BY gorev DESC, name LIMIT 4;
```

```
 robot_id |   name    | gorev | basarisiz
----------+-----------+-------+-----------
        1 | Atlas-01  |     3 |         1
        3 | Kartal-01 |     3 |         1
        8 | Kartal-03 |     3 |         0
        5 | Mars-01   |     2 |         0
```

Materialized view (gerçekleştirilmiş görünüm) sonucu **saklayan** view'dir; ayrıca yenilenmesi gerekir. Şimdilik sadece bil.

### 2.2 İndeks ve EXPLAIN: küçük tablo

```sql
EXPLAIN SELECT * FROM robots WHERE status = 'active';
CREATE INDEX idx_robots_status ON robots (status);
EXPLAIN SELECT * FROM robots WHERE status = 'active';
```

```
                       QUERY PLAN
---------------------------------------------------------
 Seq Scan on robots  (cost=0.00..15.12 rows=2 width=168)
   Filter: (status = 'active'::text)

CREATE INDEX

                       QUERY PLAN
--------------------------------------------------------
 Seq Scan on robots  (cost=0.00..1.12 rows=1 width=168)
   Filter: (status = 'active'::text)
```

İndeks kurduk ve PostgreSQL yine de **Seq Scan** (tüm tabloyu tara) seçti. 10 satırlık tabloyu baştan sona okumak, indeks ağacına bakmaktan ucuz. Bu hata değil, **doğru karar** ve raporda böyle yazarsın: "Tablo küçük olduğu için planlayıcı indeksi kullanmadı." (`cost` sayıları senin makinende farklı olabilir; ilk planda tablo istatistiği henüz yoktu.)

### 2.3 Büyük tabloda fark

Denemek için 200 bin satırlık bir okuma tablosu üretelim:

```sql
CREATE TABLE sensor_readings AS
SELECT g AS id,
       (g % 10) + 1 AS robot_id,
       round((random() * 100)::numeric, 2) AS value,
       now() - (g || ' seconds')::interval AS read_at
FROM generate_series(1, 200000) AS g;
ANALYZE sensor_readings;

EXPLAIN SELECT * FROM sensor_readings WHERE id = 150000;
```

```
SELECT 200000
ANALYZE
                            QUERY PLAN
-------------------------------------------------------------------
 Seq Scan on sensor_readings  (cost=0.00..3780.00 rows=1 width=22)
   Filter: (id = 150000)
```

İndeks yokken 200 bin satırın hepsi taranıyor. İndeks ekle:

```sql
CREATE INDEX idx_sensor_id ON sensor_readings (id);
ANALYZE sensor_readings;
EXPLAIN SELECT * FROM sensor_readings WHERE id = 150000;
```

```
                                      QUERY PLAN
--------------------------------------------------------------------------------------
 Index Scan using idx_sensor_id on sensor_readings  (cost=0.42..8.44 rows=1 width=22)
   Index Cond: (id = 150000)
```

Tahmini maliyet **3780'den 8.44'e** düştü. `EXPLAIN` yalnızca planı **tahmin eder**; `EXPLAIN ANALYZE` sorguyu gerçekten çalıştırır ve süreyi ölçer:

```sql
EXPLAIN ANALYZE SELECT * FROM sensor_readings WHERE id = 150000;
```

```
 Index Scan using idx_sensor_id on sensor_readings  (cost=0.42..8.44 rows=1 width=22) (actual time=0.015..0.016 rows=1.00 loops=1)
   Index Cond: (id = 150000)
   Index Searches: 1
   Buffers: shared hit=1 read=3
 Planning Time: 0.010 ms
 Execution Time: 0.018 ms
```

Süre ve `Buffers` sayıları sende farklıdır, **bu normal**; sayıyı değil plan türünü (`Seq Scan` / `Index Scan`) oku.

Her indeks işe yaramaz:

```sql
EXPLAIN SELECT * FROM sensor_readings WHERE robot_id = 3;
```

```
 Seq Scan on sensor_readings  (cost=0.00..3780.00 rows=19867 width=22)
   Filter: (robot_id = 3)
```

Burada `robot_id` için indeks de olsa tabloda satırların onda biri eşleşiyor; PostgreSQL yine tarama seçebilir. İndeks **çok az satır döndüren** aramalarda işe yarar.

| İndeks | Artısı | Eksisi |
|---|---|---|
| Okuma | Aramayı hızlandırır | |
| Yazma | | Her `INSERT`/`UPDATE` indeksi de günceller (yavaşlar) |
| Yer | | Disk kaplar |

Uydurma hızlanma yazma: rapora sadece **gerçekten ölçtüğün** `EXPLAIN` çıktısını koy. Deneme tablosunu bitince sil: `DROP TABLE sensor_readings;`

**Senin projende:** (1) JOIN'li en az bir view: `migrations/002_views.sql`, her view'in üstüne hangi iş sorusuna cevap verdiğini yorum olarak yaz. (2) Bir indeks: `migrations/003_indexes.sql`, `EXPLAIN` çıktısını indeksten önce ve sonra not et. Tablon küçükse ve plan değişmediyse bunu dürüstçe yaz. Kontrol: Tablon küçükse indeks neden fark yaratmaz?

## 3. Roller, yetkiler ve SQL injection

### 3.1 Rol ve en az yetki ilkesi

**En az yetki ilkesi:** bir kullanıcı, bir uygulama, bir LLM aracı için işini yapmaya yetecek en dar yetkiyi ver. Bir raporlama botu `SELECT` yapabilir; `UPDATE`, `DELETE` ve `DROP` yapamaz.

```sql
CREATE ROLE app_readonly LOGIN PASSWORD 'sinif-sifresi';
```

Bu komutu iki kez çalıştırırsan ikinci seferde `role "app_readonly" already exists` hatası alırsın: **roller veritabanına değil sunucuya aittir**. Migration dosyasında tekrar çalıştırılabilir yazım:

```sql
SELECT 'CREATE ROLE app_readonly LOGIN PASSWORD ''sinif-sifresi'''
WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'app_readonly') \gexec
```

(`\gexec`, sorgunun ürettiği metni komut olarak çalıştırır. Rol zaten varsa sorgu 0 satır döner ve hiçbir şey yapılmaz.) Gerçek şifreyi repoya yazma; bu sınıf şifresidir.

Veritabanı adını sabit yazma: `current_database()` kullan.

```sql
SELECT format('GRANT CONNECT ON DATABASE %I TO app_readonly', current_database()) \gexec
GRANT USAGE ON SCHEMA public TO app_readonly;
GRANT SELECT ON robots, operators, missions, critical_robots TO app_readonly;
```

```
GRANT
GRANT
GRANT
```

### 3.2 Yetkiyi sına

`SET ROLE`, oturumda geçici olarak başka bir rolün kimliğine bürünmeni sağlar:

```sql
SET ROLE app_readonly;
SELECT current_user;
SELECT count(*) FROM robots;
UPDATE robots SET battery_level = 100 WHERE id = 1;
DELETE FROM missions;
DROP TABLE robots;
INSERT INTO operators (operator_name) VALUES ('X');
RESET ROLE;
```

```
 current_user
--------------
 app_readonly

 count
-------
    10

ERROR:  permission denied for table robots
ERROR:  permission denied for table missions
ERROR:  must be owner of table robots
ERROR:  permission denied for table operators
```

`SELECT` çalışır, diğer dördü reddedilir. Hata mesajını oku: **hangi tabloda hangi yetki eksik**. Gerçek bir bağlantıyla da aynı sonuç:

```bash
psql -U app_readonly -d robot_fleet -c "select current_user, count(*) from robots" -c "update robots set zone='x'"
```

```
 current_user | count
--------------+-------
 app_readonly |    10

ERROR:  permission denied for table robots
```

Yetkileri görmek için `\z robots`:

```
 Schema |  Name  | Type  |     Access privileges      | Column privileges | Policies
--------+--------+-------+----------------------------+-------------------+----------
 public | robots | table | postgres=arwdDxtm/postgres+|                   |
        |        |       | app_readonly=r/postgres    |                   |
```

`app_readonly=r/postgres` = "app_readonly okuma (`r`) yetkisine sahip". Yetkiyi geri almak:

```sql
REVOKE SELECT ON missions FROM app_readonly;
```

```
REVOKE
```

Bir de ilginç bir sonuç: tablodan yetkiyi çekip yalnızca **view**'e yetki bırakırsan:

```sql
REVOKE SELECT ON robots, operators FROM app_readonly;
SET ROLE app_readonly;
SELECT count(*) FROM critical_robots;
SELECT count(*) FROM robots;
RESET ROLE;
```

```
 count
-------
     2

ERROR:  permission denied for table robots
```

View, sahibinin yetkisiyle çalışır: `app_readonly` tabloyu okuyamıyor ama **view'den** okuyabiliyor. Bu, view'i bir **erişim katmanı** olarak kullanmanın yolu: hassas sütunları (ör. telefon) göstermeyen bir view tanımlayıp yalnızca onu açarsın. (Satır sayısı 2: bu denemede `battery_level`'ı 5'e çekmediğin temiz başlangıçtaki iki kritik robot.)

Row-Level Security (satır düzeyinde güvenlik), kullanıcıya hangi **satırları** görebileceğini ayrıca bağlama özelliğidir; şimdilik sadece adını bil.

Temizlik: `DROP OWNED BY app_readonly; DROP ROLE app_readonly;`

### 3.3 SQL injection

Bir uygulama, kullanıcının yazdığı robot adını sorguya **metin olarak ekleyince** girdi komutun parçası olur. Python'da yapılan hata (veritabanına bağlanmadan, sorgunun metnini yazdırıyoruz):

```python
girdi = "x' OR '1'='1"
sorgu = "SELECT name, battery_level FROM robots WHERE name = '" + girdi + "'"
print(sorgu)
```

```
SELECT name, battery_level FROM robots WHERE name = 'x' OR '1'='1'
```

Kullanıcı bir isim yazacakken sorgunun **mantığını** değiştirdi: `OR '1'='1'` her zaman doğru. Bu metin gerçekten çalıştırılırsa:

```sql
SELECT name, battery_level FROM robots WHERE name = 'x' OR '1'='1' ORDER BY name LIMIT 3;
```

```
   name   | battery_level
----------+---------------
 Atlas-01 | 82
 Atlas-02 | 15
 Atlas-03 | 0
```

Tüm robotlar döndü (ilk üçünü gösterdik). Daha kötüsü, girdi `x'; DROP TABLE missions; --` olsaydı sorgu metni şuna dönerdi:

```
SELECT name, battery_level FROM robots WHERE name = 'x'; DROP TABLE missions; --'
```

**Parametreli sorgu**, girdiyi komuttan **ayrı** gönderir; sunucu onu hiçbir zaman SQL olarak okumaz. PostgreSQL'in kendi `PREPARE` ile aynı fikir:

```sql
PREPARE robot_ara (text) AS SELECT name, battery_level FROM robots WHERE name = $1;
EXECUTE robot_ara('Atlas-01');
EXECUTE robot_ara('x'' OR ''1''=''1');
```

```
PREPARE
   name   | battery_level
----------+---------------
 Atlas-01 |            82

 name | battery_level
------+---------------
(0 rows)
```

Aynı kötü niyetli metin burada **robot adı olarak aranan düz bir yazı** oldu, kimse yok. Python'da `psycopg` ile aynı fikir `cursor.execute("... WHERE name = %s", (girdi,))` şeklinde yazılır (ayrı parametre).

**İki önlem neden birlikte?** Parametreli sorgu girdinin komuta karışmasını engeller. En az yetkili rol ise, bir hata yüzünden injection yine de olursa hasarı sınırlar: `DROP TABLE` yetkisi olmayan bir bağlantı, `DROP TABLE missions` komutunu çalıştıramaz. **Biri diğerinin yerine geçmez.**

Bir chatbot veritabanına bağlanacaksa: `app_readonly` benzeri bir rolle, yalnızca gerekli tablo ve view'lere `SELECT` yetkisiyle.

**Senin projende:** (1) `migrations/004_roles.sql`: kendi tabloların için `app_readonly` (tekrar çalıştırılabilir yazım, `current_database()` ile). (2) Projenin kimler tarafından okunacağını ve yazılacağını iki satırla yaz (kullanıcı tipleri).

## 4. Yedekleme: pg_dump ve pg_restore

Yedek alınmamış veritabanı, kayıp riskidir.

```bash
pg_dump -Fc robot_fleet -f yedek.dump          # özel (sıkıştırılmış) biçim
createdb robot_fleet_geri                       # boş bir veritabanı
pg_restore -d robot_fleet_geri yedek.dump       # geri yükle
```

Çıkış kodları: üçü de 0. Doğrulama:

```sql
SELECT (SELECT count(*) FROM robots) r, (SELECT count(*) FROM missions) m, (SELECT count(*) FROM operators) o;
```

```
 r  | m  | o
----+----+----
 10 | 14 | 10
```

Geri yüklenen veritabanında 10, 14 ve 10 satır var: yedek eksiksiz.

Dump dosyasının içini görmek için `pg_restore -l yedek.dump` (bu, listeler):

```
221; 1259 16811 TABLE public missions postgres
219; 1259 16795 TABLE public operators postgres
220; 1259 16803 TABLE public robots postgres
3858; 0 16811 TABLE DATA public missions postgres
3856; 0 16795 TABLE DATA public operators postgres
3857; 0 16803 TABLE DATA public robots postgres
```

Aynı geri yüklemeyi **dolu bir veritabanına** ikinci kez yaparsan hata alırsın:

```
pg_restore: error: could not execute query: ERROR:  relation "missions" already exists
```

Önce silip yüklemek için `--clean --if-exists`:

```bash
pg_restore --clean --if-exists -d robot_fleet_geri yedek.dump   # çıkış kodu 0
```

Düz SQL metni isterse `pg_dump robot_fleet -f yedek.sql` (içinde 3 `COPY` bloğu var). Başka bir bilgisayarda açmak için aynı ya da daha yeni bir PostgreSQL sürümü ve boş bir veritabanı yeter.

**Yedek dosyası (`yedek.dump`, `yedek.sql`) repoya girmez:** hem boyutu büyüktür hem de içinde verin vardır. Kendi reponun `.gitignore` dosyasına `*.dump` ve `yedek*.sql` satırlarını ekle (`*.sql` yazma: migration dosyalarını da gizler). Repoda yalnızca yedeği alma ve geri yükleme **komutları** (ör. `genisletme/k6-yedek.sh`) durur.

**Senin projende:** kendi veritabanını yedekle: `pg_dump -Fc benim_projem -f yedek.dump` ve çıkış kodunu kontrol et.

## 5. Yapay zeka bileşeni: üç seçenek

Projene bu üçünden **birini** ekleyeceksin. Seçimi gerekçeyle yapıyoruz.

| | A: `jsonb` | B: pgvector | C: text-to-SQL |
|---|---|---|---|
| Ne | Yarı yapılandırılmış veri sütunu | Embedding saklama ve anlamsal arama | Soruyu SQL'e çeviren LLM |
| Kurulum | Çekirdek PostgreSQL | Eklenti kurulumu gerekir | Bir LLM'e erişim gerekir |
| Risk | Düşük | Laboratuvar bilgisayarında kurulu olmayabilir | Üretilen SQL yanlış olabilir |

### 5.1 A: jsonb (bu notta çalıştırdığımız)

`llm_calls` tablosuna her çağrının esnek ek bilgisini (sıcaklık, etiketler, istemci) tutacak bir sütun ekleyelim:

```sql
ALTER TABLE llm_calls ADD COLUMN metadata jsonb;

UPDATE llm_calls SET metadata = '{"temperature": 0.2, "tags": ["rapor", "ozet"], "client": {"app": "web", "version": "1.4"}}' WHERE id = 1 RETURNING id;
UPDATE llm_calls SET metadata = '{"temperature": 0.9, "tags": ["kod"], "client": {"app": "cli", "version": "2.0"}}' WHERE id IN (2, 7) RETURNING id;
UPDATE llm_calls SET metadata = jsonb_build_object('temperature', 0.0, 'tags', jsonb_build_array('ceviri')) WHERE id = 4 RETURNING id;
```

```
ALTER TABLE
 id
----
  1
UPDATE 1
 id
----
  2
  7
UPDATE 2
 id
----
  4
UPDATE 1
```

Üç operatör: `->` JSON verir, `->>` **metin** verir, `@>` "içeriyor mu" sorar.

```sql
SELECT id, metadata -> 'client' AS client_json, metadata -> 'client' ->> 'app' AS app_text
FROM llm_calls WHERE metadata IS NOT NULL ORDER BY id;
```

```
 id |           client_json            | app_text
----+----------------------------------+----------
  1 | {"app": "web", "version": "1.4"} | web
  2 | {"app": "cli", "version": "2.0"} | cli
  4 |                                  |
  7 | {"app": "cli", "version": "2.0"} | cli
```

4 numaralı kaydın `client` anahtarı yok: sonuç hata değil, NULL.

```sql
SELECT id, (metadata ->> 'temperature')::numeric AS sicaklik
FROM llm_calls WHERE (metadata ->> 'temperature')::numeric > 0.5 ORDER BY id;

SELECT id FROM llm_calls WHERE metadata @> '{"tags": ["kod"]}' ORDER BY id;
```

```
 id | sicaklik
----+----------
  2 |      0.9
  7 |      0.9

 id
----
  2
  7
```

`->>` metin döndürdüğü için sayısal karşılaştırmadan önce `::numeric` ile çevirmek gerekir.

JSON içinde arama için `gin` indeksi:

```sql
CREATE INDEX idx_llm_calls_metadata ON llm_calls USING gin (metadata);
```

Geçersiz JSON girmek reddedilir (`jsonb` yazım denetimi yapar):

```sql
INSERT INTO llm_calls (id, model_name, task_type, metadata) VALUES (99, 'gpt-4o', 'chat', '{"temperature": ');
```

```
ERROR:  invalid input syntax for type json
DETAIL:  The input string ended unexpectedly.
```

`jsonb` ne zaman? Bir kaydın alanları kayıttan kayda değişiyorsa. Sütunların sabit ve sorgularda sık kullanılıyorsa **normal sütun** daha doğru: kısıtlar ve tipler orada çalışır.

### 5.2 B: pgvector (bu notta çalıştırılmadı)

Vektör araması, metinleri sayı dizilerine (embedding) çevirip **anlamca yakın** olanları bulur. Bunun için `vector` eklentisi gerekir. Önce var mı diye bak:

```sql
SELECT name FROM pg_available_extensions WHERE name = 'vector';
```

Sonuç boşsa kurulu değildir ve B seçeneğini çalıştıramazsın (A ya da C'yi seç). Eklenti kuruluysa `CREATE EXTENSION vector;` ile açılır ve bir sütun `vector(3)` gibi bir tipte tanımlanır. Bu notun hazırlandığı sunucuda eklenti kurulu olmadığı için B örneği çalıştırılmadı. Laboratuvar bilgisayarlarında kurulu olup olmadığını derste söyleyeceğim.

### 5.3 C: text-to-SQL

Şemanı bir LLM'e verirsin, "toplam maliyet nedir?" gibi bir soruyu SQL'e çevirmesini istersin. **Üretilen SQL'e güvenme, test et.** "Çalışan ama yanlış" sorgu, en sinsi hatadır. Örnek: LLM şunu üretti, hata vermeden çalıştı:

```sql
SELECT sum(c.cost_usd) AS toplam_maliyet
FROM llm_calls c JOIN model_catalog mc ON mc.model_name = c.model_name;
```

```
 toplam_maliyet
----------------
         0.0589
```

Doğrusu:

```sql
SELECT sum(cost_usd) AS toplam_maliyet FROM llm_calls;
```

```
 toplam_maliyet
----------------
         0.0631
```

Fark 0.0042: katalogda olmayan `gemini-pro` çağrısı `INNER JOIN` ile düştü (Hafta 6!). (Bu karşılaştırma `gemini-pro`'yu kataloğa **eklemeden** önceki, temiz yüklemeyle yapıldı.)

Bir soru daha: "kaç çağrı yapıldı ve kaçı faturalı?"

```sql
SELECT count(*) AS cagri_sayisi, count(cost_usd) AS faturali FROM llm_calls;
```

```
 cagri_sayisi | faturali
--------------+----------
           12 |       11
```

`count(*)` ve `count(sütun)` farkı: 1 çağrının faturası gelmemiş.

**Test sorgusu kuralı:** bir LLM'in ürettiği SQL, **sen önceden cevabını bildiğin** sorularla denenmeden kullanılmaz. Ve bu SQL'i çalıştıran bağlantı `app_readonly` olmalı (Bölüm 3).

**YZ kullanım beyanı:** Bir LLM aracı kullandıysan, lab föyündeki beyan tablosuna neyi, ne için kullandığını ve çıktısını nasıl doğruladığını yaz.

**Senin projende:** Üç seçenekten hangisi ve neden? Bir gerekçe cümlesi ve bir sınır cümlesi yaz (`odevler/odev-06/` altında bir not dosyasına). A'yı seçtiysen ilk `jsonb` sütununu şimdi ekle.

## 6. Hile kâğıdı

| İş | Komut |
|---|---|
| Adlandırılmış sorgu | `CREATE VIEW ad AS SELECT ...` |
| Plan oku | `EXPLAIN` / `EXPLAIN ANALYZE`, `Seq Scan` mı `Index Scan` mı |
| Salt okunur rol | `CREATE ROLE ... LOGIN`, `GRANT SELECT ...`, `SET ROLE` ile dene |
| Injection önlemi | Parametreli sorgu **ve** en az yetkili rol |
| Yedek | `pg_dump -Fc db -f yedek.dump`, `pg_restore -d yeni_db yedek.dump` |

## Terim sözlüğü

| English | Türkçe | Bu notta |
|---|---|---|
| view | görünüm | Adlandırılmış sorgu |
| index | indeks | Aramayı hızlandıran yapı |
| query plan | sorgu planı | `EXPLAIN` çıktısı |
| role / grant / revoke | rol / yetki ver / yetki al | Bölüm 3 |
| least privilege | en az yetki | Gereken en dar yetki |
| SQL injection | SQL enjeksiyonu | Girdinin komuta karışması |
| parameterized query | parametreli sorgu | Girdi ayrı gider |
| jsonb | ikili JSON | Yarı yapılandırılmış veri |
| embedding | gömme | Metnin sayı vektörü |
| text-to-SQL | metinden SQL üretme | LLM ile SQL |

## Hafta 12'ye geçiş

Bu haftanın sonunda projenin tüm parçaları yerinde olmalı. Final modeli (repo önceden teslim, `RAPOR.md`, final günü repodan bir soru) için [Hafta 12](../week-12/README.md) sayfasına bak.
