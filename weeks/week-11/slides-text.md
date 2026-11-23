# Hafta 11 · Slaytların metin sürümü

BLP 105 / BLP 1005 Veritabanı Yönetim Sistemleri. Hafta 11: görünümler, indeks, güvenlik, yedek ve YZ bileşeni.

Bu sayfa projeksiyondaki slaytların erişilebilir metin sürümüdür. Ekran okuyucuyla okunabilir, tarayıcıda büyütülebilir (Ctrl ve +) ve dersten önce ya da ders sırasında kendi cihazında takip edilebilir. Kodlar `data/robot_fleet.sql` ve `data/llm_ops.sql` ile denenmiştir; seed verisi kurgusaldır. Ders notu: [ders-notu.md](ders-notu.md)

## İçindekiler

1. Bu haftanın haritası
2. VIEW: adlandırılmış sorgu
3. İndeks ve EXPLAIN
4. Roller ve en az yetki
5. SQL injection: girdi komuta karışmasın
6. Yedek ve YZ bileşeni

---

### Slayt 1 · Bu haftanın haritası

- Projeni teslime hazırlayan parçalar: görünüm, indeks, rol, yedek, yapay zeka bileşeni.
- Sıra: view, indeks ve `EXPLAIN`, roller, SQL injection, yedek, YZ.
- Her blokta aynı soru: bunu kendi projende nasıl yaparsın?

Kontrol: tablolarının kaçında veri var?

### Slayt 2 · VIEW: adlandırılmış sorgu

- Raporu tek isme indirger.
- `LEFT JOIN` ile operatörü olmayan robot satırı kaybolmaz.
- View veri saklamaz, sorguyu saklar.

```sql
CREATE VIEW critical_robots AS
SELECT r.id, r.name, r.battery_level, o.operator_name, o.phone
FROM robots r
LEFT JOIN operators o ON o.operator_name = r.operator_name
WHERE r.status = 'active' AND r.battery_level < 20;
```

Derste gösterilen: `SELECT * FROM critical_robots;` iki satır döner.

Kontrol: view'in hangi iş sorusuna cevap verdiğini yorum satırına yaz.

### Slayt 3 · İndeks ve EXPLAIN

- İndeks okumayı hızlandırabilir, yazmayı yavaşlatır, yer kaplar.
- `EXPLAIN` planı gösterir: `Seq Scan` ya da `Index Scan`.
- Küçük tabloda PostgreSQL indeksi kullanmayabilir. Bu da doğru bulgudur.

```sql
CREATE INDEX idx_robots_zone ON robots(zone);
EXPLAIN SELECT * FROM robots WHERE zone = 'Depo A';
```

Derste gösterilen: 10 satırlık `robots` tablosunda plan `Seq Scan` çıkar. Hızlanma uydurulmaz.

Kontrol: tablon küçükse indeks neden fark yaratmaz? Raporda nasıl yazarsın?

### Slayt 4 · Roller ve en az yetki

- Her bağlantı yalnızca işine yetecek yetkiyi alır.
- Chatbot ve otomasyon araçları için salt-okunur rol.
- `GRANT` verir, `REVOKE` geri alır.

```sql
CREATE ROLE app_readonly LOGIN;
GRANT CONNECT ON DATABASE robot_fleet TO app_readonly;
GRANT USAGE ON SCHEMA public TO app_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_readonly;
```

Derste gösterilen: `app_readonly` ile `SELECT` çalışır, `UPDATE` "permission denied for table robots" verir. Veritabanı adını kendi projenle değiştir.

Kontrol: bir chatbot hangi rolle bağlanır? `DROP TABLE` yetkisi olsaydı ne olurdu?

### Slayt 5 · SQL injection: girdi komuta karışmasın

- Kullanıcı girdisini sorgu metnine eklemek girdiyi komuta çevirir.
- Parametreli sorguda girdi her zaman veridir.
- Parametre ve en az yetki birlikte kullanılır, biri diğerinin yerine geçmez.

```python
girdi = "' OR '1'='1"
kotu = "SELECT * FROM robots WHERE name = '" + girdi + "'"
print(kotu)
```

Derste gösterilen: yazdırılan metinde `WHERE` koşulu her zaman doğru olur. Veritabanı bağlantısı gerekmez.

```python
iyi = "SELECT * FROM robots WHERE name = %s"   # girdi ayrı parametre
```

Kontrol: bu iki önlem neden birlikte gerekir?

### Slayt 6 · Yedek ve YZ bileşeni

- Yedek alınmamış veritabanı kayıp riskidir.
- Üç YZ seçeneği: `jsonb`, pgvector, text-to-SQL.
- pgvector yalnızca kuruluysa canlı gösterilir.
- Text-to-SQL bağlantısı `app_readonly` ile yapılır, üretilen SQL test sorgularıyla doğrulanır.

```
pg_dump -Fc benim_projem -f yedek.dump
```

Derste gösterilen (jsonb, llm_ops):

```sql
ALTER TABLE llm_calls ADD COLUMN metadata jsonb;
UPDATE llm_calls SET metadata = '{"temperature": 0.2, "tags": ["rag"]}' WHERE id = 1;
SELECT id, metadata->>'temperature' AS temp
FROM llm_calls WHERE metadata @> '{"tags": ["rag"]}';
```

Kontrol: projen için hangi bileşen ve neden? Sınırı ne?
