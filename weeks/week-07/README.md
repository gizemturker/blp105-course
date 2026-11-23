# Hafta 7: E-R modeli ve normalizasyon

Durum: Yayında

> Bu hafta iki konuyu birleştiriyor: önce modeli çıkarıyoruz, sonra onu düzeltiyoruz. İkisi birlikte işlenince "neden bu tabloyu böldük" sorusunun cevabı aynı derste veriliyor.

## Bu hafta ne işliyoruz

**E-R modeli**

- Varlık, varlık kümesi, nitelik (basit, bileşik, çok değerli, türetilmiş)
- İlişki, kardinalite (1-1, 1-N, M-N), zorunlu ve isteğe bağlı katılım
- Zayıf varlıklar
- Chen ve crow's foot notasyonu
- E-R modelinden ilişkisel şemaya dönüşüm kuralları
- Mermaid `erDiagram` ile ERD'yi markdown içinde çizme

**Normalizasyon**

- Veri anomalileri: ekleme, silme, güncelleme
- Fonksiyonel bağımlılık, süper anahtar, aday anahtar, birincil anahtar
- 1NF (atomik değerler), 2NF (kısmi bağımlılık), 3NF (geçişli bağımlılık)
- BCNF'ye kısa bakış
- Denormalizasyon: ne zaman ve neden

## Hafta sonunda yapabileceklerin

- Bir problem senaryosundan E-R modeli çıkarabilirsin
- ERD'ni Mermaid ile README içine çizip GitHub'da otomatik render ettirebilirsin
- Fonksiyonel bağımlılıkları belirleyip bir şemayı 3NF'ye taşıyabilirsin
- Bilinçli bir denormalizasyon kararını gerekçelendirebilirsin

## Ders verisi üzerinden bir tartışma

Örnek veritabanlarımızda `operators` ve `model_catalog` tablolarının birincil anahtarı doğrudan **isim**: `operator_name` ve `model_name` (natural key). JOIN öğrenirken bu işimizi kolaylaştırdı.

Bu hafta soracağımız soru: **aynı isimde ikinci bir operatör işe alınırsa ne olur?** Cevap, yapay anahtar (surrogate key) kavramına götürecek.

## Anahtar terimler

| English | Türkçe |
|---|---|
| entity / attribute / relationship | varlık / nitelik / ilişki |
| cardinality | kardinalite |
| weak entity | zayıf varlık |
| natural key / surrogate key | doğal anahtar / yapay anahtar |
| functional dependency | fonksiyonel bağımlılık |
| normalization (1NF, 2NF, 3NF) | normalizasyon |
| anomaly | anomali |
| denormalization | denormalizasyon |

Tüm terimler: [GLOSSARY.md](../../GLOSSARY.md)

## Laboratuvar

Hazır bir senaryodan birlikte ERD çıkarma, sonra kendi senaryon için ilk ERD taslağını çizme. Normalize edilmemiş bir CSV'yi adım adım 3NF'ye taşıma.

## Okuma

*Database System Concepts*, 7. baskı, E-R modelleme ve normalizasyon bölümleri: https://www.db-book.com/

## Ek kaynaklar

Mermaid ERD sözdizimi: https://mermaid.js.org/syntax/entityRelationshipDiagram.html

## Kilometre taşı

ERD ve normalizasyon planı

## Ödev

**Ödev 2: JOIN, ERD ve normalizasyon** (100 puan). Yönerge: [odev.md](odev.md)

- Son teslim: Cuma 27 Kasım 2026, ders saatinden önce (09:00)
- PR ile teslim: branch `odev-02`, reviewer **gizemturker**
- **Kâğıt rapor aynı gün derste elden teslim edilir**

Kurallar: [ODEVLER.md](../../ODEVLER.md), rubrik: [RUBRIK.md](../../RUBRIK.md)

