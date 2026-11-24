# Ödev Raporu

**Ödev no:** Ödev 01     **Hafta:** 05     **Tarih:** 22 / 10 / 2026

**Ad Soyad:** Emin Turan GÜNGÖR  **Öğrenci No:** 202607131009

**Program:** ☑ Yapay Zeka Operatörlüğü  ☐ Robotik ve Yapay Zeka

**Kullandığım veritabanı:** ☑ `llm_ops`  ☐ `robot_fleet`

**PR bağlantısı:** `https://github.com/emin-gungor/blp105-course`

**Commit sayısı:** 3

---

## 1. Ne yaptım

Bu ödevde Python ile kâğıt üzerinde kod izleme yaparak döngü ve değişken takibi adımlarını uyguladım. Sensör verileri içerisinden eşik değerini aşan en uzun kesintisiz seriyi bulan bir algoritma tasarladım. Ayrıca hazır kütüphane kullanmadan, sözlük ve döngüler yardımıyla verileri elle gruplayarak algoritma ve veri mantığını pekiştirdim. PostgreSQL veritabanı üzerinde temel SQL sorgularını, filtreleme, gruplama ve toplulaştırma fonksiyonlarını uyguladım. Ayrıca AND ve OR gibi mantıksal operatörlerde parantez kullanımının sorgu mantığını nasıl etkilediğini öğrendim.

---

## 2. Sonuçlar

Çözdüğüm soru sayısı: 15 / 15     Bonus: ☐ denedim ☑ denemedim

En zorlandığım soru: **Ödevin BÖLÜM:3 BÖLÜM:4 kısmındaki soruların çoğu**

Neden zorlandım:
Ödevdeki BÖLÜM:3, BÖLÜM:4 kısmındaki konuyu derste anladığımı zannedip çok fazla üzerinde durmadığımdan kaynaklı olarak BÖLÜM:3, BÖLÜM:4 kısmındaki sorularda zorlandım.

Nasıl çözdüm:
Ödevdeki BÖLÜM:3, BÖLÜM:4 kısmının çoğu sorusunu yapay zeka araçlarını kullanarak çözmeye çalıştım.

---

## 3. Beklemediğim bir sonuç

Bir sorgu beklediğinden farklı sayıda satır döndürdü mü? Hangisi ve neden?

(Eksik veri, koşul önceliği, büyük/küçük harf, birim dönüşümü… Böyle bir durumla karşılaşmadıysan "karşılaşmadım" yaz, ama önce iyi bak.)

**Soru no:** Soru 10

**Beklediğim:** 3 satır   **Gelen:** 1 satır

**Sebebi:**
Veritabanında sohbet (`chat`) çağrısı yapan kullanıcıları listelerken en az 2 çağrı yapma şartı (`HAVING count(*) >= 2`) koyduğumda sadece Ece listelendi. Diğer sohbet çağrısı yapan kullanıcıların çağrı sayısı 1 olduğu için filtreye takıldıklarını verileri manuel kontrol edince fark ettim.

---

## 4. Aldığım bir hata ve çözümü

Dönem boyunca hata mesajı okumayı öğreniyoruz. Bu hafta aldığın bir hatayı yaz.

**Hata mesajı:**
`ERROR: relation "llm_calls" does not exist`

**Sebebi ve çözümü:**
Sorguyu çalıştırmak istediğim veritabanında `llm_calls` tablosu henüz oluşturulmadığı veya yanlış veritabanına bağlı olduğum için bu hatayı aldım. Tablo oluşturma ve veri yükleme script'ini (`CREATE TABLE` ve `INSERT`) çalıştırarak tabloyu veritabanına ekledim ve VS Code üzerinden aktif veritabanının `llm_ops` olduğundan emin olup sorguyu tekrar çalıştırarak çözdüm.

---

## 5. Yapay zeka kullanım beyanı

☐ Bu ödevde yapay zeka aracı **kullanmadım.**

☑ Kullandım, aşağıda belirttim:

| Soru no | Araç | Ne sordum (özet) | Cevabı nasıl doğruladım |
|---|---|---|---|
| Soru 7, 8, 14 | ChatGPT / Gemini | `GROUP BY` sonrası filtreleme için `WHERE` mi `HAVING` mi kullanılır? | SQL ortamında ikisini de çalıştırdım; `HAVING` kullanımının gruplanmış veri üstünde doğru çalıştığını gördüm. |
| Genel (Rapor & B4) | Gemini | Çıkan sonuç verilerinin ne anlama geldiğini açıklayan Türkçe yorum cümleleri önerisi istedim. | Veritabanındaki satır sayılarıyla yorumların doğruluğunu manuel eşleştirip kontrol ettim. |
| Hata Çözümü | ChatGPT | `relation does not exist` hatasının neden çıktığını sordum. | Tablo eksikliğini anlayıp tablo oluşturma SQL'ini çalıştırdım, sorgu başarılı döndü. |

---

## 6. Öz değerlendirme

Rubriğe ([RUBRIK.md](../RUBRIK.md)) göre kendine bir seviye ver. Bu puanını etkilemez.

| Ölçüt | 4 Tam | 3 İyi | 2 Gelişmeli | 1 Yetersiz |
|---|---|---|---|---|
| A, Doğruluk | ☑ | ☐ | ☐ | ☐ |
| B, SQL kalitesi | ☐ | ☐ | ☑ | ☐ |
| C, Yorum ve analiz | ☐ | ☐ | ☑ | ☐ |
| D, Git ve PR disiplini | ☐ | ☐ | ☐ | ☑ |
| E, Dürüstlük ve beyan | ☑ | ☐ | ☐ | ☐ |

Bir dahaki ödevde daha iyi yapacağım şey:
Ödevi son güne bırakmadan kademeli olarak yapacağım. Git commit mesajlarımı daha detaylı yazıp PR adımlarını daha düzenli takip edeceğim.

---

## 7. Bana sorun

Anlamadığın, merak ettiğin ya da derste tekrar görmek istediğin bir konu:
Pythonda döngüler ve sözlüklerle gruplama mantığını derste sözlü olarak üzerinden geçebiliriz.

---

**İmza:** Emin Turan GÜNGÖR

---

*Doğruluk beyanı: Bu çalışmayı kendim yaptım. Kullandığım tüm yardımcı kaynakları ve yapay zeka araçlarını yukarıda beyan ettim.*