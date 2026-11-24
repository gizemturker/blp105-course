-- BLP 105 - Robotik ve Yapay Zeka - Odev 1 - Bolum 4
-- Resmi ders reposundaki ornek seed veriler uzerinden beklenen sonuc sayilari.
-- PostgreSQL icin yazilmistir. Degistirilen veride sayilar da degisir.
-- NOT: PostgreSQL uzerindeki son calistirma teslimden once yapilmalidir.

-- Soru 1: Toplam robot sayısı
SELECT COUNT(*) AS robot_count
FROM robots;
-- 1 satir dondu (ornek veri).
-- Yorum: Filoda toplam 10 robot kayıtlı.

-- Soru 2: Aktif robot sayısı
SELECT COUNT(*) AS active_count
FROM robots
WHERE status = 'active';
-- 1 satir dondu (ornek veri).
-- Yorum: 10 robotun 6 tanesi aktif çalışıyor.

-- Soru 3: Batarya seviyeleri toplamı
SELECT SUM(battery_level) AS total_battery
FROM robots;
-- 1 satir dondu (ornek veri).
-- Yorum: Bilinen dokuz batarya değerinin toplamı 381; NULL değer toplama katılmaz.

-- Soru 4: Ortalama batarya seviyesi, 1 ondalık
SELECT ROUND(AVG(battery_level), 1) AS avg_battery
FROM robots;
-- 1 satir dondu (ornek veri).
-- Yorum: Bilinen 9 bataryanın ortalaması %42,3; NULL değer sayılmaz.

-- Soru 5: En düşük ve en yüksek batarya
SELECT MIN(battery_level) AS min_battery,
       MAX(battery_level) AS max_battery
FROM robots;
-- 1 satir dondu (ornek veri).
-- Yorum: Batarya 0 ile 91 arasında; bilinmeyen bir değer bu aralığa katılmıyor.

-- Soru 6: Durum başına robot sayısı
SELECT status, COUNT(*) AS robot_count
FROM robots
GROUP BY status
ORDER BY status;
-- 4 satir dondu (ornek veri).
-- Yorum: Dört durum var: active 6, charging 2, maintenance 1, offline 1.

-- Soru 7: Model başına adet ve ortalama batarya
SELECT model,
       COUNT(*) AS robot_count,
       ROUND(AVG(battery_level), 1) AS avg_battery
FROM robots
GROUP BY model
ORDER BY model;
-- 3 satir dondu (ornek veri).
-- Yorum: AMR-200: 3/%32,3; AMR-300: 3/%37,0; DRN-X1: 4/%57,7. DRN-X1 ortalaması 3 bilinen değere dayanır.

-- Soru 8: Bölge ve durum başına robot sayısı
SELECT zone, status, COUNT(*) AS robot_count
FROM robots
GROUP BY zone, status
ORDER BY zone NULLS LAST, status;
-- 7 satir dondu (ornek veri).
-- Yorum: Yedi (bölge, durum) birleşimi vardır; Mars-03, NULL bölge ve active durumuyla ayrı gruptadır.

-- Soru 9: Birden fazla robotu olan modeller
SELECT model, COUNT(*) AS robot_count
FROM robots
GROUP BY model
HAVING COUNT(*) > 1
ORDER BY model;
-- 3 satir dondu (ornek veri).
-- Yorum: Üç modelin her birinde en az iki robot var.

-- Soru 10: Aktiflerden en az iki robota sahip modeller
SELECT model,
       COUNT(*) AS active_count,
       ROUND(AVG(battery_level), 1) AS avg_battery
FROM robots
WHERE status = 'active'
GROUP BY model
HAVING COUNT(*) >= 2
ORDER BY model;
-- 2 satir dondu (ornek veri).
-- Yorum: WHERE pasifleri çıkarır; HAVING tek aktif AMR-200 grubunu eler; AMR-300 (3/%37) ve DRN-X1 (2/%54,5) kalır.

