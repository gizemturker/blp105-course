# Notlandırma Rubrikleri

Bu dosya, çalışmanın nasıl puanlandığını gösterir. Ödeve başlamadan önce ilgili rubriğe bak: neye göre değerlendirileceğini bilerek çalışmak, sonradan "bunu isteyeceğinizi bilmiyordum" demekten iyidir.

Her ölçüt dört seviyede değerlendirilir:

| Seviye | Puan çarpanı | Anlamı |
|---|---|---|
| **4: Tam** | 1,00 | İstenenin hepsi var, üstüne bir şey katmış |
| **3: İyi** | 0,80 | İstenen yapılmış, küçük eksikler var |
| **2: Gelişmeli** | 0,55 | Yarısı yapılmış ya da önemli hatalar var |
| **1: Yetersiz** | 0,25 | Çok eksik veya çalışmıyor |
| **0: Yok** | 0,00 | Teslim edilmemiş |

Puan hesabı: her ölçüt için `seviye çarpanı × ölçüt ağırlığı`, hepsi toplanır.

---

## 1. Haftalık Ödev Rubriği (Ödev 1-6, her biri 100 puan)

Bu rubrik iki notlu ödevin hepsinde aynıdır.

### Ölçüt A: Doğruluk (35 puan)

Sorgular çalışıyor mu ve doğru sonucu veriyor mu?

| 4, Tam (35) | 3, İyi (28) | 2, Gelişmeli (19) | 1, Yetersiz (9) |
|---|---|---|---|
| Soruların tamamı doğru. Bonus sorular da denenmiş | 1-2 soruda küçük hata (eksik koşul, yanlış sıralama) var ama yaklaşım doğru | Soruların yarısı doğru, ya da birkaç sorgu hata veriyor | Çoğu sorgu çalışmıyor veya soru atlanmış |

### Ölçüt B: SQL kalitesi ve okunabilirlik (20 puan)

Başkası bu sorguyu açıp anlayabilir mi?

| 4, Tam (20) | 3, İyi (16) | 2, Gelişmeli (11) | 1, Yetersiz (5) |
|---|---|---|---|
| Her ana kelime yeni satırda, tutarlı girinti, anlamlı takma adlar, gerektiği yerde yorum satırı. Her sorgunun üstünde soru numarası | Genelde düzenli, birkaç yerde dağınık | Tek satıra sıkışmış sorgular, takma ad yok, numaralandırma eksik | Okunamıyor, hangi sorgunun hangi soruya ait olduğu belli değil |

Beklenen biçim:

```sql
-- Soru 7: Şarjda veya bakımda olan, bataryası 50'nin altındaki robotlar
SELECT name, status, battery_level
FROM robots
WHERE (status = 'charging' OR status = 'maintenance')
  AND battery_level < 50;
```

### Ölçüt C: Yorum ve analiz (25 puan)

Sonucun ne anlama geldiğini anlamış mı? Bu ölçüt rapordan ve sorgu yorumlarından değerlendirilir.

| 4, Tam (25) | 3, İyi (20) | 2, Gelişmeli (14) | 1, Yetersiz (6) |
|---|---|---|---|
| Kaç satır döndüğünü ve **neden** o kadar döndüğünü açıklıyor. Beklenmedik bir sonuç varsa sebebini bulmuş (eksik veri, koşul önceliği). Kendi verisiyle bağ kurmuş | Sonuçları açıklamış ama yüzeysel; beklenmedik sonucun sebebini bulamamış | Sadece "çalıştı" demiş, yorum yok | Rapor boş veya ödevle ilgisi yok |

Bu ölçüt dersin kalbi. Sorgu yazmak kolay, asıl iş çıkan sayının doğru olup olmadığını anlamakta.

### Ölçüt D: Git ve PR disiplini (10 puan)

