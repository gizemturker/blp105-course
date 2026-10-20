DOĞUŞ ÜNİVERSİTESİ

Robotik ve Yapay Zeka Programı

BLP105 – Veritabanı Yönetim Sistemleri

Ödev 1 – Ayrıntılı Çalışma Raporu

Ad Soyad: Salih Üvet
Öğrenci Numarası: 202507130027
Teslim Tarihi: 23 Ekim 2026
Veritabanı: PostgreSQL – "robot_fleet"
GitHub Pull Request: PR oluşturulduktan sonra bağlantı eklenecek.

---

BÖLÜM 1 – ALGORİTMA VE PYTHON (20 PUAN)

Soru 1.1 – Tek ve Çift Sayılar

Soru: Verilen sayı listesindeki çift sayıları toplayınız ve tek sayıları ayrı bir listede saklayınız.

Python kodu:

numbers = [4, 7, 2, 9, 5, 1, 8]

total = 0
odds = []

for number in numbers:
    if number % 2 == 0:
        total += number
    else:
        odds.append(number)

print("Çift sayıların toplamı:", total)
print("Tek sayılar:", odds)

Cevap:

- Çift sayıların toplamı: 14
- Tek sayılar: [7, 9, 5, 1]

Açıklama: "for" döngüsü her sayıyı kontrol eder. Çift sayılar toplama eklenir, tek sayılar listeye alınır. Çift sayılar 4, 2 ve 8 olduğundan toplamları 14'tür.

Soru 1.2 – En Uzun Ardışık Seri

Soru: Verilen ölçümlerde 22'den büyük değerlerin oluşturduğu en uzun kesintisiz seriyi bulunuz.

Python kodu:

readings = [18, 21, 23, 25, 24, 26, 27,
            19, 20, 22, 23, 24, 25, 26]

threshold = 22
count = 0
longest = 0

for value in readings:
    if value > threshold:
        count += 1
        if count > longest:
            longest = count
    else:
        count = 0

print("En uzun seri:", longest)

Cevap: En uzun seri 5.

Açıklama: 23, 25, 24, 26 ve 27 değerleri arka arkaya 22'den büyüktür. Koşul bozulduğunda sayaç sıfırlanır. En büyük sayaç değeri 5 olarak bulunur.

Soru 1.3 – Derslerin Tekrar Sayısı

Soru: Derslerin kaç kez tekrarlandığını sözlük kullanarak hesaplayınız.

Python kodu:

records = [
    "VTYS",
    "Yapay Zeka",
    "VTYS",
    "Robotik",
    "Yapay Zeka",
    "VTYS"
]

counts = {}

for course in records:
    if course in counts:
        counts[course] = counts[course] + 1
    else:
        counts[course] = 1

print(counts)

Cevap:

{'VTYS': 3, 'Yapay Zeka': 2, 'Robotik': 1}

Açıklama: Sözlükte her dersin tekrar sayısı tutulur. Daha önce görülen derslerin sayısı artırılır, ilk kez görülen dersler 1 olarak kaydedilir.

Bölüm sonucu: Python'da döngü, koşul, sayaç, liste ve sözlük kullanımını uygulamalı olarak öğrendim.

---

BÖLÜM 2 – VERİTABANI KAVRAMLARI (10 PUAN)

Soru 2.1 – Excel ve Veritabanı

Soru: Verileri Excel dosyalarında tutmanın sorunları nelerdir?

Cevap: Veri tekrarları, tutarsızlıklar ve aynı anda düzenleme sorunları oluşabilir.

Açıklama: Aynı bilginin farklı dosyalarda bulunması, güncellemelerin her dosyaya yansımamasına neden olabilir. Veritabanları merkezi veri yönetimiyle bu sorunları azaltır.

Soru 2.2 – Birincil Anahtar

Soru: Primary Key nedir ve neden öğrenci numarası kullanılabilir?

Cevap: Birincil anahtar her kaydı benzersiz tanımlar.

