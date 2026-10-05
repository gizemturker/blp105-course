# Hafta 3 · Slaytların metin sürümü

Bu sayfa, derste projeksiyonda gösterilen slaytların erişilebilir metin sürümüdür. Ekran okuyucuyla okunabilir, tarayıcıda büyütülebilir (Ctrl ve +) ve dersten önce ya da ders sırasında kendi cihazında takip edilebilir. Görseller ve diyagramlar yazıyla tarif edilmiştir.

## İçindekiler

1. [Açılış](#1-açılış)
2. [Kavramlar](#2-kavramlar)
3. [PostgreSQL ve mimari](#3-postgresql-ve-mimari)
4. [Dönem planı](#4-dönem-planı)
5. [Laboratuvar](#5-laboratuvar)

---

## 1. Açılış

### Slayt 1 · Neden veritabanı?

Veritabanı Yönetim Sistemleri, Hafta 3 / 14.

Bugün dönem boyunca büyüteceğin projeyi çekeceksin. Ocakta onu sektörden bir jürinin önünde sunacaksın.

Alt satırdaki kod: `SELECT name FROM robots WHERE battery < 20;`

### Slayt 2 · 90 saniye. Robotunu ekle.

1. Paylaşılan tabloya kendi robotunu yeni bir satır olarak ekle.
2. Bataryası yüzde 20'nin altında olan bir robot bul ve durumunu "bakımda" yap.
3. Kimseyi beklemeden kaydet. Hızlı olan kazanır.

Süre: 90 saniye. Tablonun linki derste QR kod ve kısa link olarak verilir.

### Slayt 3 · Bu tabloya güvenir misiniz?

Peki bu bir hastanenin ilaç listesi olsaydı?

### Slayt 4 · Tablonun başına gelen dört şey

| No | Sorun | Örnek |
|---|---|---|
| 1 | Tekrar | Aynı robot üç kez eklendi. Hangisi gerçek, hangisi kopya? |
| 2 | Tutarsızlık | Çağla, Cagla, ÇAĞLA. Bir kişi mi, üç kişi mi? Tablo bilemiyor. |
| 3 | Çakışma | İki kişi, aynı hücre, aynı an. Birinin yazdığı sessizce kayboldu. |
| 4 | Yetkisiz erişim | Linki olan her şeyi silebilir. Kimin neye dokunabileceğine dair kural yok. |

## 2. Kavramlar

### Slayt 5 · Veri, bilgi, karar

Soldan sağa, oklarla bağlı üç kutu:

1. **Veri:** `battery_level = 18`. Tek başına anlamsız bir sayı.
2. **Bilgi:** `18 < 20`. Bu robotun bataryası kritik eşiğin altında.
3. **Karar:** bakıma gönder. Bilgiye dayanarak harekete geçmek.

Veritabanı zincirin ilk halkasını sağlam tutar. Diğer halkalar ona yaslanır.

### Slayt 6 · VTYS: veriyi saklar, korur ve sorulara cevap verir

| Sorun | VTYS'nin cevabı | Hafta |
|---|---|---|
| Tekrar | Anahtarlar ve normalizasyon | 7, 9 |
| Tutarsızlık | Veri tipleri ve bütünlük kısıtları | 9 |
| Çakışma | Transaction ve eşzamanlılık kontrolü | 10 |
| Yetkisiz erişim | Roller ve yetkiler | 13 |

Açılıştaki dört sorun, bu dönemin haritası. Her birini sırayla çözeceğiz.

### Slayt 7 · İlişkisel model: her şey bir tablo

Örnek `robots` tablosu (değerler örnek veridir):

| id | name | model | battery_level | is_active |
|---|---|---|---|---|
| 1 | Atlas-01 | AMR-200 | 76 | true |
| 2 | Kuzgun-02 | AMR-200 | 18 | true |
| 3 | Mercan-03 | UAV-X | 54 | false |

- **Satır = kayıt:** Bir robotun tamamı.
- **Sütun = nitelik:** Tüm robotların tek bir özelliği.
- **Şema = sözleşme:** Hangi sütun var, hangi tipte veri alır.

### Slayt 8 · Geçen haftanın döngüsü, bu haftanın tek satırı

Python ile, nasıl yapılacağını adım adım söylersin:

```python
for robot in robots:
    if robot.battery < 20:
        print(robot.name)
```

SQL ile, ne istediğini söylersin:

```sql
SELECT name
FROM robots
WHERE battery < 20;
```

Eşleşmeler: `for robot in robots` ile `FROM robots`, `if` ile `WHERE`, `print(robot.name)` ile `SELECT name`.

Döngüyü veritabanı senin yerine kurar. Sen sadece soruyu sorarsın.

## 3. PostgreSQL ve mimari

### Slayt 9 · Neden PostgreSQL?

- **Açık kaynak:** Ücretsiz. Laptopunda, bulutta ve şirkette aynı sistem.
- **Eklentiler:** Yeni yetenekler eklenebilir. Yapay zekâ projelerinde vektör arama bunlardan biri.
- **Standart SQL:** Burada öğrendiğin SQL, diğer ilişkisel sistemlere büyük ölçüde taşınır.

### Slayt 10 · Bir PostgreSQL sunucusunun katları

İç içe kutulardan oluşan bir diyagram, dıştan içe:

- **Küme:** tek bir PostgreSQL kurulumu. İçinde iki veritabanı var.
  - **Veritabanı `robot_fleet`**
    - **Şema `public`**
      - Tablolar: `robots`, `sensors`, `missions`, `sensor_readings`
  - **Veritabanı `llm_ops`:** aynı kümede komşu kat. Tablolar: `models`, `prompts`, `llm_calls`

Haftaya laboratuvarda psql komutlarıyla bu katlar arasında gezeceğiz.

### Slayt 11 · Haftaya kuracağın zincir

Soldan sağa, oklarla bağlı dört halka:

1. **Laptopun:** Sadece tarayıcı. Kurulum yok.
2. **GitHub bulutu:** Senin için açılan sanal makine.
3. **Codespace:** Hazır ortam. psql istemcisi burada.
4. **PostgreSQL:** Sunucu. Veritabanları burada yaşar.

Sunucu her bağlantı için ayrı bir süreç açar. Örnek: öğrenci A, öğrenci B ve öğrenci C için üç ayrı `postgres` süreci.

### Slayt 12 · SQL'in beş fiili

| Alt dil | Fiil | Örnek komutlar |
|---|---|---|
| DQL (dönemin ilk aleti) | sor | SELECT |
| DDL | inşa et | CREATE TABLE, ALTER TABLE |
| DML | değiştir | INSERT, UPDATE, DELETE |
| DCL | izin ver | GRANT, REVOKE |
| TCL | söz ver, geri al | BEGIN, COMMIT, ROLLBACK |

Önce sorgulayacak, sonra tasarlayacağız.

### Slayt 13 · Aynı sistem, iki dünya

- **Yapay Zeka Operatörlüğü:** Veritabanı, bir LLM uygulamasının kara kutusudur. Her çağrının prompt'u, modeli, token sayısı ve maliyeti `llm_calls` tablosunda iz bırakır.
- **Robotik ve Yapay Zeka:** Veritabanı, bir robot filosunun hafızasıdır. Her sensör okuması `sensor_readings`, her görev olayı `mission_events` tablosuna düşer. Robot unutur, kayıt kalır.

## 4. Dönem planı

### Slayt 14 · Dönem fragmanı

Ocak ayında, sektörden bir jürinin önünde, kendi projeni sunacaksın.

- 40 öğrenci, 40 farklı proje
- 1 repo, dönem boyunca her hafta büyüyen
- 5 dakika, jüri önünde senin sahnen

### Slayt 15 · Dağınık veriden jüri sahnesine

| Haftalar | Aşama | İçerik |
|---|---|---|
| 3–5 | Sor | Kura, gerçek veri, ilk sorgular, gruplama |
| 6–8 | Tasarla | E-R modeli, normalizasyon, ara sınav sunumu |
| 9–12 | İnşa et | Tablolar, veri taşıma, JOIN, görünümler, YZ |
| 13–14 | Sahne | Güvenlik, portfolyo, jüri sunumu |

Her hafta derste bir kavram öğreniyorsun, aynı kavramı kendi projene uyguluyorsun ve commit ediyorsun.

### Slayt 16 · Notun nereden geliyor?

| Bileşen | Ağırlık | Ne yapacaksın? |
|---|---|---|
| Ara sınav | %30 | Hafta 8: kendi verinle mini proje ve sunum |
| Proje | %30 | Her hafta commit ve lab föyü |
| Final | %40 | Ana proje ve jüri önünde 5 dakikalık sunum |

- **YZ kullanmak serbest:** Lab föyüne aracı ve prompt'unu yaz. Beyan zorunlu.
- **Gerçek veri kuralı:** Her projede en az bir gerçek veri kaynağı olacak.
- **Commit geçmişi konuşur:** Son gece tek dev commit yerine her hafta bir adım.

### Slayt 17 · Kendi zorluk seviyeni seç

- **Core:** Sadece SQL. Hazır açık veriyle tasarım ve analiz. Tam puan alınabilir.
- **Plus:** SQL ve Python. Veriyi kendin toplayan bir script: API, sensör, açık veri.
- **Pro:** SQL, Python ve LLM. Türkçe soruyu SQL'e çeviren ya da küçük bir arayüzü olan proje.

Seviyeni dönem içinde yükseltebilirsin. Jüri, teknik derinliği ayrıca puanlar.

### Slayt 18 · Takım quizi

1. 5 kişilik takımlar kurun. Takıma bir isim verin.
2. Takım başına tek telefon kahoot.it adresine girsin.
3. Cevabı takımca tartışın.

Oyun PIN'i derste sesli okunur ve tahtaya yazılır.

## 5. Laboratuvar

### Slayt 19 · Repo, kura, ilk commit

| Süre | Adım | İçerik |
|---|---|---|
| 0–25 dk | Repo | Şablondan kendi projeni oluştur |
| 25–60 dk | Kura | Üç çark, senin senaryon |
| 60–85 dk | Senaryo kartı | SCENARIO.md, repo adı, lab föyü |
| 85–100 dk | Kayıt | Form ve çıkış bileti |

Bugün hiçbir şey kurmuyoruz. Her şey tarayıcıda, github.com üzerinde.

### Slayt 20 · Kendi proje reponu oluştur

1. Proje şablonu sayfasını aç (link ders reposunun ana sayfasında).
2. **Use this template**, ardından **Create a new repository**.
3. Owner: kendi hesabın. İsim: şimdilik `db-project`. **Public** seç.
4. **Create repository**.

Adım tamam sayılır: kendi hesabında `db-project` reposu açıldığında.

Ayrıntılı rehber: [Kendi proje reponu oluştur](../../guides/create-your-repo.md)

### Slayt 21 · Canlı kura: üç çark, tek bir sen

- **Çark 1, Alan:** Sağlık, tarım, lojistik, eğitim, e-ticaret, akıllı şehir
- **Çark 2, Sistem:** Sohbet botu, öneri motoru, robot veya drone, kamera, sensör ağı, RAG asistanı
- **Çark 3, YZ dokunuşu:** Maliyet takibi, prompt sürümleme, model karşılaştırma, anomali tespiti, geri bildirim, güvenlik

216 olası kombinasyon. Hiçbiri iki kez çıkmaz. Sonucun derste sesli okunur.

### Slayt 22 · Senaryonu yaz, reponu adlandır, commit et

1. `SCENARIO.md`: kalem ikonu, kura sonucun, tek cümlelik fikrin, ilk soruların, sonra **Commit changes**.
2. Settings, Repository name: İngilizce, küçük harf, tireli bir ad. Örnek: `smart-farm-drone-db`.
3. `lab-sheets/week-03.md`: lab föyünü doldur, sonra **Commit changes**.

| Kötü commit mesajı | İyi commit mesajı |
|---|---|
| update | Week 3: scenario card |
| son hali | Week 3: lab sheet |

### Slayt 23 · Kayıt ve haftaya ödev

**Şimdi:** Kayıt formu (ad, öğrenci no, GitHub kullanıcı adı, repo linki). Link derste paylaşılır.

**Haftaya:**

1. `SCENARIO.md` içindeki beş soruyu tamamla.
2. Senaryon için bir gerçek veri kaynağı bul, linkini yaz.
3. Lab föyünün PDF'ini LMS'e yükle.

Veri fikirleri: [İBB Açık Veri](https://data.ibb.gov.tr), [Kaggle Datasets](https://www.kaggle.com/datasets), [Hugging Face Datasets](https://huggingface.co/datasets), [Open-Meteo](https://open-meteo.com/), phyphox (telefon uygulaması).

### Slayt 24 · Çıkış bileti

1. Excel tablosu ile veritabanı arasındaki en önemli fark sence hangisi?
2. Döngüde "nasıl" yapılacağını söylüyorsun. SQL'de neyi söylüyorsun?
3. Kura senaryon hakkında içinden geçen ilk duygu: heyecan, korku, merak?