| 4, Tam (10) | 3, İyi (8) | 2, Gelişmeli (5,5) | 1, Yetersiz (2,5) |
|---|---|---|---|
| Doğru branch adı (`odev-NN`), en az 3 anlamlı commit, PR şablonu doldurulmuş, reviewer eklenmiş | Küçük eksik: commit mesajları zayıf ya da PR açıklaması kısa | Tek dev commit, ya da branch açmadan main'e yazılmış | PR yok, dosyalar rastgele yüklenmiş |

### Ölçüt E: Dürüstlük ve YZ beyanı (10 puan)

| 4, Tam (10) | 3, İyi (8) | 2, Gelişmeli (5,5) | 1, Yetersiz (2,5) |
|---|---|---|---|
| YZ kullandıysa hangi araç, hangi soru, ne sorduğu ve **nasıl doğruladığı** yazılmış. Kullanmadıysa açıkça belirtilmiş. Takıldığı yeri dürüstçe yazmış | Beyan var ama eksik (doğrulama kısmı yok) | Beyan bölümü boş bırakılmış | yok |

> **Beyan edilmemiş YZ kullanımı tespit edilirse ödevin tamamı sıfırlanır.** Bu ölçütten puan kırmakla kalmaz.

### Kâğıt rapor koşulu

Rapor derste teslim edilmemişse ödev **eksik** sayılır ve toplam puandan **%25 kesilir.** PR'ı açmış olman raporu getirmediğin gerçeğini değiştirmez.

### Örnek hesap

Bir öğrenci: A=3, B=4, C=3, D=4, E=4

```
A: 0,80 × 35 = 28,0
B: 1,00 × 20 = 20,0
C: 0,80 × 25 = 20,0
D: 1,00 × 10 = 10,0
E: 1,00 × 10 = 10,0
                 ──────
Toplam            88,0
```

---

## 2. Ara Sınav Rubriği (Hafta 8, 100 puan, dönemin %30'u)

Mini proje sunumu ve savunma. Yazılı sınav yok.

### Ölçüt A: Veri hikayesi (20 puan)

| 4, Tam | 3, İyi | 2, Gelişmeli | 1, Yetersiz |
|---|---|---|---|
| Hangi problemi çözdüğü net, veri kaynağı gerçek ve erişilebilir, neden bu veriyi seçtiğini gerekçelendiriyor | Problem tanımlı ama veri kaynağı zayıf ya da gerekçe yüzeysel | Problem belirsiz, veri kaynağı henüz bulunmamış | Senaryo kartı doldurulmamış |

### Ölçüt B: ERD ve modelleme (25 puan)

| 4, Tam | 3, İyi | 2, Gelişmeli | 1, Yetersiz |
|---|---|---|---|
| Varlıklar, nitelikler ve ilişkiler eksiksiz; kardinalite doğru işaretlenmiş; Mermaid ile çizilmiş ve GitHub'da görünüyor | ERD var, 1-2 ilişkide kardinalite hatası | ERD eksik veya elle çizilmiş fotoğraf | ERD yok |

### Ölçüt C: Sorgulama becerisi (25 puan)

Hafta 4-6'da öğrenilenlerin kendi verisine uygulanması.

| 4, Tam | 3, İyi | 2, Gelişmeli | 1, Yetersiz |
|---|---|---|---|
| Kendi verisine en az 5 anlamlı sorgu yazmış; JOIN, gruplama ve eksik veri ele alma var | 3-4 sorgu var, çeşitlilik sınırlı | Sadece basit SELECT'ler | Sorgu yok |

### Ölçüt D: Canlı savunma (20 puan)

Sunum sırasında sorulan sorulara verilen cevaplar.

| 4, Tam | 3, İyi | 2, Gelişmeli | 1, Yetersiz |
|---|---|---|---|
| Kendi kodunu satır satır açıklayabiliyor; "neden böyle yaptın" sorularına gerekçe veriyor; bilmediğini bilmediğini söylüyor | Çoğu soruyu cevaplıyor, bazılarında zorlanıyor | Kodunu açıklamakta zorlanıyor | Kendi çalışmasını anlatamıyor |

