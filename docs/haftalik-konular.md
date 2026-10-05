# Haftalık konular

Bu sayfa her haftanın teorik içeriğine genel bir bakış. Ödev ve lab föyü ayrı ayrı, o haftası geldiğinde paylaşılacak — burada sadece "bu hafta ne öğreniyoruz, nereden okuyabilirim" var.

---

## Hafta 3 · Veritabanı temel kavramları ve mimari

**Hedef:** Bir VTYS'nin hangi problemleri çözdüğünü açıklamak, PostgreSQL'in istemci-sunucu mimarisini ve küme → veritabanı → şema → tablo hiyerarşisini tanımak.

- Dosya tabanlı sistemlerin sorunları: veri tekrarı, tutarsızlık, eşzamanlı erişim, güvenlik
- İlişkisel model: tablo, satır, sütun, şema
- SQL'in alt dilleri: DQL, DDL, DML, DCL, TCL
- Yapay zeka sistemlerinde veritabanının yeri (LLM log'ları, robotik telemetri)

📖 [PostgreSQL Tutorial — Giriş](https://www.postgresql.org/docs/current/tutorial-sql-intro.html) · [Haftanın slaytları](../weeks/week-03/slides-text.md)

---

## Hafta 4 · Ortam kurulumu · SELECT, WHERE

**Hedef:** Türkçe sorulmuş bir soruyu tek tablolu bir SQL sorgusuna çevirmek.

- `SELECT`, `FROM`, sütun seçimi, takma adlar (`AS`)
- `WHERE`: karşılaştırma operatörleri, `AND`/`OR`/`NOT`
- `BETWEEN`, `IN`, `LIKE`, `ILIKE`
- `ORDER BY`, `LIMIT`, `OFFSET`, `DISTINCT`
- Sorgunun mantıksal işlenme sırası: FROM → WHERE → SELECT → ORDER BY → LIMIT

📖 [PostgreSQL Tutorial — Querying a Table](https://www.postgresql.org/docs/current/tutorial-select.html) · [SQLBolt Lesson 1-5](https://sqlbolt.com/)

---

## Hafta 5 · SQL fonksiyonları ve gruplama (GROUP BY)

**Hedef:** Veriyi gruplayarak özet istatistik üretmek, NULL değerlerin sonuçları nasıl etkilediğini açıklamak.

- Toplama fonksiyonları: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- `GROUP BY` mantığı ve kuralı, `HAVING` ile `WHERE` farkı
- NULL ve üç değerli mantık (TRUE/FALSE/UNKNOWN); `COALESCE`, `NULLIF`
- Tarih/zaman fonksiyonları: `date_trunc`, `EXTRACT`, `now()`, `interval`
- `CASE WHEN` ile koşullu sınıflandırma

📖 [PostgreSQL Tutorial — Aggregate Functions](https://www.postgresql.org/docs/current/tutorial-agg.html) · [SQLBolt Lesson 10-11](https://sqlbolt.com/)

---

## Hafta 6 · Varlık-İlişki (E-R) modeli

**Hedef:** Bir problem senaryosundan E-R modeli çıkarmak ve ilişkisel şemaya dönüştürmek.

- Varlık, varlık kümesi, nitelik (basit, bileşik, çok değerli, türetilmiş)
- İlişki, ilişki kümesi, kardinalite (1-1, 1-N, M-N), zorunlu/isteğe bağlı katılım
- Chen ve crow's foot notasyon karşılaştırması
- E-R modelinden ilişkisel şemaya dönüşüm kuralları
- Mermaid `erDiagram` ile ERD'yi markdown içinde çizmek

📖 [Mermaid ERD sözdizimi](https://mermaid.js.org/syntax/entityRelationshipDiagram.html)

---

## Hafta 7 · Normalizasyon

**Hedef:** Fonksiyonel bağımlılıkları belirleyip şemayı 3NF'ye taşımak, bilinçli denormalizasyon kararını gerekçelendirmek.

- Veri anomalileri: ekleme, silme, güncelleme
- Fonksiyonel bağımlılık, süper/aday/birincil anahtar
- 1NF (atomik değerler), 2NF (kısmi bağımlılık), 3NF (geçişli bağımlılık)
- BCNF'ye kısa bakış
- Denormalizasyon: ne zaman ve neden

📖 *Database System Concepts*, 7. baskı — Normalizasyon bölümleri ([db-book.com](https://www.db-book.com/))

---

## Hafta 8 · Ara sınav / mini proje değerlendirmesi

O ana kadar işlenen sorgu ve modelleme konuları üzerinden, kendi proje senaryon temel alınarak yapılır. Format dersin başında ayrıca duyurulur.

---

## Hafta 9 · DDL · anahtarlar ve ilişkiler

**Hedef:** Bir E-R modelini anahtar ve kısıtlarıyla eksiksiz bir PostgreSQL şemasına dönüştürmek.

- `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE`
- PostgreSQL veri tipleri: `integer`/`bigint`, `numeric` ile `real` farkı, `text`, `boolean`, `date`, `timestamptz`, `uuid`, `jsonb` (ön bakış)
- `GENERATED ALWAYS AS IDENTITY` ile otomatik artan anahtarlar
- `PRIMARY KEY`, `FOREIGN KEY` ve silme davranışları (`CASCADE`, `RESTRICT`, `SET NULL`)
- `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`

📖 [PostgreSQL — Data Definition (DDL)](https://www.postgresql.org/docs/current/ddl.html)

---

## Hafta 10 · DML · INSERT, UPDATE, DELETE, transaction

**Hedef:** Veriyi güvenli şekilde eklemek, güncellemek, silmek; transaction ile tutarlılığı korumak.

- `INSERT` (tek satır, çok satır, `INSERT ... SELECT`, `RETURNING`)
- `UPDATE`, `DELETE` — güvenli alışkanlık: önce aynı WHERE ile SELECT, sonra DML
- UPSERT: `INSERT ... ON CONFLICT`
- Transaction: `BEGIN`, `COMMIT`, `ROLLBACK`, `SAVEPOINT`
- ACID özellikleri

📖 [PostgreSQL — Data Manipulation (DML)](https://www.postgresql.org/docs/current/dml.html) · [Transactions](https://www.postgresql.org/docs/current/tutorial-transactions.html)

---

## Hafta 11 · Çoklu tablo sorguları (JOIN)

**Hedef:** İlişkili tabloları doğru JOIN türüyle birleştirmek, satır çoğalması (fan-out) hatasını fark etmek.

- Veri neden birden fazla tabloya bölünür — sezgisel giriş
- `INNER JOIN`, `LEFT JOIN` (eşleşmeyenleri bulma: `WHERE ... IS NULL`)
- `RIGHT JOIN`, `FULL OUTER JOIN`, `CROSS JOIN` (kısaca)
- Self join, çoka-çok ilişkiler ve ara tablolar
- Yaygın hata: JOIN sonrası satır çoğalması ve yanlış toplamlar

📖 [PostgreSQL Tutorial — Joins Between Tables](https://www.postgresql.org/docs/current/tutorial-join.html) · [SQLBolt Lesson 6-7](https://sqlbolt.com/) · [PGExercises — Joins and Subqueries](https://pgexercises.com/)

---

## Hafta 12 · Alt sorgular ve görünümler · text-to-SQL

**Hedef:** Çok adımlı analizleri okunabilir sorgulara bölmek; bir LLM'in ürettiği SQL'i değerlendirmek.

- Skaler alt sorgular, `IN`/`EXISTS`, korelasyonlu alt sorgular
- CTE (`WITH`) ile sorguyu adımlara bölmek; özyinelemeli CTE'ye kısa bakış
- `VIEW` ve materialized view
- Text-to-SQL: LLM'e şema vermek, tipik hata türleri, üretilen SQL'i test sorgularıyla doğrulamak

📖 [PostgreSQL — WITH Queries (CTE)](https://www.postgresql.org/docs/current/queries-with.html) · [Views](https://www.postgresql.org/docs/current/tutorial-views.html)

---

## Hafta 13 · Veritabanı güvenliği

**Hedef:** En az yetki ilkesine göre rol tanımlamak, SQL injection riskini açıklamak.

- Kullanıcılar ve roller (`CREATE ROLE`), `GRANT`/`REVOKE`
- En az yetki ilkesi; LLM ve otomasyon araçları için salt-okunur rol tasarımı
- Row-Level Security (`ENABLE ROW LEVEL SECURITY`, `CREATE POLICY`)
- SQL injection: nasıl oluşur, gerçek hayattaki sonuçları; parametreli sorgular
- Yedekleme/geri yükleme: `pg_dump`, `pg_restore` (kısaca)

📖 [PostgreSQL — Database Roles](https://www.postgresql.org/docs/current/user-manag.html) · [Row Security Policies](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)

---

## Hafta 14 · Final — jüri önünde sunumlar

Ana projenin teslimi ve sektörden bir jüri önünde bireysel sunum. Detaylar dönem içinde ayrıca paylaşılacak.
