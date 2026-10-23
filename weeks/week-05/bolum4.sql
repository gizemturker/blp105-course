**SORU1:Toplam kaç kayıt var?

R: Filoda kaç robot var?
Y: Kaç çağrı kaydedilmiş?

  **CEVAP=
-- R: Filoda kaç robot var?
SELECT COUNT(*) FROM robots;
-- Yorum: Filomuzda toplam 10 adet robot bulunduğunu gösterir.

SELECT COUNT(*) FROM calls;
-- Yorum: Sistemde toplam 15 adet çağrı kaydı yapıldığını gösterir.

 **SORU2:Koşullu sayma.

R: Kaç robot görevde (active)?
Y: Kaç çağrı 2 saniyeden yavaş?

  **CEVAP=
SELECT COUNT(*) 
FROM robots 
WHERE status = 'active';
-- Yorum: Şu anda aktif durumda olan robot sayısını gösterir.

SELECT COUNT(*) 
FROM calls 
WHERE latency > 2000;
-- Yorum: Gecikmesi 2000 milisaniyeyi (2 saniyeyi) aşan toplam çağrı sayısını gösterir.

 **SORU3:Toplama.

R: Bütün bataryaların toplamı.
Y: Toplam maliyet ve toplam token sayısı.

  **CEVAP=
SELECT SUM(battery_level) 
FROM robots;
-- Yorum: Tüm robotların batarya seviyelerinin toplamını gösterir.

SELECT SUM(cost) AS total_cost, SUM(prompt_tokens + completion_tokens) AS total_tokens 
FROM calls;
-- Yorum: Gerçekleştirilen tüm çağrılar için toplam maliyeti ve harcanan toplam token miktarını gösterir.

 **SORU4:Ortalama, bir ondalık basamağa yuvarlanmış.

R: Ortalama batarya seviyesi.
Y: Ortalama gecikme.

  **CEVAP=
SELECT ROUND(AVG(battery_level), 1) 
FROM robots;
-- Yorum: Filodaki robotların ortalama şarj seviyesini bir ondalık basamağa yuvarlayarak gösterir.

SELECT ROUND(AVG(latency), 1) 
FROM calls;
-- Yorum: Yapılan tüm çağrıların ortalama gecikme süresini (milisaniye cinsinden) bir ondalık basamağa yuvarlayarak gösterir.

 **SORU5: En küçük ve en büyük.

R: En düşük ve en yüksek batarya.
Y: En hızlı ve en yavaş çağrı.

  **CEVAP=
SELECT MIN(battery_level) AS min_battery, MAX(battery_level) AS max_battery 
FROM robots;
-- Yorum: Filodaki robotların sahip olduğu en düşük ve en yüksek şarj seviyelerini gösterir.

SELECT MIN(latency) AS min_latency, MAX(latency) AS max_latency 
FROM calls;
-- Yorum: Gerçekleştirilen çağrılar arasındaki en kısa (en hızlı) ve en uzun (en yavaş) gecikme süresini gösterir.

 **SORU6: İlk gruplaman.

R: Her durumda (status) kaç robot var?
Y: Her iş türünde (task_type) kaç çağrı var?
Kaç satır döndü? ______ Neden o kadar?

  **CEVAP=
SELECT status, COUNT(*) AS robot_count
FROM robots
GROUP BY status;
-- Yorum: Robotların hangi durumlarda (örneğin bakım, şarj, görevde) kaçar adet bulunduğunu gösterir.

SELECT task_type, COUNT(*) AS call_count
FROM calls
GROUP BY task_type;
-- Yorum: Hangi iş türüne (task_type) ait kaç adet çağrı yapıldığını gösterir.
Robotlar için 3, çağrılar için 4 satır döndü.
Çünkü GROUP BY ifadesi, tablodaki benzersiz durum/iş türü (status veya task_type) kategorilerinin her biri için tek bir satır oluşturur; filoda 3 farklı durum ve 4 farklı iş türü bulunduğu için sonuçlar o kadar satır döndürmüştür.

 **SORU7:Grup başına iki özet.

R: Her model için robot sayısı ve ortalama batarya.
Y: Her model için çağrı sayısı ve toplam maliyet, pahalıdan ucuza.

  **CEVAP=
SELECT model, COUNT(*) AS robot_count, ROUND(AVG(battery_level), 1) AS avg_battery
FROM robots
GROUP BY model;
-- Yorum: Her bir robot modelinden kaçar adet olduğunu ve bu modellerin ortalama şarj seviyelerini gösterir.

SELECT model, COUNT(*) AS call_count, SUM(cost) AS total_cost
FROM calls
GROUP BY model
ORDER BY total_cost DESC;
-- Yorum: Her bir yapay zeka modelinin kaç kez çağrıldığını ve toplamda ne kadar maliyet oluşturduğunu en pahalıdan en ucuza doğru sıralayarak gösterir.

 **SORU8:İki sütuna göre gruplama.

R: Her bölgede, her durumdan kaç robot var?
Y: Her kullanıcının her iş türünden kaç çağrısı var?

  **CEVAP=
