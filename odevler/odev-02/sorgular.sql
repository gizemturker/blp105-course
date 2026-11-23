SQL
-- Ödev 2, Bölüm 1: Filo soruları
-- Ad Soyad: Kutay Berat YAKIŞIK
-- Veritabanı: robot_fleet
-- Her sorgunun altına sonucu açıklayan tek cümlelik yorum yaz.

-- Soru 1: Her robotun adı, operatör adı ve operatör telefonu (INNER JOIN)
SELECT r.name AS robot_adi, o.operator_name AS operator_adi, o.phone AS telefon
FROM robots r
INNER JOIN operators o ON r.operator_name = o.operator_name
ORDER BY r.id;

-- Yorum: Sadece bir operatöre bağlı olan 9 robot listelendi çünkü INNER JOIN, operatör alanı NULL olan Mars-03 kaydını eşleşmediği için dışarıda bıraktı.


-- Soru 2: Aynı liste, bütün robotlar görünsün (LEFT JOIN). 1. sorguyla karşılaştır, kim kayboldu?
SELECT r.name AS robot_adi, o.operator_name AS operator_adi, o.phone AS telefon
FROM robots r
LEFT JOIN operators o ON r.operator_name = o.operator_name
ORDER BY r.id;

-- Yorum: LEFT JOIN sol tablodaki tüm robotları koruduğu için 10 satır döndü ve 1. sorguda operatörü NULL olduğu için kaybolan Mars-03 bu kez operatör bilgileri boş olarak göründü.


-- Soru 3: Hiç görev almamış robotların adı ve modeli
SELECT r.name AS robot_adi, r.model
FROM robots r
LEFT JOIN missions m ON r.id = m.robot_id
WHERE m.id IS NULL
ORDER BY r.id;

-- Yorum: missions tablosunda hiç eşleşen görev kaydı bulunmayan Kartal-02, Atlas-03, Mars-03 ve Kartal-04 olmak üzere toplam 4 robot döndü.


-- Soru 4a: JOIN ile hesaplanan toplam batarya (görevi olan robotlar)
SELECT SUM(r.battery_level) AS yanlis_toplam_batarya
FROM robots r
INNER JOIN missions m ON r.id = m.robot_id;

-- Soru 4b: JOIN kullanmadan doğru toplam
SELECT SUM(r.battery_level) AS dogru_toplam_batarya
FROM robots r
WHERE r.id IN (SELECT DISTINCT robot_id FROM missions);

-- Yorum (iki sonuç ve fark): JOIN işleminde çok görevli robotların satırları görev sayısı kadar çoğaldığı için toplam batarya 700 çıkarken, JOIN kullanmadan her robotun bataryası yalnızca bir kez toplandığında doğru sonuç 262 olarak hesaplandı.


-- Soru 5: Robot başına görev sayısı; count(*) ve count(m.id) yan yana
SELECT r.name AS robot_adi,
       COUNT(*) AS tum_satir_sayisi,
       COUNT(m.id) AS gercek_gorev_sayisi
FROM robots r
LEFT JOIN missions m ON r.id = m.robot_id
GROUP BY r.id, r.name
ORDER BY r.id;

-- Yorum (hangi robotlarda ikisi farklı?): Toplam 10 robotun listelendiği bu sorguda,hiç görevi olmayan Kartal-02, Atlas-03, Mars-03 ve Kartal-04 robotlarında COUNT(*) boş eşleşme satırını sayıp 1 döndürürken COUNT(m.id) NULL değerleri saymadığı için 0 döndürdü.
