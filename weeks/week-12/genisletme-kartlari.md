# Final genişletme kartları

Projen çalışıyor ama gerçek bir sistem sadece çalışmaz, bozulduğunda kurtarılır, yavaşlayınca hızlandırılır ve yanlış kişiye kapalı tutulur. Aşağıdaki altı karttan **iki tanesini** seç, kendi projene uygula. Her kart bir iş talebidir. Kendi konunun adlarını (tablo, sütun) kullan.

Kartlarını repoda `genisletme/` klasörüne koy: `genisletme/k1-islem.sql` gibi. Bir kartı seçtiysen teslim listesindeki dosyaların hepsi olmalı. Kart seçimini README'ne yaz.

Kartların puanı [RUBRIK.md](../../RUBRIK.md) Ölçüt E'ye göre verilir. Raporunda her kart için ne yaptığını ve hangi dosyanın bunu kanıtladığını yazarsın: [templates/final-rapor-sablonu.md](../../templates/final-rapor-sablonu.md)

---

## K1 Güvenilir işlem

**Talep:** "İki tabloyu birlikte değiştiren bir işlem yarıda kalırsa veri yarım kalmasın."

Yap:
1. Projende iki tabloyu birlikte değiştiren bir iş kuralı seç (ör. bir kaydı kapat ve diğer tabloya iz yaz).
2. İşlemi `BEGIN` ... `COMMIT` ile yaz.
3. İşlemin **ortasında** (ilk komutta değil) bilerek hata verdir, `ROLLBACK` yap, hiçbir şeyin değişmediğini iki `SELECT` ile (önce, sonra) göster.
4. Bir `SAVEPOINT` örneği ekle: hata sonrası yalnızca o kısma geri dön.

Tuzaklar:
- Hatadan sonra yazdığın `COMMIT` sessizce `ROLLBACK` olur. Kaydedildiğini sanma.
- Hata ilk komutta olursa geri alınacak bir şey kalmaz, kanıt boş çıkar.
- `psql` betiğinde `ON_ERROR_STOP` açıksa betik hatada durur, `ROLLBACK` satırına ulaşmaz.

Teslim: `genisletme/k1-islem.sql` + çıktı ekran görüntüsü veya `.out` dosyası. Tahmini süre: 90 dk.

---

## K2 Rapor katmanı

**Talep:** "Yönetim her sabah aynı raporu istiyor, ama sorguyu her seferinde yazmayalım."

Yap:
1. En az **3 view**: biri `JOIN`, biri `GROUP BY` içersin. Her birinin ne işe yaradığını yorum satırı olarak yaz.
2. En az **1 materialized view**.
3. Tabloya bir satır ekle, view'in ve materialized view'in hangisinin hemen, hangisinin `REFRESH` sonrası değiştiğini göster.

Tuzak: Sabit `id` ile yazdığın demo `INSERT`, dosyayı ikinci çalıştırışında "duplicate key" verir. Dosyanın başına önce temizleyen bir `DELETE` koy.

Teslim: `genisletme/k2-raporlar.sql`. Tahmini süre: 90 dk.

---

## K3 Hız kanıtı

**Talep:** "Veri 100 kat büyüyünce bu sorgu yavaşlar mı?"

Yap:
1. `generate_series` ile ana tablonun bir kopyasında **en az 100.000 satır** üret.
2. Projen için seçici bir sorgu yaz (satırların küçük bir kısmını döndüren, `WHERE` ile).
3. `ANALYZE` çalıştır, `EXPLAIN ANALYZE` çıktısını **indeksten önce** kaydet.
4. İndeks oluştur, `ANALYZE` tekrar çalıştır, çıktıyı **sonra** kaydet. Süre farkını ve planın nasıl değiştiğini yaz.

