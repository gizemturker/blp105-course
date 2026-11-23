# Hafta 9: DDL, tablolar, anahtarlar ve kısıtlar

Durum: Yayında

> Hafta 7'de kâğıt üzerinde tasarladığın şemayı bu hafta gerçekten kuruyorsun.

## Bu hafta ne işliyoruz

- `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE`
- PostgreSQL veri tipleri: `integer` / `bigint`, `numeric` ile `real` farkı, `text` / `varchar`, `boolean`, `date`, `timestamptz`, `uuid`
- Otomatik artan anahtarlar: `GENERATED ALWAYS AS IDENTITY` ve `serial` karşılaştırması
- `PRIMARY KEY`
- `FOREIGN KEY` ve silme davranışları: `CASCADE`, `RESTRICT`, `SET NULL`
- `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`
- Şemayı migration dosyalarıyla yönetmek

## Hafta sonunda yapabileceklerin

- ERD'ni anahtar ve kısıtlarıyla eksiksiz bir PostgreSQL şemasına dönüştürebilirsin
- Bir kısıt ihlalinde PostgreSQL'in verdiği hatayı okuyup ne demek istediğini anlayabilirsin
- Şema değişikliklerini migration dosyalarıyla takip edebilirsin

## Anahtar terimler

| English | Türkçe |
|---|---|
| DDL (data definition language) | veri tanımlama dili |
| primary key / foreign key | birincil anahtar / yabancı anahtar |
| constraint (not null, unique, check, default) | kısıt |
| referential integrity | bütünlük |
| cascade / restrict / set null | silme davranışları |
| migration | göç dosyası |

Tüm terimler: [GLOSSARY.md](../../GLOSSARY.md)

## Laboratuvar

Kısıt ihlali denemeleri: bilerek hatalı veri ekleyip hata mesajlarını okumak. Kendi ERD'nden ilk migration dosyanı yazmak.

## Okuma

- PostgreSQL, Data Definition: https://www.postgresql.org/docs/current/ddl.html
- PostgreSQL Tutorial, Foreign Keys: https://www.postgresql.org/docs/current/tutorial-fk.html

## Ek kaynaklar

SQL Style Guide, "Create syntax" bölümü (adlandırma ve kısıt yazımı): https://www.sqlstyle.guide/

## Kilometre taşı

Şema (`CREATE TABLE`)

## Ödev

Bu haftanın ayrı bir ödevi yok. Yaptıkların final projenin parçasıdır; kendi reponda devam et.

