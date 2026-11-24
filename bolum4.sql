-- Soru 1: Toplam çağrı sayısı ve kullanıcı sayısı
SELECT count(*) AS toplam_cagri, count(DISTINCT user_name) AS farkli_kullanici FROM llm_calls;
-- Veritabanımızda toplam 10 adet LLM çağrısı yapılmıştır.
-- Bu çağrıları gerçekleştiren toplam 5 farklı benzersiz kullanıcı bulunmaktadır.


-- Soru 2: Toplam harcanan maliyet ve ortalama gecikme
SELECT sum(cost) AS toplam_maliyet, avg(latency_ms) AS ortalama_gecikme FROM llm_calls;
-- Yapılan tüm çağrılar sonucunda toplam 0.1281 dolar harcama gerçekleşmiştir.
-- Çağrıların ortalama yanıt süresi ise yaklaşık 1805 milisaniyedir (1.8 saniye).


-- Soru 3: En yüksek ve en düşük token kullanımı
SELECT max(prompt_tokens + completion_tokens) AS en_yuksek_token, min(prompt_tokens + completion_tokens) AS en_dusuk_token FROM llm_calls;
-- Tek bir çağrıda harcanan en fazla toplam token miktarı 2500'dür.
-- En az token kullanılan çağrıda ise toplam 100 token harcanmıştır.


-- Soru 4: Kullanıcı bazında çağrı sayıları
SELECT user_name, count(*) AS cagri_sayisi FROM llm_calls GROUP BY user_name;
-- Kullanıcıların sisteme yaptığı çağrı dağılımları listelenmiştir.
-- Ece 6 çağrı ile sistemi en çok kullanan kişidir; Can, Ahmet, Mehmet ve Alper ise 1'er çağrı yapmıştır.


-- Soru 5: Modele göre harcanan toplam maliyet
SELECT model, sum(cost) AS toplam_maliyet FROM llm_calls GROUP BY model;
-- Veritabanındaki her bir yapay zeka modelinin ürettiği toplam maliyet yükü gösterilmiştir.
-- En çok maliyet oluşturan model claude-3-opus (0.0450$), en az maliyet çıkaran ise gpt-4o-mini (0.0016$) olmuştur.


-- Soru 6: Görev türüne (task) göre ortalama gecikme süresi
SELECT task, avg(latency_ms) AS ortalama_gecikme FROM llm_calls GROUP BY task;
-- Yapılan iş türlerine göre sistemin yanıt verme hızları analiz edilmiştir.
-- En uzun ortalama süren görev 'code' (3266 ms) iken, en hızlı yanıt alınan görev 'search' (300 ms) olmuştur.


-- Soru 7: 2'den fazla çağrı yapan kullanıcılar
SELECT user_name, count(*) AS cagri_sayisi FROM llm_calls GROUP BY user_name HAVING count(*) > 2;
-- Sistemde yoğun kullanım yapan kullanıcıları filtrelemek için HAVING kullanılmıştır.
-- Sadece Ece 6 adet çağrı yaptığı için şartı sağlamış ve listede yer almıştır.


-- Soru 8: Toplam maliyeti 0.01 doları geçen modeller
SELECT model, sum(cost) AS toplam_maliyet FROM llm_calls GROUP BY model HAVING sum(cost) > 0.01;
-- Harcama limiti belirlenen eşiği aşan bütçe odaklı modeller filtrelenmiştir.
-- claude-3-opus, claude-3-5-sonnet ve gpt-4o modelleri 0.01 doların üzerinde maliyet oluşturmuştur.


-- Soru 9: Sohbet (chat) türündeki çağrıların kullanıcılara göre dağılımı
SELECT user_name, count(*) AS sohbet_sayisi FROM llm_calls WHERE call_type = 'chat' GROUP BY user_name;
-- Sadece 'chat' tipinde yapılan isteklerin kullanıcı bazlı sayıları dökülmüştür.
-- Ece 5 kez sohbet çağrısı yaparken, Ahmet ve Can 1'er kez sohbet çağrısında bulunmuştur.


-- Soru 10: En az 2 sohbet çağrısı yapan kullanıcılar
SELECT user_name, count(*) AS sohbet_sayisi FROM llm_calls WHERE call_type = 'chat' GROUP BY user_name HAVING count(*) >= 2;
-- Sohbet özelliğini aktif olarak en az 2 kere kullanan kişileri filtrelemektedir.
-- Bu kriteri sağlayan tek kullanıcı 5 sohbet çağrısı ile Ece'dir.


-- Soru 11: NULL değer tespiti ve toplam veri kontrolü
SELECT count(*) AS toplam_satir, count(user_name) AS dolu_kullanici FROM llm_calls;
-- Tablodaki genel kayıt sayısı ile kullanıcı adı sütununun doluluk oranı karşılaştırılmıştır.
-- Her iki değer de 10 çıktığı için veri tabanındaki tüm çağrıların kullanıcı bilgisi eksiksiz mevcuttur.


-- Soru 12: Görev bazında ortalama token kullanımı
SELECT task, avg(prompt_tokens + completion_tokens) AS ortalama_token FROM llm_calls GROUP BY task;
-- İş türlerinin modele ne kadar yük getirdiği ortalama token miktarı ile ölçülmüştür.
-- En çok girdi/çıktı token'ı harcayan görev 'code' (1933 token), en az harcayan ise 'search' (100 token) olmuştur.


-- Soru 13: 1000 ms üstü gecikmeye sahip modellerin çağrı sayıları
SELECT model, count(*) AS yavas_cagri_sayisi FROM llm_calls WHERE latency_ms > 1000 GROUP BY model;
-- Yanıt süresi 1 saniyenin üzerinde kalan yavaş çağrıların modellere göre dağılımıdır.
-- claude-3-5-sonnet 3 defa, gpt-4o 2 defa, claude-3-haiku ve claude-3-opus ise 1'er defa yavaş yanıt vermiştir.


-- Soru 14: Birden fazla yavaş çağrısı olan modeller
SELECT model, count(*) AS yavas_cagri_sayisi FROM llm_calls WHERE latency_ms > 1000 GROUP BY model HAVING count(*) > 1;
-- Performans sıkıntısı kronikleşen (1 saniyeden uzun süren çağrı sayısı 1'den fazla olan) modeller filtrelenmiştir.
-- Bu şartı sağlayan modeller 3 yavaş çağrı ile claude-3-5-sonnet ve 2 yavaş çağrı ile gpt-4o'dur.


-- Soru 15: Kullanıcı ve çağrı tipine göre ikili gruplama
SELECT user_name, call_type,