> Ölçüt D kritiktir. Kendi çalışmanı açıklayamıyorsan, diğer ölçütlerden aldığın puan sorgulanır.

### Ölçüt E: Plan (10 puan)

| 4, Tam | 3, İyi | 2, Gelişmeli | 1, Yetersiz |
|---|---|---|---|
| Kalan haftalar için gerçekçi, adım adım plan | Plan var ama genel | Belirsiz | Plan yok |

---

## 3. Final Rubriği (Hafta 12, 100 puan, dönemin %50'si)

Final üç parçadan oluşur: önceden teslim edilen proje reposu, `RAPOR.md` (ve çıktısı) ve final günü repodan sorulan bir soruya verilen 1-2 dakikalık cevap. Slayt ve sunum yoktur. Ayrıntı: [weeks/week-12/README.md](weeks/week-12/README.md)

| Ölçüt | Puan | Ne bakılır |
|---|---|---|
| A. Şema ve veri | 20 | Migration çalışıyor, PK/FK/NOT NULL/CHECK, gerçek veri, 3NF gerekçesi |
| B. Analiz sorguları | 15 | En az 10 sorgu; JOIN, gruplama, alt sorgu; iş sorusuna cevap |
| C. View, indeks, rol | 10 | En az 2 view, 1 gerekçeli indeks, 1 rol |
| D. YZ bileşeni | 10 | `jsonb`, pgvector veya text-to-SQL; neden seçildi, sınırı |
| E. Genişletme kartları (2 adet) | 15 | Her kart 7,5 puan: dosya çalışıyor, kanıt var |
| F. Rapor ve README | 10 | 5 başlık eksiksiz, repodaki `RAPOR.md` ile çıktı aynı, README'den proje kurulabiliyor |
| G. Repo sorusu cevabı | 20 | 1-2 dakika; kendi işini anlıyor mu |

### Ölçüt A: Şema ve veri (20 puan)

| 4, Tam | 3, İyi | 2, Gelişmeli | 1, Yetersiz |
|---|---|---|---|
| Migration dosyaları çalışıyor, kısıtlar (PK, FK, NOT NULL, CHECK) yerinde, gerçek veri yüklenmiş, 3NF gerekçelendirilmiş | Şema kurulu, bazı kısıtlar eksik | Şema var ama kısıtsız, veri az | Şema çalışmıyor |

### Ölçüt B: Analiz sorguları (15 puan)

| 4, Tam | 3, İyi | 2, Gelişmeli | 1, Yetersiz |
|---|---|---|---|
| En az 10 sorgu; JOIN, gruplama, alt sorgu çeşitliliği var; her sorgu bir iş sorusuna cevap veriyor | 7-9 sorgu, çeşitlilik sınırlı | 5-6 basit sorgu | 5'ten az |

### Ölçüt C: View, indeks, rol (10 puan)

| 4, Tam | 3, İyi | 2, Gelişmeli | 1, Yetersiz |
|---|---|---|---|
| En az 2 view, 1 indeks (`EXPLAIN ANALYZE` çıktısıyla gerekçeli), 1 rol tanımı | Üçünden biri eksik veya gerekçesiz | Sadece biri var | Hiçbiri yok |

### Ölçüt D: Yapay zeka bileşeni (10 puan)

| 4, Tam | 3, İyi | 2, Gelişmeli | 1, Yetersiz |
|---|---|---|---|
| `jsonb`, pgvector veya text-to-SQL'den biri çalışır halde; neden bu bileşeni seçtiğini açıklıyor; sınırlarını biliyor | Bileşen var ama yüzeysel | Denenmiş ama çalışmıyor | Yok |

### Ölçüt E: Genişletme kartları (15 puan, kart başına 7,5)