Açıklama: Öğrencilerin ad ve soyadları aynı olabilir. Öğrenci numarası benzersiz tanımlandığında kayıtlar birbirinden ayrılabilir.

Soru 2.3 – DBMS ve Veritabanı

Soru: DBMS ile veritabanı arasındaki fark nedir?

Cevap: Veritabanı saklanan verilerin bütünüdür. DBMS bu verileri yönetmek için kullanılan yazılımdır.

Açıklama: "robot_fleet" veritabanıdır. PostgreSQL ise veritabanı yönetim sistemidir. pgAdmin, PostgreSQL'i yönetmek için kullanılan bir araçtır.

Soru 2.4 – Aynı Kaydın Düzenlenmesi

Soru: İki kişi aynı kaydı aynı anda değiştirmek isterse ne olabilir?

Cevap: Güncellemeler çakışabilir.

Açıklama: Veritabanı yönetim sistemleri işlem yönetimi ve eş zamanlılık kontrolüyle verilerin tutarlılığını korumaya yardımcı olur.

Bölüm sonucu: Veritabanlarının veri bütünlüğü ve düzenli kayıt yönetimi açısından önemini öğrendim.

---

BÖLÜM 3 – SQL SELECT VE WHERE (35 PUAN)

Bu bölümde "robot_fleet" veritabanı üzerinde 15 SQL sorusu çözüldü.

Soru 3.1 – Robot Adları ve Modelleri

SQL kodu:

SELECT name, model FROM robots;

Cevap: 10 satır.

Açıklama: "SELECT" ile robotların yalnızca ad ve model sütunları listelenir.

Soru 3.2 – Eksik Batarya Miktarı

SQL kodu:

SELECT name AS robot,
       100 - battery_level AS missing
FROM robots;

Cevap: 10 satır.

Açıklama: Batarya seviyeleri 100'den çıkarılarak eksik batarya miktarı hesaplanır. Batarya değeri "NULL" olan kaydın hesaplanan değeri de "NULL" olur.

Soru 3.3 – Bataryası 50'den Yüksek Robotlar

SQL kodu:

SELECT *
FROM robots
WHERE battery_level > 50;

Cevap: 4 satır.

Açıklama: "WHERE" koşulu batarya seviyesi 50'den büyük olan robotları filtreler.

Soru 3.4 – Bakımdaki Robotlar

SQL kodu:

SELECT *
FROM robots
WHERE status = 'maintenance';

Cevap: 1 satır.

Açıklama: Durumu "maintenance" olan robot bulunur.

Soru 3.5 – Bakımda Olmayan Robotlar

SQL kodu:

SELECT *
FROM robots
WHERE status <> 'maintenance';

Cevap: 9 satır.

Açıklama: "<>" operatörü eşit olmayan değerleri seçer.

Soru 3.6 – AMR-300 Modeli ve Batarya Koşulu

SQL kodu:

SELECT *
FROM robots
WHERE model = 'AMR-300'
  AND battery_level > 40;

Cevap: 2 satır.

Açıklama: "AND" kullanıldığı için iki koşulun da sağlanması gerekir.

Soru 3.7 – AND ve OR Karşılaştırması

Parantezli SQL kodu:

SELECT *
FROM robots
WHERE (status = 'charging' OR status = 'maintenance')
  AND battery_level < 50;

Cevap: 1 satır.

Parantezsiz SQL kodu:

SELECT *
FROM robots
WHERE status = 'charging'
   OR status = 'maintenance' AND battery_level < 50;

Cevap: 2 satır.

Açıklama: SQL'de "AND", "OR" işleminden önce değerlendirilir. Parantezler koşulların değerlendirilme sırasını değiştirir. Bu nedenle iki sorgunun sonucu farklıdır.

Soru 3.8 – Bataryası 15 ile 50 Arasında Olanlar

SQL kodu:

SELECT *
FROM robots
WHERE battery_level BETWEEN 15 AND 50;

