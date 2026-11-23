-- =====================================================================
-- llm_ops_tekrar: Hafta 4-7 tekrar föyü için genişletilmiş LLM veri seti
-- BLP 105 / BLP 1005 Veritabanı Yönetim Sistemleri
--
-- Kurulum:  createdb llm_ops_tekrar
--           psql -d llm_ops_tekrar -f llm_ops_tekrar.sql
--
-- Bu veri seti llm_ops (Hafta 4-6) veritabanına benzer ama ondan AYRIDIR:
-- ayrı bir veritabanına yüklenir, tablo sayısı ve sütunlar farklıdır.
-- Yanlışlıkla llm_ops içine yüklenip oradaki tabloları silmesin diye dosya,
-- bağlı olunan veritabanının adı llm_ops_tekrar değilse hiçbir şey yapmadan durur.
-- Dosya her çalıştırıldığında tabloları sıfırlar ve baştan doldurur.
-- Model adları gerçektir; fiyat, gecikme ve puanlar kurgusaldır:
-- gerçek fiyat listesi olarak kullanmayın.
-- Tüm zamanlar günün ortasındadır, saat dilimi ayarı sonucu değiştirmez.
-- =====================================================================

\set ON_ERROR_STOP on
SET client_encoding = 'UTF8';

BEGIN;

DO $$
BEGIN
  IF current_database() <> 'llm_ops_tekrar' THEN
    RAISE EXCEPTION 'Bu dosya yalnızca llm_ops_tekrar veritabanına yüklenir (şu an: %). Önce: createdb llm_ops_tekrar', current_database();
  END IF;
END $$;

DROP TABLE IF EXISTS llm_evaluations CASCADE;
DROP TABLE IF EXISTS llm_calls CASCADE;
DROP TABLE IF EXISTS model_catalog CASCADE;

-- Model kataloğu. Birincil anahtar model adının kendisi (doğal anahtar).
-- Fiyatlar 1000 token başınadır; girdi ve çıktı fiyatı ayrıdır.
CREATE TABLE model_catalog (
  model_name              text PRIMARY KEY,
  provider                text NOT NULL,
  price_per_1k_input_usd  numeric(8,5) NOT NULL,
  price_per_1k_output_usd numeric(8,5) NOT NULL,
  context_window          integer
);

-- Çağrı kayıtları. model_name için bilerek yabancı anahtar YOK (Hafta 7, D1a).
CREATE TABLE llm_calls (
  id                integer PRIMARY KEY,
  model_name        text,
  user_name         text,
  task_type         text,
  prompt_preview    text,
  prompt_tokens     integer,
  completion_tokens integer,
  latency_ms        integer,
  cost_usd          numeric(10,6),
  status            text CHECK (status IN ('ok', 'error', 'rate_limited')),
  called_at         timestamptz
);

-- Çağrı çıktılarının ölçüt bazında 1-5 arası puanı.
CREATE TABLE llm_evaluations (
  id         integer PRIMARY KEY,
  call_id    integer NOT NULL REFERENCES llm_calls(id),
  criterion  text NOT NULL CHECK (criterion IN ('dogruluk', 'faydalilik', 'guvenlik')),
  score      integer NOT NULL CHECK (score BETWEEN 1 AND 5)
);

-- 7 model. mistral-large ve mistral-small hiç çağrılmadı.
-- gemini-pro katalogda YOK ama 6 numaralı çağrı onu kullanmış.
INSERT INTO model_catalog (model_name, provider, price_per_1k_input_usd, price_per_1k_output_usd, context_window) VALUES
  ('gpt-4o',        'OpenAI',    0.00250, 0.01000, 128000),
  ('gpt-4o-mini',   'OpenAI',    0.00015, 0.00060, 128000),
  ('claude-sonnet', 'Anthropic', 0.00300, 0.01500, 200000),
  ('claude-haiku',  'Anthropic', 0.00080, 0.00400, 200000),
  ('llama-3-70b',   'Meta',      0.00059, 0.00079,   8192),
  ('mistral-large', 'Mistral',   0.00200, 0.00600, 128000),
  ('mistral-small', 'Mistral',   0.00020, 0.00060,  32000);

