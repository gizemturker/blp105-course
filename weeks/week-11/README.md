# Hafta 11: Görünümler, güvenlik ve YZ bileşeni

Durum: Yayında

> Dönemin son teknik haftası. Projeni sunuma hazır hale getiren üç parça.

## Bu hafta ne işliyoruz

**Görünümler ve performans**

- `VIEW` oluşturma ve kullanım amaçları, materialized view'e kısa bakış
- İndeks nedir, ne zaman işe yarar ne zaman yük olur
- `EXPLAIN` ve `EXPLAIN ANALYZE` çıktısını okumak: sequential scan ile index scan

**Güvenlik**

- Kullanıcılar ve roller (`CREATE ROLE`), `GRANT` ve `REVOKE`
- En az yetki ilkesi, LLM ve otomasyon araçları için salt-okunur rol
- Row-Level Security'ye kısa bakış
- SQL injection: nasıl oluşur, parametreli sorgularla nasıl önlenir
- Yedekleme ve geri yükleme: `pg_dump`, `pg_restore`

**Yapay zeka bileşeni** (projene bir tanesini seçeceksin)

- `jsonb` ile yarı yapılandırılmış veri saklama
- pgvector ile embedding saklama ve anlamsal arama
- Text-to-SQL: bir LLM'e şemanı verip ürettiği SQL'i test sorgularıyla doğrulama

## Hafta sonunda yapabileceklerin

- Raporlama görünümleri tanımlayabilirsin
- Yavaş bir sorguyu indeksle hızlandırıp farkı `EXPLAIN ANALYZE` ile gösterebilirsin
- En az yetki ilkesine göre bir salt-okunur rol tasarlayabilirsin
- SQL injection'ın neden tehlikeli olduğunu ve parametreli sorgunun nasıl koruduğunu anlatabilirsin
- Projene bir yapay zeka bileşeni ekleyebilirsin

## Anahtar terimler

| English | Türkçe |
|---|---|
| view / materialized view | görünüm / gerçekleştirilmiş görünüm |
| index / query plan | indeks / sorgu planı |
| role / grant / revoke | rol / yetki verme / yetki alma |
| least privilege principle | en az yetki ilkesi |
| SQL injection | SQL enjeksiyonu |
| parameterized query | parametreli sorgu |
| embedding / vector search | gömme / vektör arama |
| text-to-SQL | metinden SQL üretme |

Tüm terimler: [GLOSSARY.md](../../GLOSSARY.md)

## Laboratuvar

Kendi projene en az iki raporlama görünümü, bir indeks (gerekçesiyle) ve bir `app_readonly` rolü ekleme. Final sunumu provası.

## Okuma

- PostgreSQL Tutorial, Views: https://www.postgresql.org/docs/current/tutorial-views.html
- PostgreSQL, Database Roles: https://www.postgresql.org/docs/current/user-manag.html
- PostgreSQL, Using EXPLAIN: https://www.postgresql.org/docs/current/using-explain.html

## Ek kaynaklar

- pgvector: https://github.com/pgvector/pgvector
- PostgreSQL, JSON Types: https://www.postgresql.org/docs/current/datatype-json.html
- Use The Index, Luke (indeksleme): https://use-the-index-luke.com/

## Kilometre taşı

Görünümler, güvenlik rolleri, YZ bileşeni

## Ödev

Bu haftanın ayrı bir ödevi yok. Yaptıkların final projenin parçasıdır; kendi reponda devam et.

