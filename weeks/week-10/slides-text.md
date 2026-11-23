# Hafta 10 · Slaytların metin sürümü

BLP 105 / BLP 1005 Veritabanı Yönetim Sistemleri. Hafta 10: DML, transaction ve alt sorgular.

Bu sayfa projeksiyondaki slaytların erişilebilir metin sürümüdür. Ekran okuyucuyla okunabilir, tarayıcıda büyütülebilir (Ctrl ve +) ve dersten önce ya da ders sırasında kendi cihazında takip edilebilir. Kodlar `data/robot_fleet.sql` ve `data/llm_ops.sql` ile denenmiştir; seed verisi kurgusaldır. Ders notu: [ders-notu.md](ders-notu.md)

## İçindekiler

1. Bu haftanın haritası
2. Veriyi içeri al
3. Önce say, sonra değiştir
4. Transaction: ya hep ya hiç
5. Alt sorgu, IN, EXISTS, CTE
6. CTE ile adım adım (llm_ops)

---

### Slayt 1 · Bu haftanın haritası

- Hafta 9'da kurduğun şemanın içini dolduruyorsun: veri yükle, güvenle değiştir, sorgula.
- Sıra: `INSERT` ve `\copy`, güvenli `UPDATE` ve UPSERT, transaction, alt sorgu ve CTE.
- Her blokta aynı soru: bunu kendi projende nasıl yaparsın?

Kontrol: kendi veritabanında `\dt` ve her tablo için `SELECT count(*)`.

### Slayt 2 · Veriyi içeri al

- `INSERT` tek ya da çok satır ekler, `RETURNING` eklenen satırı gösterir.
- `\copy` CSV'yi istemci tarafından yükler, sunucu yetkisi gerekmez.
- Ana tablo önce, bağlı tablo sonra.
- Boş hücre, tarih biçimi ve UTF-8 tipik sorunlardır.

```sql
INSERT INTO operators (operator_name, phone, shift, hired_at)
VALUES ('Deneme', '0000', 'gece', '2026-01-01')
RETURNING *;
```

```
\copy tablo FROM 'dosya.csv' CSV HEADER
```

Derste gösterilen: `RETURNING *` ile yeni operatör (derste geri alınır).

Kontrol: CSV'nin sütun sırası şemanla aynı mı?

### Slayt 3 · Önce say, sonra değiştir

- Aynı `WHERE` ile önce `SELECT count(*)`.
- Sonra `UPDATE` ya da `DELETE`. Etkilenen satır sayısı aynı olmalı.
- `UPSERT`: anahtar varsa güncelle, yoksa ekle.

```sql
SELECT count(*) FROM robots WHERE zone = 'Depo A';
UPDATE robots SET zone = 'Depo C' WHERE zone = 'Depo A';
```

Derste gösterilen: sayım 2, `UPDATE 2`.

```sql
INSERT INTO model_catalog (model_name, provider, price_per_1k_usd, context_window)
VALUES ('demo-model', 'demo', 0.001, 8000)
ON CONFLICT (model_name)
DO UPDATE SET price_per_1k_usd = EXCLUDED.price_per_1k_usd;
```

Fiyatlar kurgusaldır, gerçek fiyat değildir.

Kontrol: `UPDATE`'te `WHERE` unutursan kaç satır değişir? Bunu önceden nasıl görürdün?

### Slayt 4 · Transaction: ya hep ya hiç

- `BEGIN`, `COMMIT`, `ROLLBACK`.
- `SAVEPOINT` ile yalnızca son adımı geri al.
- Atomiklik: yarım iş yok. Kalıcılık: `COMMIT` sonrası kayıp yok.

```sql
BEGIN;
UPDATE robots SET battery_level = 100;
SELECT count(*) FROM robots WHERE battery_level = 100;
ROLLBACK;
```

Derste gösterilen: `WHERE`'siz `UPDATE`, sayım 10, `ROLLBACK`, sayım 0.

Kontrol: `COMMIT`'ten sonra `ROLLBACK` ne yapar?

### Slayt 5 · Alt sorgu, IN, EXISTS, CTE

- Skaler alt sorgu tek değer döndürür.
- `IN` listede mi, `EXISTS` satır var mı sorar.
- `WITH` (CTE) sorguyu adımlara böler.
- `NOT IN` ile NULL tuzağı: sonuç boş döner.

```sql
SELECT name FROM robots
WHERE battery_level < (SELECT avg(battery_level) FROM robots);
```

Derste gösterilen (tuzak): `robots.operator_name` içinde NULL var.

```sql
SELECT operator_name FROM operators o
WHERE NOT EXISTS (
  SELECT 1 FROM robots r WHERE r.operator_name = o.operator_name);
```

`NOT IN` sürümü 0 satır, `NOT EXISTS` sürümü Kerem'i bulur.

Kontrol: `IN` ve `EXISTS` aynı sonucu ne zaman vermez?

### Slayt 6 · CTE ile adım adım (llm_ops)

- Önce model başına toplam maliyet, sonra ortalamanın üstü.
- Her adım adlı ve okunur.

```sql
WITH m AS (
  SELECT model_name, sum(cost_usd) AS toplam
  FROM llm_calls GROUP BY model_name)
SELECT model_name, toplam FROM m
WHERE toplam > (SELECT avg(toplam) FROM m);
```

Derste gösterilen: iki model döner.

Kontrol: kendi projenden bir iş sorusunu önce CTE olarak yaz.
