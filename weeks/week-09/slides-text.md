# Hafta 9 · Slaytların metin sürümü

BLP 105 / BLP 1005 Veritabanı Yönetim Sistemleri. Hafta 9: DDL, tablolar, anahtarlar ve kısıtlar.

Bu sayfa projeksiyondaki slaytların erişilebilir metin sürümüdür. Ekran okuyucuyla okunabilir, tarayıcıda büyütülebilir (Ctrl ve +) ve dersten önce ya da ders sırasında kendi cihazında takip edilebilir. Kodlar `data/robot_fleet.sql` ve `data/llm_ops.sql` ile denenmiştir; seed verisi kurgusaldır. Ders notu: [ders-notu.md](ders-notu.md)

## İçindekiler

1. Bu haftanın haritası
2. Tablo, tip, anahtar, kısıt
3. Kısıt hatasını okumak
4. Şemayı dosyayla değiştir

---

### Slayt 1 · Bu haftanın haritası

- Hafta 7'de tasarladığın şemayı bu hafta gerçekten kuruyorsun.
- Sıra: tablo, tip, anahtar, kısıt, hata mesajını okumak, migration.
- Her blokta aynı soru: bunu kendi projende nasıl yaparsın?

Kontrol: `\dt` ne gösterir, `\d robots` ne?

### Slayt 2 · Tablo, tip, anahtar, kısıt

- `PRIMARY KEY` satırı tanır, `FOREIGN KEY` tablolara bağlar.
- `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT` veriyi korur.
- Para için `numeric`, tarih için `timestamptz`.
- `GENERATED ALWAYS AS IDENTITY` otomatik numara verir.

```sql
CREATE TABLE operators_demo (
  id    integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name  text NOT NULL UNIQUE,
  shift text DEFAULT 'gündüz' CHECK (shift IN ('gündüz', 'gece'))
);
```

Kontrol: `CASCADE` seçersen operatör silinince robotlara ne olur?

### Slayt 3 · Kısıt hatasını okumak

Derste gösterilen (robot_fleet): görevi olan robotu silmeyi dene.

```sql
DELETE FROM robots WHERE id = 1;
```

- Sonuç: hata, `violates foreign key constraint "missions_robot_id_fkey"`.
- `DETAIL` satırı hangi anahtarın nerede kullanıldığını söyler.
- Hata engel değil, korumadır.

Derste gösterilen (llm_ops): `llm_calls.model_name` için yabancı anahtar eklemek, katalogda olmayan `gemini-pro` yüzünden hata verir. İki çözüm: kataloğa ekle ya da çağrıyı düzelt.

```sql
ALTER TABLE llm_calls
  ADD FOREIGN KEY (model_name) REFERENCES model_catalog(model_name);
```

Kontrol: dört kısıt hatasından hangisi veriyi korudu?

### Slayt 4 · Şemayı dosyayla değiştir

- Şema elle değil `migrations/001_create_tables.sql` dosyasıyla kurulur.
- Dosya iki kez çalışınca aynı sonucu vermeli.
- Önce bağlı tabloyu sil, sonra ana tabloyu.
- Şema bir dosyada, seed veri başka dosyada.

```sql
DROP TABLE IF EXISTS missions;
DROP TABLE IF EXISTS robots;
```

Kontrol: `DROP TABLE robots` neden `missions`'tan sonra yazılmalı?