-- Soru 11: Tüm sütunlarda dolu ve eksik sayıları
SELECT COUNT(*) AS total_rows,
       COUNT(id) AS id_filled,
       COUNT(name) AS name_filled,
       COUNT(model) AS model_filled,
       COUNT(status) AS status_filled,
       COUNT(battery_level) AS battery_filled,
       COUNT(zone) AS zone_filled,
       COUNT(operator_name) AS operator_filled,
       COUNT(*) - COUNT(id) AS id_missing,
       COUNT(*) - COUNT(name) AS name_missing,
       COUNT(*) - COUNT(model) AS model_missing,
       COUNT(*) - COUNT(status) AS status_missing,
       COUNT(*) - COUNT(battery_level) AS battery_missing,
       COUNT(*) - COUNT(zone) AS zone_missing,
       COUNT(*) - COUNT(operator_name) AS operator_missing
FROM robots;
-- 1 satir dondu (ornek veri).
-- Yorum: 10 satırın batarya, bölge ve operatör alanlarının her birinde 1 eksik değer var; diğer sütunlar tam.

-- Soru 12: Bataryası, bölgesi veya operatörü eksik robotlar
SELECT id, name, battery_level, zone, operator_name
FROM robots
WHERE battery_level IS NULL
   OR zone IS NULL
   OR operator_name IS NULL
ORDER BY id;
-- 2 satir dondu (ornek veri).
-- Yorum: Mars-03 (bölge ve operatör) ile Kartal-04 (batarya) eksik bilgi taşır; = NULL kullanılsa 0 satır gelir.

-- Soru 12 ek deney: = NULL hatasi, sorgu calisir ama hicbir satir secilmez.
SELECT id, name
FROM robots
WHERE battery_level = NULL OR zone = NULL OR operator_name = NULL;
-- 0 satir; NULL icin IS NULL kullanilmalidir.

-- Soru 13: NULL hariç ve 0 kabul edilen iki batarya ortalaması
SELECT ROUND(AVG(battery_level), 1) AS ignore_null,
       ROUND(AVG(COALESCE(battery_level, 0)), 1) AS null_as_zero
FROM robots;
-- 1 satir dondu (ornek veri).
-- Yorum: Ortalama %42,3 ve %38,1, fark 4,2 puan. Sensör arızası 0 batarya anlamına gelmediği için NULL hariç ortalama daha dürüsttür.

-- Soru 14: Operatörleri işe giriş yılına göre sayma
SELECT EXTRACT(YEAR FROM hired_at)::integer AS hire_year,
       COUNT(*) AS operator_count
FROM operators
GROUP BY EXTRACT(YEAR FROM hired_at)
ORDER BY hire_year;
-- 4 satir dondu (ornek veri).
-- Yorum: 2023:1, 2024:3, 2025:4, 2026:2; toplam 10 operatör.

-- Soru 15: CASE ile batarya kategorileri
SELECT CASE
         WHEN battery_level IS NULL THEN 'Bilinmiyor'
         WHEN battery_level < 20 THEN 'Kritik'
         WHEN battery_level < 60 THEN 'Düşük'
         ELSE 'Normal'
       END AS battery_category,
       COUNT(*) AS robot_count
FROM robots
GROUP BY 1
ORDER BY battery_category;
-- 4 satir dondu (ornek veri).
-- Yorum: Kritik 4, Düşük 2, Normal 3, Bilinmiyor 1. NULL kontrolü sayısal WHEN ifadelerinden sonra da olsa Kartal-04 yine Bilinmiyor olur.

-- Soru 15 ek deney: NULL kontrolunu EN SONA tasi.
SELECT name,
       CASE
         WHEN battery_level < 20 THEN 'Kritik'
         WHEN battery_level < 60 THEN 'Düşük'
         WHEN battery_level >= 60 THEN 'Normal'
         WHEN battery_level IS NULL THEN 'Bilinmiyor'
       END AS battery_category
FROM robots
WHERE name = 'Kartal-04';
-- 1 satir, kategori yine 'Bilinmiyor'; NULL < 20 / < 60 / >= 60 TRUE olmaz.
