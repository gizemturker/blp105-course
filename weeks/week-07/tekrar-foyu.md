# Tekrar Föyü: Hafta 4–7

Veritabanı Yönetim Sistemleri (PostgreSQL), Güz 2026
Doğuş Üniversitesi MYO, BLP 1005 Yapay Zeka Operatörlüğü

Bu föy son dört haftanın tekrarıdır: SELECT ve WHERE (Hafta 4), gruplama ve NULL (Hafta 5), JOIN (Hafta 6), E-R modeli ve normalizasyon (Hafta 7). Toplam 27 soru var. Soruların çoğunda bir tuzak saklı. Tuzağı bulan öğrenci konuyu öğrenmiş demektir.

---

## Nasıl çalışılır?

1. `llm_ops_tekrar` veritabanını kurun (Hafta 4-6'da çalıştığınız `llm_ops`'a benzer ama daha geniş bir veri seti; `llm_ops` ile karıştırmayın, ayrı bir veritabanıdır):

   ```
   createdb llm_ops_tekrar
   psql -d llm_ops_tekrar -f data/llm_ops_tekrar.sql
   ```

2. Cevaplarınızı tek bir dosyaya yazın: `tekrar/tekrar-04-07.sql` (kendi reponuzda). Her sorgunun üstüne soru numarasını yorum olarak ekleyin (`-- B3`).
3. Her sorgunun altına **bir yorum cümlesi** yazın: sonuç ne anlatıyor? Sayıyı söylemek yetmez, anlamını söyleyin.
4. Her sorunun yanında **beklenen satır sayısı** verildi. Sizin sorgunuz farklı sayıda satır döndürüyorsa, bir yerde tuzağa düştünüz demektir. Geri dönün.
5. D bölümünün cevapları SQL değil, metin ve diyagramdır. `tekrar/tekrar-d.md` dosyasına yazın.
6. Önerilen sıra: ilk C1, C2, C3, C5, C6, C8, D1, D2, D4; diğerleri ekstra.

**Seviye:** 1 = temel, 2 = dikkat ister, 3 = tuzaklı veya birden fazla kavramı birleştiriyor.

### Tablolar (hatırlatma)

| Tablo | Satır | Ne tutuyor |
| :---- | :---- | :---- |
| `llm_calls` | 12 | Her LLM çağrısı: model, kullanıcı, görev türü, token, gecikme, maliyet, durum, zaman |
| `model_catalog` | 7 | Modellerin sağlayıcısı, 1000 token fiyatı, bağlam penceresi |
| `llm_evaluations` | 26 | Çağrı çıktılarının ölçüt bazında 1–5 arası puanı |

`status` sütununun üç değeri var: `ok`, `error`, `rate_limited`.

---

## Bölüm A: SELECT ve WHERE (Hafta 4)

**A1 · Seviye 1**
Başarılı (`status = 'ok'`) olup gecikmesi 1000 ms'yi aşan çağrıları listeleyin. `id`, `model_name`, `latency_ms` sütunları gelsin; en yavaş çağrı en üstte olsun.
Beklenen satır sayısı: 5

**A2 · Seviye 2**
Model adı `claude` ile başlayan ve görev türü `kod` ya da `çeviri` olan çağrıları listeleyin.
Beklenen satır sayısı: 3
Ardından aynı sorguyu **parantez kullanmadan** yazın ve çalıştırın. Kaç satır geldi? Fazladan gelen satır hangisi ve neden geldi?

**A3 · Seviye 2**
10 Mart 2025 ile 20 Mart 2025 arasında (iki gün de dahil) yapılan çağrıları listeleyin.
Beklenen satır sayısı: 5
İpucu: Önce `BETWEEN '2025-03-10' AND '2025-03-20'` ile deneyin ve satır sayısına bakın.

