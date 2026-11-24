-- Soru 1: Bütün çağrıların id'sini ve model adını listele.
    SELECT id, model
    FROM llm_calls;
-- 100 satır döndü.

-- Soru 2: Model adını model, toplam token sayısını (prompt + completion) total_tokens başlığıyla göster.
SELECT model, (prompt_tokens + completion_tokens) AS total_tokens
FROM llm_calls;
-- 100 satır döndü.

-- Soru 3: Gecikmesi 2 saniyeyi aşan çağrılar. (Dikkat: sütun milisaniye cinsinden.)
SELECT *
FROM llm_calls
WHERE latency_ms > 2000;
-- 18 satır döndü.

-- Soru 4: Ece'nin yaptığı çağrılar.
SELECT *
FROM llm_calls
WHERE user_name = 'Ece';
-- 12 satır döndü.

-- Soru 5: Sohbet (chat) dışındaki çağrılar.
SELECT *
FROM llm_calls
WHERE call_type != 'chat';
-- 45 satır döndü.

-- Soru 6: Adı claude ile başlayan modellere yapılan, 1 saniyeden yavaş çağrılar.
SELECT *
FROM llm_calls
WHERE model LIKE 'claude%' AND latency_ms > 1000;
-- 14 satır döndü.

-- Soru 7: Kod veya çeviri işi olan, maliyeti 0.01 doları aşan çağrılar.
SELECT *
FROM llm_calls
WHERE (task = 'code' OR task = 'translation') AND cost > 0.01;
-- 22 satır döndü.

-- Soru 8: Gecikmesi 500 ile 1500 ms arasındaki çağrılar.
SELECT *
FROM llm_calls
WHERE latency_ms BETWEEN 500 AND 1500;
-- 35 satır döndü.

-- Soru 9: gpt ailesine (gpt-4o, gpt-4o-mini) yapılan çağrılar.
SELECT *
FROM llm_calls
WHERE model IN ('gpt-4o', 'gpt-4o-mini');
-- 40 satır döndü.

-- Soru 10: Model adında "mini" geçen çağrılar.
SELECT *
FROM llm_calls
WHERE model LIKE '%mini%';
-- 25 satır döndü.

-- Soru 11: Önce kullanıcıya, kullanıcı içinde maliyete (pahalıdan ucuza) göre sırala.
SELECT *
FROM llm_calls
ORDER BY user_name ASC, cost DESC;
-- 100 satır döndü.

-- Soru 12: En pahalı 3 çağrı.
SELECT *
FROM llm_calls
ORDER BY cost DESC
LIMIT 3;
-- 3 satır döndü.

-- Soru 13: Hangi iş türleri (task_type) var?
SELECT DISTINCT task_type
FROM llm_calls;
-- 5 satır döndü.

-- Soru 14: Kullanıcı adlarını doğru Türkçe alfabe sırasıyla, tekrarsız listele.
SELECT DISTINCT user_name
FROM llm_calls
ORDER BY user_name COLLATE "tr-TR-x-icu" ASC;
-- 8 satır döndü.

-- Soru 15: 14 Ekim'den sonra yapılan, 1 saniyeden yavaş çağrıların id'sini, modelini ve gecikmesini, en yavaştan başlayarak listele.
SELECT id, model, latency_ms
FROM llm_calls
WHERE created_at > '2024-10-14' AND latency_ms > 1000
ORDER BY latency_ms DESC;
-- 11 satır döndü.