*SORU1:Tabloyu tanı.
R: Bütün robotların adını ve modelini listele.
Y: Bütün çağrıların id'sini ve model adını listele.
Kaç satır döndü? ______

  **CEVAP= 
SELECT name, model
FROM robots;
-- 10 satır döndü.

SELECT id, model
FROM calls;
-- 15 satır döndü.


 *SORU2:takma ad ve hesaplanmış sütun.
R: Robot adını robot, eksik şarj miktarını (100 eksi batarya) missing başlığıyla göster.
Y: Model adını model, toplam token sayısını (prompt + completion) total_tokens başlığıyla göster.

  **CEVAP=
SELECT name AS robot, (100 - battery_level) AS missing
FROM robots;
-- 10 satır döndü.

SELECT model, (prompt_tokens + completion_tokens) AS total_tokens
FROM calls;
-- 15 satır döndü.


 *SORU3:Sayısal koşul.

R: Bataryası 50'nin üstündeki robotlar.
Y: Gecikmesi 2 saniyeyi aşan çağrılar. (Dikkat: sütun milisaniye cinsinden.)

  **CEVAP=
SELECT *
FROM robots
WHERE battery_level > 50;
-- 7 satır döndü.

SELECT *
FROM calls
WHERE latency > 2000;
-- 5 satır döndü.


 *SORU4:Metin koşulu.

R: Bakımdaki (maintenance) robotlar.
Y: Ece'nin yaptığı çağrılar.

  **CEVAP=
SELECT *
FROM robots
WHERE status = 'maintenance';
-- 2 satır döndü.

SELECT *
FROM calls
WHERE user_name = 'Ece';
-- 3 satır döndü.


 *SORU5:Eşit değil.

R: Görevde olmayan robotlar.
Y: Sohbet (chat) dışındaki çağrılar.

  **CEVAP=
SELECT *
FROM robots
WHERE status <> 'on_mission';
-- 3 satır döndü.

SELECT *
FROM calls
WHERE type <> 'chat';
-- 4 satır döndü.


 *SORU6:İki koşul, AND.

R: AMR-300 modelinde olup bataryası 40'ın üstündeki robotlar.
Y: Adı claude ile başlayan modellere yapılan, 1 saniyeden yavaş çağrılar.

  **CEVAP=
SELECT *
FROM robots
WHERE model = 'AMR-300' AND battery_level > 40;
-- 3 satır döndü.

SELECT *
FROM calls
WHERE model LIKE 'claude%' AND latency > 1000;
-- 4 satır döndü.


 *SORU7:Parantez. Bu soruda bir tuzak var.

R: Şarjda veya bakımda olan, bataryası 50'nin altındaki robotlar.
Y: Kod veya çeviri işi olan, maliyeti 0.01 doları aşan çağrılar.
Parantez koymadan da dene. Kaç satır fark etti? ______ Neden?

  **CEVAP=
SELECT *
FROM robots
WHERE (status = 'charging' OR status = 'maintenance') AND battery_level < 50;
-- 3 satır döndü.

SELECT *
FROM robots
WHERE status = 'charging' OR status = 'maintenance' AND battery_level < 50;
-- 5 satır döndü.

SELECT *
FROM calls
WHERE (type = 'code' OR type = 'translation') AND cost > 0.01;
-- 4 satır döndü.

SELECT *
FROM calls
WHERE type = 'code' OR type = 'translation' AND cost > 0.01;
-- 7 satır döndü.

 *SORU8:BETWEEN.

R: Bataryası 15 ile 50 arasındaki robotlar (uçlar dahil).
Y: Gecikmesi 500 ile 1500 ms arasındaki çağrılar.

  **CEVAP=
SELECT *
FROM robots
WHERE battery_level BETWEEN 15 AND 50;
-- 4 satır döndü.

SELECT *
FROM calls
WHERE latency BETWEEN 500 AND 1500;
-- 6 satır döndü.

 *SORU9:IN / NOT IN.

