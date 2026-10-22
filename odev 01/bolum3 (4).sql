-- BLP 105 - Robotik ve Yapay Zeka - Odev 1 - Bolum 3
-- Resmi ders reposundaki ornek seed veriler uzerinden beklenen sonuc sayilari.
-- PostgreSQL icin yazilmistir. Degistirilen veride sayilar da degisir.
-- NOT: PostgreSQL uzerindeki son calistirma teslimden once yapilmalidir.

-- Soru 1: Bütün robotların adı ve modeli
SELECT name, model
FROM robots;
-- 10 satir dondu (ornek veri).
-- Kontrol: Filoda 10 robot var.

-- Soru 2: Robot adı ve eksik şarj miktarı
SELECT name AS robot,
       100 - battery_level AS missing
FROM robots;
-- 10 satir dondu (ornek veri).
-- Kontrol: Kartal-04 için missing NULL kalır; bilinmeyen şarjdan çıkarma yapılamaz.

-- Soru 3: Bataryası 50 üstünde olan robotlar
SELECT name, battery_level
FROM robots
WHERE battery_level > 50;
-- 4 satir dondu (ornek veri).
-- Kontrol: 82, 64, 91 ve 55 seviyelerindeki dört robot seçilir.

-- Soru 4: Bakım durumundaki robotlar
SELECT name, status
FROM robots
WHERE status = 'maintenance';
-- 1 satir dondu (ornek veri).
-- Kontrol: Yalnız Kartal-02 bakımdadır.

-- Soru 5: Görevde olmayan robotlar
SELECT name, status
FROM robots
WHERE status <> 'active';
-- 4 satir dondu (ornek veri).
-- Kontrol: İki charging, bir maintenance, bir offline robot aktif değildir.

-- Soru 6: AMR-300 modeli, bataryası 40 üstü
SELECT name, model, battery_level
FROM robots
WHERE model = 'AMR-300'
  AND battery_level > 40;
-- 2 satir dondu (ornek veri).
-- Kontrol: Mars-01 ve Mars-03 koşulu sağlar.

-- Soru 7: Parantez: şarjda veya bakımda; batarya 50 altında
SELECT name, status, battery_level
FROM robots
WHERE (status = 'charging' OR status = 'maintenance')
  AND battery_level < 50;
-- 1 satir dondu (ornek veri).
-- Kontrol: Doğru: Atlas-02. Parantezsiz 2 kayıt gelir; Kartal-04, NULL bataryasına rağmen charging olduğu için yanlışlıkla eklenir.

-- Soru 7 ek deney: Parantezsiz AND/OR onceligi (YANLIS secim).
SELECT name, status, battery_level
FROM robots
WHERE status = 'charging' OR status = 'maintenance'
  AND battery_level < 50;
-- 2 satir; dogru sorgudan 1 fazla, Kartal-04 hatali sekilde gelir.

-- Soru 8: BETWEEN 15 ve 50, sınırlar dahil
SELECT name, battery_level
FROM robots
WHERE battery_level BETWEEN 15 AND 50;
-- 3 satir dondu (ornek veri).
-- Kontrol: Atlas-02 (15), Kartal-01 (18), Mars-01 (47).

-- Soru 9: Depo A/B dışında kalan robotlar
SELECT name, zone
FROM robots
WHERE zone NOT IN ('Depo A', 'Depo B');
-- 5 satir dondu (ornek veri).
-- Kontrol: NULL bölgeye sahip Mars-03 üç değerli mantık nedeniyle burada görünmez.

-- Soru 10: Adı Kartal ile başlayanlar, harf duyarsız
SELECT name, model
FROM robots
WHERE name ILIKE 'kartal%';
-- 4 satir dondu (ornek veri).
-- Kontrol: Kartal adlı dört robot seçilir; ILIKE harf büyüklüğünden etkilenmez.

-- Soru 11: Modele ve bataryaya göre sıralama
SELECT name, model, battery_level
FROM robots
ORDER BY model ASC, battery_level DESC NULLS LAST;
-- 10 satir dondu (ornek veri).
-- Kontrol: Model önce A-Z, model içinde batarya yüksekten düşüğe sıralanır; NULL en sona gider.

-- Soru 12: Bataryası en yüksek üç robot
SELECT name, battery_level
FROM robots
ORDER BY battery_level DESC NULLS LAST
LIMIT 3;
-- 3 satir dondu (ornek veri).
-- Kontrol: Kartal-03 (91), Atlas-01 (82), Kartal-02 (64).

-- Soru 13: Tekrarsız bölgeler
SELECT DISTINCT zone
FROM robots
ORDER BY zone NULLS LAST;
-- 6 satir dondu (ornek veri).
-- Kontrol: Beş adlandırılmış bölgeye ek olarak bir NULL bölge grubu bulunur.

-- Soru 14: Türkçe alfabeye göre operatör adları
SELECT operator_name
FROM operators
ORDER BY operator_name COLLATE "tr-TR-x-icu";
-- 10 satir dondu (ornek veri).
-- Kontrol: İsmail İ harfine, Şule Ş harfine göre sıralanır; C/Unicode sırası ile Türkçe sıra farklı olabilir.

-- Soru 14 karsilastirma: mevcut/veritabani varsayilan siralama.
SELECT operator_name
FROM operators
ORDER BY operator_name;
-- 10 satir. Siralama farki, veritabani varsayilan collation ayarina baglidir.
-- Varsayilan C/UTF-8 ise, Turkce siralamada Ismail ve Sule gibi adlar yer degistirir.

-- Soru 15: Dış Alan veya Depo B, aktif, düşük bataryadan
SELECT name, zone, battery_level
FROM robots
WHERE zone IN ('Dış Alan', 'Depo B')
  AND status = 'active'
ORDER BY battery_level ASC;
-- 4 satir dondu (ornek veri).
-- Kontrol: Mars-02 (9), Kartal-01 (18), Mars-01 (47), Kartal-03 (91).
