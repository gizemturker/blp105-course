# Hafta 12: Final, repo, rapor ve repo sorusu

Durum: Yakında

## Bu hafta ne oluyor

Dönemin son haftası. Final üç parçadan oluşur:

1. **Repo, önceden teslim:** Projen kendi GitHub reponda, final gününden önce tamamdır. Son teslim tarihi sonra duyurulacak.
2. **Rapor:** Projen hakkında 2 sayfalık bir rapor yazar, `RAPOR.md` olarak repoya koyarsın ve çıktısını alıp getirirsin. Repodaki metin ile çıktı birebir aynı olmalıdır.
3. **Final günü:** Repondan bir soru sorulur, sen 1-2 dakika cevap verirsin. Slayt ve video yok.

Final tarihi 5-17 Aralık arasında ilan edilecek. Çıktının nereye ve ne zaman teslim edileceği de tarihle birlikte duyurulacak.

## Teslim içeriği (repo)

Projen kendi GitHub reponda, şunlar eksiksiz olacak:

- **Şema:** migration dosyaları (`CREATE TABLE`, kısıtlar, indeksler)
- **Veri:** gerçek kaynağından yüklenmiş veri ve yükleme adımları
- **ERD:** Mermaid ile çizilmiş, README içinde görünen
- **Normalizasyon notu:** hangi tabloları neden böldün
- **Analiz sorguları:** en az 10 sorgu (JOIN, gruplama, alt sorgu içeren)
- **Görünümler:** en az 2 view
- **İndeks:** en az 1 indeks ve gerekçesi (`EXPLAIN ANALYZE` çıktısıyla)
- **Güvenlik:** en az 1 rol tanımı
- **YZ bileşeni:** `jsonb`, pgvector veya text-to-SQL değerlendirmesi
- **Genişletme kartları:** seçtiğin 2 kart, `genisletme/` klasöründe (aşağıya bak)
- **`RAPOR.md`:** repo kökünde, aşağıdaki biçimde
- **README:** problem, ERD, kurulum adımları, sorgu örnekleri, "ne öğrendim" bölümü ve seçtiğin kartlar

Yedek dosyaları (`.dump`) repoya girmez.

## Rapor

- **Uzunluk:** 2 sayfa A4. **Dosya:** repo kökünde `RAPOR.md`. **Şablon:** [templates/final-rapor-sablonu.md](../../templates/final-rapor-sablonu.md)
- **Beş başlık:** problem; şema ve ERD açıklaması; genişletme kartları (kart başına "ne yaptım" ve "neyi kanıtlıyor", dosya yolu ve commit ile); YZ bileşeni ve sınırı; ne öğrendim.
- **Kanıt sütunu:** raporda yazdığın her iddianın yanına, onu gösteren repo dosyasını yaz.
- **Aynılık kuralı:** çıktı, repodaki `RAPOR.md` ile aynı metin olmak zorundadır. Kontrol derste yan yana bakarak yapılır: repodaki dosya ekranda, çıktı elinde. Fark çıkarsa repodaki metin geçerlidir ve fark puan düşürür.
- Bu rapor, Ödev raporlarından ayrı bir belgedir.

## Genişletme kartları

Projen çalışıyor; şimdi sistemi gerçek hayata yaklaştırıyorsun. [genisletme-kartlari.md](genisletme-kartlari.md) içindeki altı karttan **iki tanesini** seç ve kendi projene uygula: güvenilir işlem, rapor katmanı, hız kanıtı, rol ve güvenlik, veri kalitesi, yedekle ve geri yükle. Kartların dosyaları repoda `genisletme/` klasörüne girer, kart seçimini README'ne yaz.

## Final günü: repo sorusu

- Soru **senin reposundan** sorulur, bu yüzden ezberlenemez. Repoya bakarak cevap verebilirsin.
- Süre: cevap için 1-2 dakika.
- Örnek soru türleri: bir sorgunun ne yaptığı ve hangi tabloyu hangisine bağladığı; bir kısıtı (`CHECK`, `FK`, `UNIQUE`) neden koyduğun ve olmasaydı ne olacağı; bir indeksi neden o sütuna koyduğun ve planın nasıl değiştiği; raporundaki bir cümleyi hangi dosyanın kanıtladığı; bir view'i silsen hangi sorgunun bozulacağı; bir `UPDATE`'i çalıştırmadan önce ne yapacağın; kartında karşılaştığın en büyük sorun ve çözümü; bir tabloya yeni sütun eklesen şemanın neresinin değişeceği.
- Bilmiyorsan "bilmiyorum, şöyle araştırırdım" de: kısmi puan alır. Uydurma cevap puan almaz.

## Puanlama özeti

100 puan, dönemin %40'ı. Ayrıntılı seviyeler: [RUBRIK.md](../../RUBRIK.md) Bölüm 3.

| Ölçüt | Puan |
|---|---|
| A. Şema ve veri | 20 |
| B. Analiz sorguları | 15 |
| C. View, indeks, rol | 10 |
| D. YZ bileşeni | 10 |
| E. Genişletme kartları (2 adet, kart başına 7,5) | 15 |
| F. Rapor ve README | 10 |
| G. Repo sorusu cevabı | 20 |

## Hazırlık ipuçları

- Reponu ilk kez açan biri gibi oku: README'den projeyi kurabiliyor musun?
- Raporda yazdığın her cümlenin yanında repodan bir dosya göster; bulamıyorsan cümleyi ya da dosyayı düzelt.
- Kendi sorgularını, kısıtlarını ve indekslerini neden öyle yazdığını söyleyebilecek durumda ol.
- Hafta 11 laboratuvarında view, indeks, rol ve YZ bileşeni parçalarını tamamla; kartlara erken başla.

## Kilometre taşı

Ana proje teslimi

## Ağırlık

Dönem notunun %40'ı. Ayrıntı: [SYLLABUS.md](../../SYLLABUS.md)

## Sonrası

Projen artık portfolyonda. LinkedIn'de paylaşmak gönüllüdür ve notu etkilemez, ama bir işe başvururken "şunu yaptım" diyebileceğin somut bir şeyin olması işe yarar.