Cevap: 3 satır.

Açıklama: "BETWEEN" alt ve üst sınırları da kapsar.

Soru 3.9 – Depo A ve Depo B Dışındaki Robotlar

SQL kodu:

SELECT *
FROM robots
WHERE zone NOT IN ('Depo A', 'Depo B');

Cevap: 5 satır.

Açıklama: "NOT IN" belirtilen iki bölge dışında kalan robotları getirir. Bölgesi "NULL" olan kayıt bu koşulla seçilmez.

Soru 3.10 – Adı Kartal ile Başlayan Robotlar

SQL kodu:

SELECT *
FROM robots
WHERE name ILIKE 'kartal%';

Cevap: 4 satır.

Açıklama: "ILIKE" büyük-küçük harf ayrımı yapmadan metin eşleştirir. "%" sonraki karakterleri temsil eder.

Soru 3.11 – Modele ve Bataryaya Göre Sıralama

SQL kodu:

SELECT *
FROM robots
ORDER BY model ASC, battery_level DESC;

Cevap: 10 satır.

Açıklama: Robotlar önce model adına göre artan, aynı model içindeyse batarya seviyesine göre azalan sırada gösterilir.

Soru 3.12 – Bataryası En Yüksek Üç Robot

SQL kodu:

SELECT *
FROM robots
ORDER BY battery_level DESC
LIMIT 3;

Cevap: 3 satır.

Açıklama: "ORDER BY" batarya seviyelerini büyükten küçüğe sıralar. "LIMIT 3" ilk üç kaydı getirir.

Soru 3.13 – Tekrarsız Bölgeler

SQL kodu:

SELECT DISTINCT zone
FROM robots;

Cevap: 7 satır.

Açıklama: "DISTINCT" tekrar eden bölge değerlerini tekilleştirir.

Soru 3.14 – Operatör Adlarını Sıralama

Normal sıralama:

SELECT operator_name
FROM robots
ORDER BY operator_name;

Türkçe sıralama:

SELECT operator_name
FROM robots
ORDER BY operator_name COLLATE "tr-TR-x-icu";

Cevap: Her iki sorguda 10 satır.

Açıklama: Kullanılan sıralama kuralları Türkçe karakterlerin listedeki konumlarını etkileyebilir.

Soru 3.15 – Belirli Bölgelerde Görevdeki Robotlar

SQL kodu:

SELECT name, zone, battery_level
FROM robots
WHERE zone IN ('Dış Alan', 'Depo B')
  AND status = 'on_mission'
ORDER BY battery_level ASC;

Cevap: 3 satır.

Açıklama: Yalnızca belirtilen bölgelerde ve görev durumunda olan robotlar seçilir. Sonuçlar batarya seviyesine göre küçükten büyüğe sıralanır.

Bölüm sonucu: SQL'de filtreleme, sıralama, karşılaştırma, mantıksal operatörler ve tekrar eden verileri ayıklama konularını öğrendim.

---

BÖLÜM 4 – GRUPLAMA VE NULL (35 PUAN)

Bu bölümde "COUNT", "GROUP BY", "HAVING", "AVG", "COALESCE", "CASE" ve "NULL" işlemleri incelendi. Ayrıntılı SQL sorguları "bolum4.sql" dosyasında bulunmaktadır.

Soru 4.1 – Toplam Robot Sayısı

SQL kodu:

SELECT COUNT(*)
FROM robots;

Cevap: 10 robot.

Açıklama: "COUNT(*)" tablodaki toplam kayıt sayısını hesaplar.

Soru 4.10 – Aktif Robotların Modellere Göre Gruplanması

Cevap: En az iki aktif robot içeren 2 model grubu bulundu. Bu gruplarda toplam 5 aktif robot vardır.

Açıklama: "WHERE" önce aktif robotları seçer. "GROUP BY" robotları modellerine göre gruplar. "HAVING" ise en az iki kayıt içeren grupları bırakır.