-- 12 çağrı. Dikkat edilecek kayıtlar:
--  5  : llama-3-70b, çok uzun girdi, en yavaş çağrı
--  6  : gemini-pro, katalogda yok
--  7  : rate_limited, kullanıcısı boş, çıktı yok ama faturalanmış, kayıtlı maliyet hesaptan düşük
--  9  : error, çıktı yok ama girdi için faturalanmış
--  11 : maliyeti boş (fatura gelmedi)
--  12 : kullanıcısı boş (anonim test betiği); 7 ile birlikte 2 anonim çağrı
INSERT INTO llm_calls (id, model_name, user_name, task_type, prompt_preview, prompt_tokens, completion_tokens, latency_ms, cost_usd, status, called_at) VALUES
  (1,  'gpt-4o-mini',   'user_01', 'özetleme',   'Bu haber metnini üç cümlede özetle: Belediye, kentsel dönüşüm kapsamında...',          2400,  800,  950, 0.000840, 'ok',           '2025-02-27 11:20+03'),
  (2,  'gpt-4o',        'user_02', 'soru-cevap', 'Müşteri iade süresini 14 gün sanıyor, kampanyalı ürünlerde süre kaç gündür?',          1600,  800, 2400, 0.012000, 'ok',           '2025-03-03 11:20+03'),
  (3,  'claude-haiku',  'user_05', 'kod',        'Bu Python fonksiyonunun ne yaptığını özetleyen bir docstring yaz.',                    2200,  900,  880, 0.005300, 'ok',           '2025-03-04 14:05+03'),
  (4,  'claude-sonnet', 'user_03', 'kod',        'Python ile CSV dosyasını okuyup günlük toplamları hesaplayan bir betik yaz.',          3000, 1500, 4200, 0.031500, 'ok',           '2025-03-06 10:40+03'),
  (5,  'llama-3-70b',   'user_02', 'özetleme',   'Elli sayfalık tedarik sözleşmesindeki yükümlülükleri madde madde kısalt.',             5200,  800, 9800, 0.003700, 'ok',           '2025-03-08 12:00+03'),
  (6,  'gemini-pro',    'user_04', 'soru-cevap', 'Vektör veritabanı ile ilişkisel veritabanı arasındaki temel fark nedir?',              1100,  450, 4000, 0.008500, 'ok',           '2025-03-10 11:15+03'),
  (7,  'gpt-4o-mini',   NULL,      'kod',        'Bu SQL sorgusundaki hatayı bul ve düzelt.',                                             900,    0,  340, 0.000100, 'rate_limited', '2025-03-12 13:45+03'),
  (8,  'claude-haiku',  'user_02', 'soru-cevap', 'Kargo takip numarası gelmeyen müşteriye hangi adımları önermeliyiz?',                  1000,  300,  700, 0.002000, 'ok',           '2025-03-14 10:30+03'),
  (9,  'gpt-4o',        'user_03', 'özetleme',   'Toplantı notlarını özetle ve görev listesine dönüştür.',                               4000,    0,  800, 0.010000, 'error',        '2025-03-18 12:25+03'),
  (10, 'claude-sonnet', 'user_03', 'çeviri',     'Aşağıdaki hukuki metni resmi bir dille Almancaya aktar.',                              4000, 1700, 5200, 0.037500, 'ok',           '2025-03-20 12:10+03'),
  (11, 'gpt-4o-mini',   'user_05', 'çeviri',     'Şu e-postayı nazik bir üslupla İngilizceye çevir.',                                    1500,  450,  520, NULL,     'ok',           '2025-03-21 11:00+03'),
  (12, 'llama-3-70b',   NULL,      'soru-cevap', 'Test: bu model bağlantısı çalışıyor mu? Kısaca yanıt ver.',                             300,  120,  450, 0.000272, 'ok',           '2025-03-25 13:30+03');

-- 26 değerlendirme: her çağrının en az 1, 6 çağrının (2, 4, 6, 8, 10, 12) güvenlik puanı var.
-- 4 ve 10 numaralı claude-sonnet çağrılarının üçer değerlendirmesi var (fan-out tuzağı).
INSERT INTO llm_evaluations (id, call_id, criterion, score) VALUES
  (1,  1,  'dogruluk',   4), (2,  1,  'faydalilik', 4),
  (3,  2,  'dogruluk',   4), (4,  2,  'faydalilik', 5), (5,  2,  'guvenlik', 5),
  (6,  3,  'dogruluk',   3),
  (7,  4,  'dogruluk',   5), (8,  4,  'faydalilik', 5), (9,  4,  'guvenlik', 4),
  (10, 5,  'dogruluk',   4), (11, 5,  'faydalilik', 4),
  (12, 6,  'dogruluk',   4), (13, 6,  'faydalilik', 4), (14, 6,  'guvenlik', 5),
  (15, 7,  'dogruluk',   1),
  (16, 8,  'dogruluk',   4), (17, 8,  'faydalilik', 3), (18, 8,  'guvenlik', 5),
  (19, 9,  'dogruluk',   1),
  (20, 10, 'dogruluk',   3), (21, 10, 'faydalilik', 4), (22, 10, 'guvenlik', 4),
  (23, 11, 'dogruluk',   5),
  (24, 12, 'dogruluk',   3), (25, 12, 'faydalilik', 3), (26, 12, 'guvenlik', 4);

COMMIT;
\set ON_ERROR_STOP off
