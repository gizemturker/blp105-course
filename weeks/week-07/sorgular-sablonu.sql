-- Ödev 2, Bölüm 1: Filo soruları
-- Ad Soyad:: Çınar Kağan CENGİZ
-- Veritabanı: robot_fleet
-- Her sorgunun altına sonucu açıklayan tek cümlelik yorum yaz.

-- Soru 1: Her robotun adı, operatör adı ve operatör telefonu (INNER JOIN)
SELECT
    r.robot_adi,
    o.operator_adi,
    o.telefon
FROM Robotlar r
INNER JOIN Operatorler o
ON r.operator_id = o.operator_id;
-- Yorum:INNER JOIN iki tabloda eşleşen kayıtları getirir, operatörü olmayan robotlar listede görünmez.


-- Soru 2: Aynı liste, bütün robotlar görünsün (LEFT JOIN). 1. sorguyla karşılaştır, kim kayboldu?
SELECT
    r.robot_adi,
    o.operator_adi,
    o.telefon
FROM Robotlar r
INNER JOIN Operatorler o
ON r.operator_id = o.operator_id;
-- Yorum:İNNER JOİN'de operatörü olmayan robotlar kaybolur,LEFT JOIN'de ise bütün robotlar görünür.


-- Soru 3: Hiç görev almamış robotların adı ve modeli
SELECT
    r.robot_adi,
    r.model
FROM Robotlar r
LEFT JOIN Gorevler g
ON r.robot_id = g.robot_id
WHERE g.robot_id IS NULL;
-- Yorum:Hiç görev almamış robotlar NULL kontrolüyle bulunur.


-- Soru 4a: JOIN ile hesaplanan toplam batarya (görevi olan robotlar)
SELECT SUM(r.batarya) AS toplam_batarya
FROM Robotlar r
INNER JOIN Gorevler g
ON r.robot_id = g.robot_id;
-- Soru 4b: JOIN kullanmadan doğru toplam
SELECT SUM(batarya) AS toplam_batarya
FROM Robotlar
WHERE robot_id IN (
    SELECT robot_id
    FROM Gorevler
);
-- Yorum (iki sonuç ve fark):INNER JOIN bir robotun birden fazla görevi varsa robotun batarya değerini birden fazla kez toplar. JOIN kullanmadan yazılan sorgu ise her robotu yalnızca bir kez hesaba katar. Bu nedenle 4b doğru toplamı verir.


-- Soru 5: Robot başına görev sayısı; count(*) ve count(m.id) yan yana
SELECT
    r.robot_adi,
    COUNT(*) AS toplam_satir,
    COUNT(g.id) AS gorev_sayisi
FROM Robotlar r
LEFT JOIN Gorevler g
ON r.robot_id = g.robot_id
GROUP BY r.robot_id, r.robot_adi;
-- Yorum (hangi robotlarda ikisi farklı?): Hiç görev almamış robotlarda COUNT(*) sonucu 1, COUNT(g.id) sonucu 0 olur.