**A4 · Seviye 3**
Maliyeti en yüksek **üçüncü** çağrıyı bulun (`id`, `model_name`, `cost_usd`).
Beklenen satır sayısı: 1
İpucu: Önce `ORDER BY cost_usd DESC LIMIT 3` çıktısına bakın. En üstteki satırda ne görüyorsunuz?

**A5 · Seviye 1**
İstem önizlemesinde (`prompt_preview`) büyük/küçük harf fark etmeksizin "özet" ya da "çevir" geçen çağrıları listeleyin.
Beklenen satır sayısı: 4

**A6 · Seviye 2**
Veritabanındaki farklı görev türlerini (`task_type`) **Türk alfabesine göre** sıralı listeleyin.
Beklenen satır sayısı: 4
Önce collation kullanmadan sıralayın ve iki listeyi karşılaştırın. `ç` ve `ö` ile başlayan kelimeler nereye gitti?

---

## Bölüm B: Fonksiyonlar, gruplama ve NULL (Hafta 5)

**B1 · Seviye 1**
Tek sorguda dört sayı üretin: toplam çağrı sayısı, kullanıcısı belli olan çağrı sayısı, maliyeti belli olan çağrı sayısı, farklı kullanıcı sayısı.
Beklenen satır sayısı: 1
Dört sayının neden farklı olduğunu açıklayın.

**B2 · Seviye 3**
"Bir çağrının ortalama maliyeti nedir?" sorusunu üç ayrı yolla hesaplayın:
- `avg(cost_usd)`
- `sum(cost_usd) / count(*)`
- `avg(COALESCE(cost_usd, 0))`

Beklenen satır sayısı: 1
Üç sonuç aynı mı? Hangisi hangi soruya cevap veriyor? Bir yöneticiye hangisini raporlarsınız, neden?

**B3 · Seviye 2**
`user_02` dışındaki kullanıcıların çağrılarını listeleyin.
Beklenen satır sayısı: 9
Önce `WHERE user_name <> 'user_02'` deneyin. Kaç satır geldi? Eksik satırlar hangileri? Ayrıca `WHERE user_name = NULL` sorgusunun neden 0 satır döndürdüğünü açıklayın.

**B4 · Seviye 2**
Her model için çağrı sayısını ve ortalama gecikmeyi (tam sayıya yuvarlanmış) bulun. Yalnızca en az 2 kez çağrılmış modeller gelsin; en yavaş model en üstte olsun.
Beklenen satır sayısı: 5

**B5 · Seviye 2**
Yalnızca başarılı çağrıları dikkate alarak her kullanıcının toplam token kullanımını (`prompt_tokens + completion_tokens`) hesaplayın. Toplamı 3000'i aşan kullanıcılar gelsin.
Beklenen satır sayısı: 4
Bu sorguda iki filtre var. Hangisi `WHERE`'e, hangisi `HAVING`'e yazılır? Yerlerini değiştirirseniz ne olur?

**B6 · Seviye 2**
Çağrıları gecikmeye göre üç sınıfa ayırın: 1000 ms altı "hızlı", 1000–4000 ms arası (4000 dahil) "orta", 4000 ms üstü "yavaş". Her sınıfta kaç çağrı olduğunu ve ortalama gecikmeyi gösterin.
Beklenen satır sayısı: 3

**B7 · Seviye 3**
Her model için başarısızlık oranını yüzde olarak bulun (`status` değeri `ok` olmayan çağrılar başarısızdır). Sonucu bir ondalık basamağa yuvarlayın, en sorunlu model en üstte olsun.
Beklenen satır sayısı: 6
Dikkat: `count(...) / count(*)` yazarsanız neden hep 0 çıkıyor?

**B8 · Seviye 2**
Haftalık çağrı sayısını ve haftalık toplam maliyeti listeleyin (`date_trunc` kullanın).
Beklenen satır sayısı: 5
En pahalı hafta hangisi? Haftalar hangi günden başlıyor?

