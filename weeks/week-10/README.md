# Hafta 10: DML, transaction ve alt sorgular

Durum: Yayında

> Şemayı kurdun, şimdi içini dolduruyorsun. Bir de sorguları adım adım yazmayı öğreniyorsun.

## Bu hafta ne işliyoruz

**Veri işleme (DML)**

- `INSERT`: tek satır, çok satır, `INSERT ... SELECT`, `RETURNING`
- `UPDATE` ve `DELETE`
- Güvenli DML alışkanlığı: önce aynı `WHERE` ile `SELECT`, sonra DML
- UPSERT: `INSERT ... ON CONFLICT`
- CSV'den toplu veri yükleme: `\copy`
- Seed verisi ile migration ayrımı

**Transaction**

- `BEGIN`, `COMMIT`, `ROLLBACK`, `SAVEPOINT`
- ACID özellikleri

**Alt sorgular**

- Skaler alt sorgular, `IN` ve `EXISTS` ile alt sorgular
- CTE (`WITH`) ile sorguyu adımlara bölmek

## Hafta sonunda yapabileceklerin

- Veriyi güvenli şekilde ekler, günceller ve silersin
- Yanlış giden bir işlemi `ROLLBACK` ile geri alabilirsin
- Ham CSV'ni kendi şemana taşıyabilirsin
- Çok adımlı bir analizi CTE ile okunur parçalara bölebilirsin

## Anahtar terimler

| English | Türkçe |
|---|---|
| DML (data manipulation language) | veri işleme dili |
| insert / update / delete | ekleme / güncelleme / silme |
| upsert | varsa güncelle yoksa ekle |
| transaction / commit / rollback | işlem / onaylama / geri alma |
| ACID | atomiklik, tutarlılık, yalıtım, kalıcılık |
| subquery | alt sorgu |
| CTE (common table expression) | ortak tablo ifadesi |

Tüm terimler: [GLOSSARY.md](../../GLOSSARY.md)

## Laboratuvar

Bilerek hatalı bir `UPDATE` çalıştırıp `ROLLBACK` ile kurtarma. Kendi projene gerçek veriyi `\copy` ile yükleme.

## Okuma

- PostgreSQL, Data Manipulation: https://www.postgresql.org/docs/current/dml.html
- PostgreSQL Tutorial, Transactions: https://www.postgresql.org/docs/current/tutorial-transactions.html

## Ek kaynaklar

PostgreSQL, WITH Queries (CTE): https://www.postgresql.org/docs/current/queries-with.html

## Kilometre taşı

Veriyi şemaya taşıma

## Ödev

Bu ödev henüz açılmadı, tarihi dersinde duyurulacak. Aktif ödev: [Ödev 1](../week-05/odev.md), son teslim 23 Ekim 2026 Cuma.

**Ödev 5: Veriyi taşıma (DML)** (100 puan). Yönerge: [odev.md](odev.md)

- PR ile teslim: branch `odev-05`, reviewer **gizemturker**
- **Kâğıt rapor Hafta 11 dersinde elden teslim edilir**

Kurallar: [ODEVLER.md](../../ODEVLER.md), rubrik: [RUBRIK.md](../../RUBRIK.md)