R: Depo A veya Depo B'de olmayan robotlar.
Y: gpt ailesine (gpt-4o, gpt-4o-mini) yapılan çağrılar.

  **CEVAP=
SELECT *
FROM robots
WHERE location NOT IN ('Warehouse A', 'Warehouse B');
-- 2 satır döndü.

SELECT *
FROM calls
WHERE model IN ('gpt-4o', 'gpt-4o-mini');
-- 6 satır döndü.

 *SORU10:Kalıp arama.

R: Adı "kartal" ile başlayan robotlar, büyük/küçük harf fark etmeksizin.
Y: Model adında "mini" geçen çağrılar.
Kaç satır bekliyordun? ______ Kaç geldi? ______ Fark varsa neden?

  **CEVAP=
SELECT *
FROM robots
WHERE name ILIKE 'kartal%';
-- 2 satır döndü.

SELECT *
FROM calls
WHERE model ILIKE '%mini%';
-- 3 satır döndü.

 *SORU11:Çoklu sıralama.

R: Önce modele (A'dan Z'ye), model içinde bataryaya (yüksekten düşüğe) göre sırala.
Y: Önce kullanıcıya, kullanıcı içinde maliyete (pahalıdan ucuza) göre sırala.

  **CEVAP=
SELECT *
FROM robots
ORDER BY model ASC, battery_level DESC;
-- 10 satır döndü.

SELECT *
FROM calls
ORDER BY user_name ASC, cost DESC;
-- 15 satır döndü.

 *SORU12:Sıralama ve sınırlama.

R: En dolu 3 robot.
Y: En pahalı 3 çağrı.

  **CEVAP=
SELECT *
FROM robots
ORDER BY battery_level DESC
LIMIT 3;
-- 3 satır döndü.

SELECT *
FROM calls
ORDER BY cost DESC
LIMIT 3;
-- 3 satır döndü.

 *SORU13:Tekrarsız liste.

R: Filoda hangi bölgeler var?
Y: Hangi iş türleri (task_type) var?

  **CEVAP=
SELECT DISTINCT location
FROM robots;
-- 3 satır döndü.

SELECT DISTINCT task_type
FROM calls;
-- 4 satır döndü.

 *SORU14:Türkçe sıralama.

R: Operatör adlarını doğru Türkçe alfabe sırasıyla listele.
Y: Kullanıcı adlarını doğru Türkçe alfabe sırasıyla, tekrarsız listele.
Önce COLLATE kullanmadan dene, sonra COLLATE "tr-TR-x-icu" ile. Hangi isimler yer değiştirdi?

  **CEVAP=
SELECT operator_name
FROM robots
ORDER BY operator_name;
-- 10 satır döndü.

SELECT operator_name
FROM robots
ORDER BY operator_name COLLATE "tr-TR-x-icu";
-- 10 satır döndü.

SELECT DISTINCT user_name
FROM calls
ORDER BY user_name;
-- 5 satır döndü.

SELECT DISTINCT user_name
FROM calls
ORDER BY user_name COLLATE "tr-TR-x-icu";
-- 5 satır döndü.

 *SORU15: Soruyu sorguya çevir. Dört adımı uygula: tablo, sütunlar, koşul, sıra.

R: "Dış Alan veya Depo B'deki, görevdeki robotların adını, bölgesini ve bataryasını, en düşük bataryadan başlayarak listele."
Y: "14 Ekim'den sonra yapılan, 1 saniyeden yavaş çağrıların id'sini, modelini ve gecikmesini, en yavaştan başlayarak listele."

  **CEVAP=
SELECT name, location, battery_level
FROM robots
WHERE (location = 'External Area' OR location = 'Warehouse B') AND status = 'on_mission'
ORDER BY battery_level ASC;
-- 3 satır döndü.

SELECT id, model, latency
FROM calls
WHERE timestamp > '2026-10-14' AND latency > 1000
ORDER BY latency DESC;
-- 4 satır döndü.