**B9 · Seviye 3**
Her çağrı için "1000 çıktı token başına maliyet" hesaplayın: `cost_usd * 1000 / completion_tokens`.
Beklenen satır sayısı: 12
Önce olduğu gibi çalıştırın. Hata mesajını okuyun, hangi satırlar soruna yol açıyor bulun ve `NULLIF` ile düzeltin. Değeri hesaplanamayan üç satırın her biri için nedenini yazın.

---

## Bölüm C: JOIN (Hafta 6)

**C1 · Seviye 2**
`llm_calls` ile `model_catalog` tablolarını `INNER JOIN` ile birleştirip sağlayıcı (`provider`) bazında çağrı sayısını ve toplam maliyeti bulun.
Beklenen satır sayısı: 3
Çağrı sayılarını toplayın. 12 ediyor mu? Etmiyorsa kaybolan çağrıyı `LEFT JOIN` ile geri getirin ve "(katalogda yok)" etiketiyle gösterin.

**C2 · Seviye 1**
Katalogda kaydı olmayan bir modeli çağıran çağrıları bulun.
Beklenen satır sayısı: 1
Bu durum gerçek bir şirkette hangi riskleri doğurur? İki risk yazın.

**C3 · Seviye 2**
Katalogda olup hiç çağrılmamış modelleri bulun.
Beklenen satır sayısı: 2
Ardından her katalog modeli için çağrı sayısını `LEFT JOIN` ve `GROUP BY` ile hesaplayın. `count(*)` ile `count(c.id)` aynı sonucu veriyor mu? Hiç çağrılmamış modeller için hangisi doğru?

**C4 · Seviye 2**
Üç tabloyu birleştirin: sağlayıcı bazında ortalama **doğruluk** (`criterion = 'dogruluk'`) puanını bulun.
Beklenen satır sayısı: 3

**C5 · Seviye 3**
**Güvenlik** değerlendirmesi yapılmamış çağrıları listeleyin.
Beklenen satır sayısı: 6
Aşağıdaki sorgu neden 0 satır döndürüyor? Açıklayın ve düzeltin.

```sql
SELECT c.id, c.model_name
FROM llm_calls c
LEFT JOIN llm_evaluations e ON e.call_id = c.id
WHERE e.criterion = 'guvenlik'
  AND e.id IS NULL;
```

**C6 · Seviye 3 · Fan-out tuzağı**
Bir analist model bazında hem toplam maliyeti hem ortalama puanı tek sorguda istedi ve şunu yazdı:

```sql
SELECT c.model_name,
       sum(c.cost_usd)        AS toplam_maliyet,
       round(avg(e.score), 2) AS ort_puan
FROM llm_calls c
JOIN llm_evaluations e ON e.call_id = c.id
GROUP BY c.model_name;
```

a) Bu sorguyu çalıştırın. `claude-sonnet` için toplam maliyet kaç çıkıyor?
b) Toplam maliyeti yalnızca `llm_calls` üzerinden ayrıca hesaplayın. Fark neden oluştu?
c) Toplam maliyeti ve ortalama puanı iki ayrı sorguyla hesaplayın (her biri doğru sonucu versin) ve farkı açıklayın. Hafta 10'da CTE ile ikisini tek sorguda birleştireceğiz.
Beklenen satır sayısı: 6

**C7 · Seviye 3 · Fatura denetimi**
Her çağrının maliyetini katalogdaki fiyatlardan yeniden hesaplayın:

`hesaplanan = prompt_tokens / 1000 * price_per_1k_input_usd + completion_tokens / 1000 * price_per_1k_output_usd`

Kayıtlı maliyetle hesaplanan maliyet arasındaki fark 0.00001 doları aşan ya da kayıtlı maliyeti boş olan çağrıları listeleyin.
Beklenen satır sayısı: 3
Dikkat: `prompt_tokens / 1000` tam sayı bölmesidir. Ne olur?