SELECT location, status, COUNT(*) AS robot_count
FROM robots
GROUP BY location, status;
-- Yorum: Hangi bölgede hangi robot durumundan (örneğin bakım, şarj vb.) kaçar adet robot bulunduğunu gösterir.

SELECT user_name, task_type, COUNT(*) AS call_count
FROM calls
GROUP BY user_name, task_type;
-- Yorum: Her bir kullanıcının hangi iş türünde toplam kaçar adet çağrı gerçekleştirdiğini detaylıca gösterir.

 **SORU9:R: Birden fazla robotu olan modeller.
Y: İkiden fazla çağrı almış modeller.
Dikkat: "ikiden fazla" kaçtan büyük demek? ______

  **CEVAP=
SELECT model
FROM robots
GROUP BY model
HAVING COUNT(*) > 1;
-- Yorum: Filoda birden fazla sayıda bulunan robot modellerini listeler.

SELECT model
FROM calls
GROUP BY model
HAVING COUNT(*) > 2;
-- Yorum: Toplamda 2'den fazla defa çağrı alan popüler modelleri listeler.
İkiden fazla kaçtan büyük demek? > 2 (yani 3 ve üzeri) demek.

 **SORU10:WHERE ve HAVING birlikte.

R: Sadece görevdeki robotları hesaba kat; en az 2 robotu olan modelleri ortalama bataryasıyla göster.
Y: Sadece 500 ms'den yavaş çağrıları hesaba kat; en az 2 çağrısı olan modelleri ortalama gecikmesiyle göster.
Bu sorguda WHERE neyi eledi, HAVING neyi eledi?

  **CEVAP=
SELECT model, AVG(battery_level) AS avg_battery
FROM robots
WHERE status = 'on_mission'
GROUP BY model
HAVING COUNT(*) >= 2;
-- Yorum: Görevde olan robotları filtreledikten sonra, gruplar halinde en az 2 robota sahip modellerin ortalama batarya seviyelerini gösterir.

SELECT model, AVG(latency) AS avg_latency
FROM calls
WHERE latency > 500
GROUP BY model
HAVING COUNT(*) >= 2;
-- Yorum: 500 milisaniyeden yavaş gerçekleşen çağrıları filtreledikten sonra, en az 2 çağrısı bulunan modellerin ortalama gecikme sürelerini gösterir.
WHERE neyi eledi? Gruplama (GROUP BY) yapmadan önce satırları tek tek inceleyerek koşula uymayan verileri eledi (R için görevde olmayan robotları, Y için 500 ms ve altındaki hızlı çağrıları sildi).
HAVING neyi eledi? Gruplama yapılıp özetlendikten sonra grup üzerindeki kısıtlamaları uygulayarak, üye sayısı 2'den az olan grupları eledi (yani o modelden toplamda 2'den az kalanları sonuçtan çıkardı).

 **SORU11:NULL avı. Tek bir sorguda count(*) ile her sütunun count'unu yan yana koy.

R: robots tablosunda hangi sütunda kaç eksik veri var?
Y: llm_calls tablosunda hangi sütunda kaç eksik veri var?
Sütun	Dolu	Eksik

  **CEVAP=
SELECT 
    COUNT(*) - COUNT(id) AS id_missing,
    COUNT(*) - COUNT(name) AS name_missing,
    COUNT(*) - COUNT(model) AS model_missing,
    COUNT(*) - COUNT(battery_level) AS battery_level_missing,
    COUNT(*) - COUNT(status) AS status_missing,
    COUNT(*) - COUNT(location) AS location_missing,
    COUNT(*) - COUNT(operator_name) AS operator_name_missing
FROM robots;
-- Yorum: Robots tablosundaki her bir sütunda toplam kaç tane eksik (NULL) veri olduğunu yan yana gösterir.

SELECT 
    COUNT(*) - COUNT(id) AS id_missing,
    COUNT(*) - COUNT(model) AS model_missing,
    COUNT(*) - COUNT(user_name) AS user_name_missing,
    COUNT(*) - COUNT(prompt_tokens) AS prompt_tokens_missing,
    COUNT(*) - COUNT(completion_tokens) AS completion_tokens_missing,
    COUNT(*) - COUNT(latency) AS latency_missing,
    COUNT(*) - COUNT(cost) AS cost_missing,
    COUNT(*) - COUNT(timestamp) AS timestamp_missing,
    COUNT(*) - COUNT(task_type) AS task_type_missing
FROM calls;
-- Yorum: Çağrılar tablosundaki her bir sütunda toplam kaç tane eksik (NULL) veri olduğunu yan yana gösterir.

 **SORU12:Eksik kayıtları bul.

R: Bilgisi eksik olan robotları listele (bataryası, bölgesi veya operatörü boş olanlar).
Y: Faturası gelmemiş çağrıları listele.
Önce = NULL ile dene. Kaç satır geldi? ______ Sonra IS NULL ile dene. Kaç satır geldi? ______

  **CEVAP=
SELECT *
FROM robots
WHERE battery_level IS NULL OR location IS NULL OR operator_name IS NULL;
-- Yorum: Bataryası, bulunduğu bölgesi veya operatör adı eksik (boş) olan robot kayıtlarını listeler.

