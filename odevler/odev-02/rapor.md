# Ödev Raporu

> **Bu rapor yazdırılıp derste elden teslim edilir.** Aynı dosya reponda `odevler/odev-02/rapor.md` olarak da durur.

---

**Ödev no:** Ödev 2     **Hafta:** 7     **Tarih:** 27 / 11 / 2026

**Ad Soyad:** Kutay Berat YAKIŞIK  **Öğrenci No:** 202607131025

**Program:** ☑ Yapay Zeka Operatörlüğü  ☐ Robotik ve Yapay Zeka

**Kullandığım veritabanı:** ☐ `llm_ops`  ☑ `robot_fleet`

**PR bağlantısı:** `https://github.com/gizemturker/blp105-course/pull/6`

**Commit sayısı:** 5

---

## 1. Fan-out (Satır Çoğalması)

4. soruda `robots` ve `missions` tabloları birleştirildiğinde görevi olan robotların toplam batarya seviyesi gerçek değer olan **262'den 700'e** çıktı. Bire-çok ilişki nedeniyle birden fazla görevi olan robotların batarya değerleri görev sayıları kadar tekrar sayıldı: **Atlas-01** (82) 3 kez, **Kartal-01** (18) 3 kez, **Kartal-03** (91) 3 kez, **Mars-01** (47) 2 kez ve **Mars-02** (9) 2 kez toplanırken, tek görevi olan **Atlas-02** (15) 1 kez sayıldı. Gerçek bir lojistik veya finans raporunda bu fan-out hatası; mevcut enerji kapasitesinin, toplam stoğun veya bütçe/maliyet toplamlarının olduğundan katbekat fazla görünmesine yol açarak yönetimin yanlış kaynak ve kapasite planlaması yapmasına neden olur.

---

## 2. En Zor Karar

Kendi projemdeki (Sağlık Öneri Motoru & LLM Maliyet Takibi) ERD tasarımında en çok düşündüğüm karar, vize şemasında `oneriler` tablosunda bulunan `talep_id` yabancı anahtarını silip silmemek ve `hastalar` tablosundaki `kronik_hastalik` sütununu ayrı bir tabloya bölüp bölmemek oldu. Seçenek olarak vizedeki gibi tüm bilgileri tek tabloda tutup sorguları kısa yazmak ile 1NF ve 3NF kurallarını uygulayarak `hasta_kronik_hastaliklar` tablosunu ayırmak ve `oneriler` tablosunu yalnızca `cagri_id` üzerinden bağlamak arasında kaldım. Veri tekrarını ve güncelleme tutarsızlıklarını önlemek için normalizasyon kurallarına uymayı seçtim; çünkü bir hastanın birden fazla kronik hastalığını tek metin hücresinde tutmak sorgulamayı bozuyor, `oneriler` tablosunda hem `talep_id` hem `cagri_id` tutmak ise geçişli bağımlılık yaratarak aynı önerinin farklı taleplere bağlanma riskini doğuruyordu.

---

## 5. Yapay zeka kullanım beyanı

☐ Bu ödevde yapay zeka aracı **kullanmadım.**

☑ Kullandım, aşağıda belirttim:

| Soru no | Araç | Ne sordum (özet) | Cevabı nasıl doğruladım |
|---|---|---|---|
| Bölüm 1 (1–5) | Gemini | `robot_fleet.sql` şemasına göre `INNER JOIN`, `LEFT JOIN`, fan-out ve `COUNT` farkı sorgularının kurgusunu sordum. | `robot_fleet.sql` içindeki 10 robot ve 14 görev kaydını tek tek sayarak (9 eşleşen, 4 görevsiz, 262 vs 700 batarya) sonuçları doğruladım. |
| Bölüm 2 (ERD & 1NF–3NF) | Gemini | Vize şemamdaki `kronik_hastalik` ve `oneriler.talep_id` sütunlarının normalizasyon kurallarına göre nasıl ayrılacağını ve Mermaid ERD sözdizimini sordum. | Kendi `DATA_CARD.md` ve `schema_and_queries.sql` dosyalarımdaki sütun isimleriyle karşılaştırıp tüm PK/FK bağlarını kontrol ettim. |

---

## 6. Öz değerlendirme

| Ölçüt | 4 Tam | 3 İyi | 2 Gelişmeli | 1 Yetersiz |
|---|---|---|---|---|
| A, Doğruluk | ☑ | ☐ | ☐ | ☐ |
| B, SQL kalitesi | ☑ | ☐ | ☐ | ☐ |
| C, Yorum ve analiz | ☑ | ☐ | ☐ | ☐ |
| D, Git ve PR disiplini | ☑ | ☐ | ☐ | ☐ |
| E, Dürüstlük ve beyan | ☑ | ☐ | ☐ | ☐ |

Bir dahaki ödevde daha iyi yapacağım şey: Sorguları yazmadan önce veritabanı dosyasındaki NULL değerleri ve bire-çok ilişkileri daha dikkatli inceleyip fan-out ihtimalini baştan kontrol edeceğim.

---

## 7. Bana sorun

Özellikle 3 veya daha fazla tablonun birleştirildiği karmaşık sorgularda fan-out (satır çoğalması) hatasına düşmemek için `DISTINCT` kullanmak yerine alt sorgu (`IN` / `EXISTS`) veya `CTE` (`WITH`) kullanmanın performans ve okunabilirlik açısından farkını derste kısaca tekrar görebilir miyiz?

---

**İmza:** ________________________

---

*Doğruluk beyanı: Bu çalışmayı kendim yaptım. Kullandığım tüm yardımcı kaynakları ve yapay zeka araçlarını yukarıda beyan ettim.*
