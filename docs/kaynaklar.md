# Kaynaklar

Hiçbirini baştan sona okumak zorunda değilsin. Her hafta, o haftanın konusuyla ilgili 1-2 bağlantıyı [haftalık konular](haftalik-konular.md) sayfasında ayrıca bulacaksın — burası tam liste.

## Ana kaynak kitap

- **Silberschatz, Korth, Sudarshan — *Database System Concepts*, 7. baskı** (McGraw-Hill, 2019)
  [db-book.com](https://www.db-book.com/) — yazarların resmi sitesi: içindekiler, örnek veritabanları, tarayıcı içi SQL çalıştırma aracı ve sağlam bir bibliyografya ücretsiz erişilebilir. Ders, bu kitabın bölüm başlıklarını takip ediyor ama sınav/ödev formatı kendi tasarımımız.

## PostgreSQL resmi dokümantasyonu

Dönem boyunca en çok başvuracağın kaynak. [postgresql.org/docs/current](https://www.postgresql.org/docs/current/) üzerinden, konuya göre:

| Konu | Sayfa |
|---|---|
| Querying a Table (SELECT, WHERE) | [tutorial-select.html](https://www.postgresql.org/docs/current/tutorial-select.html) |
| Joins Between Tables | [tutorial-join.html](https://www.postgresql.org/docs/current/tutorial-join.html) |
| Aggregate Functions | [tutorial-agg.html](https://www.postgresql.org/docs/current/tutorial-agg.html) |
| Updates / Deletions | [tutorial-update.html](https://www.postgresql.org/docs/current/tutorial-update.html) · [tutorial-delete.html](https://www.postgresql.org/docs/current/tutorial-delete.html) |
| Views | [tutorial-views.html](https://www.postgresql.org/docs/current/tutorial-views.html) |
| Foreign Keys | [tutorial-fk.html](https://www.postgresql.org/docs/current/tutorial-fk.html) |
| Transactions | [tutorial-transactions.html](https://www.postgresql.org/docs/current/tutorial-transactions.html) |
| Window Functions | [tutorial-window.html](https://www.postgresql.org/docs/current/tutorial-window.html) |
| Data Definition (DDL) | [ddl.html](https://www.postgresql.org/docs/current/ddl.html) |
| Data Manipulation (DML) | [dml.html](https://www.postgresql.org/docs/current/dml.html) |
| Queries (genel) | [queries.html](https://www.postgresql.org/docs/current/queries.html) |
| WITH Queries (CTE) | [queries-with.html](https://www.postgresql.org/docs/current/queries-with.html) |
| Data Types | [datatype.html](https://www.postgresql.org/docs/current/datatype.html) |
| JSON Types (`json`/`jsonb`) | [datatype-json.html](https://www.postgresql.org/docs/current/datatype-json.html) |
| Functions and Operators | [functions.html](https://www.postgresql.org/docs/current/functions.html) |
| Indexes | [indexes.html](https://www.postgresql.org/docs/current/indexes.html) |
| Using EXPLAIN | [using-explain.html](https://www.postgresql.org/docs/current/using-explain.html) |
| Database Roles | [user-manag.html](https://www.postgresql.org/docs/current/user-manag.html) |
| Row Security Policies | [ddl-rowsecurity.html](https://www.postgresql.org/docs/current/ddl-rowsecurity.html) |

## İnteraktif alıştırma siteleri (ücretsiz)

- **[SQLBolt](https://sqlbolt.com/)** — 18 adımlık interaktif SQL dersi, tarayıcıda çalışır. SELECT'ten CREATE/ALTER/DROP TABLE'a kadar.
- **[PGExercises](https://pgexercises.com/)** — tek bir örnek veri seti (spor kulübü) üzerinde Basic, Joins and Subqueries, Modifying data, Aggregates, Date, String, Recursive kategorilerinde sorular.
- **[SQL Murder Mystery](https://mystery.knightlab.com/)** — bir cinayeti SQL sorgularıyla çözüyorsun. JOIN pratiği için eğlenceli bir ısınma.

## İleri okuma

- **[Use The Index, Luke](https://use-the-index-luke.com/)** (Markus Winand) — indeksleme ve sorgu performansı üzerine, PostgreSQL dahil büyük VTYS'leri kapsayan ücretsiz bir site. Hafta 10'dan sonra anlamlı.
- **[CMU 15-445: Intro to Database Systems](https://15445.courses.cs.cmu.edu/)** — Carnegie Mellon'ın veritabanı sistemleri dersi, açık ders materyalleriyle. Motor seviyesinde ("veritabanı içeride nasıl çalışıyor") merak edenler için.

## Araçlar

- **[Mermaid ERD sözdizimi](https://mermaid.js.org/syntax/entityRelationshipDiagram.html)** — ERD'ni markdown içinde metin olarak çizip GitHub'da otomatik render ettirmek için. Hafta 5-6'da kullanacaksın.
- **[pgvector](https://github.com/pgvector/pgvector)** — PostgreSQL için açık kaynak vektör benzerlik araması eklentisi (L2, kosinüs, iç çarpım mesafeleri; HNSW ve IVFFlat indeksleri). Hafta 11'de, YZ bileşeni için.
- **[GitHub Docs](https://docs.github.com/)** — repo, commit, issue, template kullanımı için resmi rehber.

## Not

Bu liste sabit değil. Bir şeyi anlamanı kolaylaştıran başka bir kaynak bulursan (bir video, bir blog yazısı), ders reposuna bir Issue aç — listeye ekleyelim.