Soru 4.11 – NULL Kontrolü

Cevap: Toplam 10 robot kaydı bulunmaktadır. Batarya, bölge ve operatör bilgilerinde eksik değerler incelendi.

Açıklama: "COUNT(*)" bütün satırları sayarken "COUNT(sütun)" ilgili sütunda "NULL" olmayan değerleri sayar. Eksik değerleri bulmak için "IS NULL" kullanılmalıdır.

Soru 4.13 – İki Farklı Ortalama

Cevap:

- Boş değerleri atlayarak: 42,3
- Boş değerleri sıfır sayarak: 38,1

Açıklama: "AVG" normalde "NULL" değerlerini hesaba katmaz. "COALESCE" ile boş değerler sıfıra çevrildiğinde ortalama düşebilir. Eksik değer gerçekten sıfır anlamına gelmiyorsa sıfır kabul etmek yanıltıcı olabilir.

Soru 4.14 – Operatörlerin İşe Giriş Yılları

Cevap:

İşe giriş yılı| Operatör sayısı
2023| 1
2024| 3
2025| 4
2026| 2

Açıklama: Operatörler işe giriş yıllarına göre gruplandırılmıştır. En fazla operatör 2025 yılında işe başlamıştır.

Soru 4.15 – Batarya Kategorileri

Cevap: 10 robot batarya seviyelerine göre kategorilere ayrıldı.

Kategoriler:

- Kritik: 20'nin altı
- Düşük: 20–59
- Normal: 60 ve üzeri
- Bilinmiyor: Batarya değeri "NULL"

Açıklama: "CASE WHEN" koşullara göre kategori üretir. Batarya değeri eksik olan robot Bilinmiyor kategorisine yerleştirilmiştir.

Bölüm sonucu: Gruplama ve toplulaştırma işlemlerini, "NULL" değerlerinin sorgu sonuçlarına etkisini ve verilerin kategorilere ayrılmasını öğrendim.

---

KARŞILAŞTIĞIM SORUNLAR VE ÇÖZÜMLER

SQL sorgularında "AND" ve "OR" ifadelerinin işlem önceliğinin sonucu değiştirebildiğini gördüm. Aynı sorguyu parantezli ve parantezsiz çalıştırarak farkı karşılaştırdım.

Ayrıca "NULL" değerlerinin normal sayısal değerlerden farklı işlendiğini öğrendim. Eksik değerleri atlayan ve sıfır kabul eden ortalamaları karşılaştırdım.

YAPAY ZEKA KULLANIM BEYANI

Bu ödevde ChatGPT aracından yardım aldım.

Yapay zekayı Python ve SQL kodlarını anlamak, sorgu örnekleri hazırlamak, hataları değerlendirmek ve raporu düzenlemek için kullandım.

Örnek sorularım:

- “Python'da en uzun ardışık seri nasıl bulunur?”
- “SQL'de AND ve OR neden farklı sonuç verir?”
- “NULL değerleri ortalamayı nasıl etkiler?”
- “SQL sorgularının sonuçlarını nasıl açıklayabilirim?”

Python kodlarını Visual Studio Code'da, SQL sorgularını ise PostgreSQL pgAdmin üzerinde çalıştırarak sonuçlarını kontrol ettim.

GENEL DEĞERLENDİRME

Bu ödevde Python algoritmaları, veritabanı kavramları, SQL filtreleme ve gruplama konularında uygulama yaptım.

En şaşırtıcı sonuç, SQL'de parantez kullanımının aynı koşullarla farklı sayıda kayıt getirebilmesiydi. Ayrıca eksik değerlerin ortalama hesaplarını değiştirebildiğini öğrendim.

Hocama sorum: Gerçek bir robot filosunda eksik batarya verilerini analiz ederken "NULL" değerlerini dışarıda bırakmak mı, yoksa belirli bir değerle doldurmak mı daha doğru olur?