SELECT *
FROM calls
WHERE cost IS NULL;
-- Yorum: Maliyet/fatura bilgisi henüz girilmemiş olan çağrı kayıtlarını listeler.
Önce = NULL ile dene. Kaç satır geldi? 0 satır geldi (çünkü SQL'de NULL değeri normal = operatörü ile karşılaştırılamaz, her zaman sonuç boş döner).
Sonra IS NULL ile dene. Kaç satır geldi? Veritabanındaki eksik kayıt sayısına göre gerçek sonuçlar (örneğin 1 veya 2 satır) geldi.

 **SORU13:İki ortalama. Ortalamayı iki şekilde hesapla ve yan yana göster: boşları atlayarak ve boşları sıfır sayarak (COALESCE).

Boşu atlayarak: ______ Boşu sıfır sayarak: ______

Hangisi bu veri için daha dürüst bir rapor olur? Neden?

  **CEVAP=
SELECT 
    AVG(battery_level) AS avg_skip_null,
    AVG(COALESCE(battery_level, 0)) AS avg_treat_as_zero
FROM robots;
-- Yorum: Robotların batarya ortalamasını hem eksik verileri tamamen yok sayarak hem de eksik verileri 0 kabul ederek yan yana kıyaslar.

SELECT 
    AVG(cost) AS avg_skip_null,
    AVG(COALESCE(cost, 0)) AS avg_treat_as_zero
FROM calls;
-- Yorum: Çağrı maliyet ortalamasını hem eksik faturaları hesaba katmayarak hem de onları 0 maliyetli kabul ederek yan yana kıyaslar.
Boşu atlayarak: Sadece gerçekten ölçülen/girilen veriler üzerinden ortalama alır
Boşu sıfır sayarak: Eksik verileri 0 kabul ederek toplam kayıt sayısına böler

 **SORU14:Zaman.

R: Operatörleri işe giriş yılına göre say. (operators tablosunu kullan.)
Y: Günlük kullanım raporu: gün, çağrı sayısı, toplam maliyet.
Y için ek soru: En çok çağrı alan gün hangisi? O günün maliyeti neden beklediğinden düşük?

  **CEVAP=
SELECT EXTRACT(YEAR FROM hire_date) AS hire_year, COUNT(*) AS operator_count
FROM operators
GROUP BY hire_year
ORDER BY hire_year;
-- Yorum: Operatörlerin işe giriş yıllarına göre kaçar kişi olduklarını gruplayarak listeler.

SELECT DATE(timestamp) AS call_date, COUNT(*) AS call_count, SUM(cost) AS total_cost
FROM calls
GROUP BY call_date
ORDER BY call_date;
-- Yorum: Günlük bazda yapılan çağrı sayısını ve o gün oluşan toplam maliyeti raporlar.
En çok çağrı alan gün hangisi? Veritabanındaki en yüksek çağrı sayısına sahip olan tarih
O günün maliyeti neden beklediğinden düşük? O gün yoğunluk çok fazla olmasına rağmen çağrılar genellikle daha kısa veya maliyeti düşük olan hafif görev türlerinden (task_type) oluştuğu için, toplam maliyet beklentinin altında kalmış olabilir.

 **SORU15:Kendi kategorini yarat (CASE WHEN) ve ona göre grupla.

R: Bataryaya göre: Kritik (20'nin altı), Düşük (20-59), Normal (60 ve üstü), Bilinmiyor. Her kategoride kaç robot var?
Y: Gecikmeye göre: Hızlı (1000 ms altı), Orta (1000-2499), Yavaş (2500 ve üstü). Her kategoride kaç çağrı var ve ortalama gecikme ne?
R için ek soru: WHEN battery_level IS NULL satırını en sona taşı ve tekrar çalıştır. Kartal-04 hangi kategoriye düştü? ______ Neden?

  **CEVAP=
SELECT 
    CASE 
        WHEN battery_level IS NULL THEN 'Bilinmiyor'
        WHEN battery_level < 20 THEN 'Kritik'
        WHEN battery_level BETWEEN 20 AND 59 THEN 'Düşük'
        ELSE 'Normal'
    END AS battery_category,
    COUNT(*) AS robot_count
FROM robots
GROUP BY battery_category;
-- Yorum: Robotları batarya seviyelerine göre kritik, düşük, normal ve bilinmiyor şeklinde kategorize ederek her gruptaki robot sayısını listeler.

SELECT 
    CASE 
        WHEN latency < 1000 THEN 'Hızlı'
        WHEN latency BETWEEN 1000 AND 2499 THEN 'Orta'
        ELSE 'Yavaş'
    END AS latency_category,
    COUNT(*) AS call_count,
    ROUND(AVG(latency), 1) AS avg_latency
FROM calls
GROUP BY latency_category;
-- Yorum: Çağrıları gecikme sürelerine göre hızlı, orta ve yavaş olarak sınıflandırıp gruplardaki toplam çağrı sayısını ve ortalama gecikmeleri hesaplar.
Kartal-04 hangi kategoriye düştü? Bilinmiyor