Her kart ayrı değerlendirilir; iki kartın puanı toplanır. Kartlar: [weeks/week-12/genisletme-kartlari.md](weeks/week-12/genisletme-kartlari.md)

| 4, Tam | 3, İyi | 2, Gelişmeli | 1, Yetersiz |
|---|---|---|---|
| Kartın teslim dosyaları eksiksiz ve çalışıyor; kanıt (çıktı, hata mesajı, süre farkı) var ve yorumlanmış | Dosyalar çalışıyor, kanıt var ama yorum yüzeysel | Dosya eksik ya da kısmen çalışıyor, kanıt zayıf | Kart seçilmiş ama dosya yok ya da çalışmıyor |

### Ölçüt F: Rapor ve README (10 puan)

| 4, Tam | 3, İyi | 2, Gelişmeli | 1, Yetersiz |
|---|---|---|---|
| `RAPOR.md` beş başlığın hepsiyle eksiksiz, her iddianın yanında repodaki kanıt dosyası var, çıktı repodaki metinle aynı; README'de problem, ERD, kurulum adımları, sorgu örnekleri ve "ne öğrendim" var, repoyu ilk kez açan biri projeyi kurabiliyor | Rapor ve README büyük ölçüde tamam, küçük eksikler var | Bir başlık eksik ya da kanıt sütunu boş; README kısa | Rapor yok ya da README şablon hâlinde |

> Repodaki `RAPOR.md` ile teslim edilen çıktı farklıysa repodaki metin geçerlidir ve fark bu ölçütten puan düşürür.

### Ölçüt G: Repo sorusu cevabı (20 puan)

Final günü reponun içinden bir soru sorulur (bir sorgun, bir kısıtın, bir indeksin, raporundaki bir cümle gibi); repoya bakarak 1-2 dakika cevap verirsin.

| 4, Tam | 3, İyi | 2, Gelişmeli | 1, Yetersiz |
|---|---|---|---|
| Doğru ve gerekçeli cevap; kendi kodunun ne yaptığını ve neden öyle yazıldığını açıklıyor | Cevap doğru ama gerekçe eksik ya da yüzeysel | Cevap kısmen doğru, kendi işini açıklamakta zorlanıyor | Cevap yok ya da çalışmanın kendisine ait olduğu anlaşılmıyor |

> "Bilmiyorum, şöyle araştırırdım" demek kısmi puan alır; uydurma cevap puan almaz.

### Dönem boyu commit geçmişi

Final notuna doğrudan bir ölçüt olarak girmez, ama **son hafta tek seferde yüklenmiş bir proje** savunmada ayrıntılı sorgulanır. Haftalık commit geçmişi, çalışmanın sana ait olduğunun kanıtıdır.

---

## 4. Öz değerlendirme

Her ödev raporunda kendine bir seviye verirsin. Bu puanını etkilemez; amacı kendi çalışmanı değerlendirmeyi öğrenmen.

İlginç olan şu: dönem sonunda öz değerlendirmelerle benim verdiğim notları karşılaştıracağız. Aradaki fark kapanıyorsa, işini değerlendirme becerin gelişiyor demektir. Bu, sorgu yazmak kadar değerli bir beceri.

---

## 5. İtiraz

Bir notun yanlış olduğunu düşünüyorsan:

1. Notun açıklandığı tarihten itibaren **5 iş günü** içinde bir issue aç (ders reposunda değil, bana doğrudan yaz).
2. Hangi ölçütte hangi seviyeyi hak ettiğini düşündüğünü, **rubriğe atıf yaparak** açıkla.
3. "Daha yüksek olmalıydı" yeterli değil; "Ölçüt C'de 3 aldım ama raporumun 2. paragrafında eksik verinin sonucu nasıl etkilediğini açıkladım" yeterlidir.

Haklıysan notu düzeltirim ve bunu söylemen iyi olur: rubriği netleştirmem gereken bir yer var demektir.