Tuzaklar:
- Plan `Index Scan` veya `Bitmap Index Scan` olabilir; ikisi de doğrudur.
- Sorgun satırların çoğunu döndürüyorsa indeks olsa bile `Seq Scan` kalır. Seçici bir sorgu seç.
- `ANALYZE` yazmazsan tahminler yanlış çıkar.

Teslim: `genisletme/k3-hiz.sql` + iki `EXPLAIN ANALYZE` çıktısı. Tahmini süre: 120 dk.

---

## K4 Rol ve güvenlik

**Talep:** "Analist veriyi okusun ama bozamasın. Uygulama yalnızca gereken yeri yazsın."

Yap:
1. İki rol: `analist` (yalnızca `SELECT`) ve `uygulama` (seçtiğin 1-2 tabloda `INSERT`/`UPDATE`).
2. `analist` olarak `INSERT` dene ve **"permission denied"** hatasını kanıt olarak kaydet.
3. SQL injection örneği: düz birleştirilmiş sorguda kötü girdinin tüm satırları döktüğünü, parametreli sürümün (`psql` değişkeni `:'girdi'` veya `PREPARE`) döndürmediğini göster.
4. **Temizlik dosyası zorunlu:** `k4-temizlik.sql` (`DROP OWNED BY` ve `DROP ROLE`).

Tuzaklar:
- Roller veritabanına değil kümeye aittir. Dosyayı ikinci kez çalıştırırsan "role already exists" alırsın; `IF NOT EXISTS` mantığını düşün veya önce temizle.
- Temizlik yapmadan `DROP ROLE` "objects depend on it" der.

Teslim: `genisletme/k4-roller.sql` ve `k4-temizlik.sql`. Tahmini süre: 150 dk.

---

## K5 Veri kalitesi

**Talep:** "Veri girişinde kimse bozuk kayıt atamasın. Zaten bozuk varsa bulalım."

Yap:
1. Projene en az 2 ek kısıt (`CHECK` veya `UNIQUE`) ekle.
2. Kurallı reddeden 5 bozuk satır dene, hataların kısıt adıyla göründüğünü kaydet.
3. 3 kalite sorgusu: `NULL` kontrolü, yinelenen kayıt, aykırı değer. **Her sorgu en az bir satır döndürmeli.** Verin temizse bilerek bozuk bir satır ekle, sorgunun onu bulduğunu göster, sonra sil.

Tuzaklar:
- Veride zaten kuralı çiğneyen satır varsa kısıt eklenemez. Önce o satırı düzelt (örnek veritabanlarında bu durum var).
- `CHECK` `NULL` değeri geçirir; boş değerleri engellemek için `NOT NULL` gerekir.
- `NOT NULL` hata mesajı kısıt adını göstermeyebilir, bu normal.

Teslim: `genisletme/k5-kalite.sql`. Tahmini süre: 120 dk.

---

## K6 Yedekle ve geri yükle

**Talep:** "Sunucu bozulursa veritabanını geri getirebiliyor muyuz?"

Yap:
1. `pg_dump` ile yedek al.
2. Veritabanını sil, `createdb` ile yeniden oluştur, `pg_restore` ile yükle.
3. Silmeden önce ve sonra her tablonun satır sayısını yan yana göster; view ve indeks sayısı da aynı olmalı.

Tuzaklar:
- Açık oturum varken `dropdb` "being accessed by other users" der. Oturumu kapat veya `--force` kullan.
- Veritabanı yokken `pg_restore` hata verir: önce `createdb` ya da `-C`.
- Düz SQL yedeği `pg_restore` ile açılmaz, `psql` ile açılır.
- Başka bilgisayarda rol yoksa `-x -O` ile geri yükle.
- Yedek dosyasının kendisini (`.dump`) repoya koyma; `.gitignore`'a `*.dump` ekle. Repoda yalnızca komutlar ve satır sayısı karşılaştırması durur.

Teslim: `genisletme/k6-yedek.sh` + satır sayısı karşılaştırması. Tahmini süre: 60 dk.