**C8 · Seviye 2 · Self join**
Aynı sağlayıcıya ait model çiftlerini listeleyin. Her çift yalnızca bir kez görünsün (`gpt-4o / gpt-4o-mini` gelirse `gpt-4o-mini / gpt-4o` gelmesin).
Beklenen satır sayısı: 3

---

## Bölüm D: E-R modeli ve normalizasyon (Hafta 7)

**D1 · Seviye 2 · ERD**
`llm_ops_tekrar` veritabanının ERD'sini Mermaid `erDiagram` ile çizin. Her ilişki için kardinaliteyi ve katılımı (zorunlu/isteğe bağlı) gösterin.
Sonra şu üç soruyu cevaplayın:
a) `llm_calls.model_name` bir yabancı anahtar mı? Veriden kanıt gösterin.
b) Bu modelde eksik olan bir varlık var. Hangisi? Neden ayrı bir tablo olmalı?
c) Veride her çağrının en az bir değerlendirmesi var. Bu, ilişkinin "zorunlu" olduğu anlamına gelir mi?

**D2 · Seviye 3 · Normalizasyon**
Raporlama ekibi tüm bilgiyi tek bir Excel tablosunda tutuyor:

| call_id | called_at | user_name | user_team | model_name | provider | price_in | price_out | scores |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| 2 | 2025-03-03 | user_02 | destek | gpt-4o | OpenAI | 0.0025 | 0.010 | dogruluk:4; faydalilik:5; guvenlik:5 |
| 4 | 2025-03-06 | user_03 | yazılım | claude-sonnet | Anthropic | 0.003 | 0.015 | dogruluk:5; faydalilik:5; guvenlik:4 |
| 5 | 2025-03-08 | user_02 | Destek | llama-3-70b | Meta | 0.00059 | 0.00079 | dogruluk:4; faydalilik:4 |
| 9 | 2025-03-18 | user_03 | yazilim | gpt-4o | OpenAI | 0.0025 | 0.010 | dogruluk:1 |

a) Tablo hangi normal formları ihlal ediyor? İlk olarak hangisini düzeltirsiniz?
b) Tablodaki üç veri anomalisini (ekleme, güncelleme, silme) bu tablodan birer somut örnekle gösterin. Tabloda zaten görünen bir anomali var; bulun.
c) Tüm fonksiyonel bağımlılıkları yazın.
d) Tabloyu adım adım 1NF, 2NF ve 3NF'ye taşıyın. Her adımda tabloları, birincil anahtarları ve gerekçeyi yazın.

**D3 · Seviye 2 · Anahtar seçimi**
`model_catalog` tablosunun birincil anahtarı `model_name` (doğal anahtar). Sağlayıcı yarın `claude-haiku` modelinin adını `claude-3-haiku` olarak değiştirirse ne olur? Doğal anahtar ile yapay anahtarın (`id`) birer avantajını ve dezavantajını yazın. Siz hangisini seçerdiniz?

**D4 · Seviye 2 · Senaryo**
Şirket bir değerlendirmeyi kimin yaptığını da tutmak istiyor. Bir değerlendirici çok sayıda çağrıyı değerlendirebilir, bir çağrıyı birden fazla değerlendirici puanlayabilir. Bu ihtiyacı ERD'nize ekleyin. Hangi tablolar değişir, hangi yeni tablo gelir?

---

## Teslim

Bu föy **notsuz, isteğe bağlı bir tekrardır**. Teslim yok, Pull Request yok; kendi çalışmanız için.

- İsterseniz cevaplarınızı kendi reponuzda `tekrar/` klasöründe tutun: `tekrar/tekrar-04-07.sql` (A, B, C bölümleri ve her sorgunun altında yorum cümlesi), `tekrar/tekrar-d.md` (D bölümü ve Mermaid ERD).
- Takıldığınız sorular için derse gelin.

Kendinizi kontrol edin: Her sorgunuzun satır sayısı beklenenle aynı mı? Aynı değilse sorun nerede?
