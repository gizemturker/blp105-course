# Ödev 2: JOIN, ERD ve Normalizasyon

**Teslim:** Cuma 27 Kasım 2026, saat 09:00'dan önce. GitHub'da PR (branch `odev-02`, reviewer: gizemturker). Kâğıt rapor aynı gün derste elden.

## Senaryo

Bir lojistik deposunda robot filosu çalışıyor. Filo sorumlusu pazartesi toplantısına hazırlanıyor ve senden şunları istiyor: hangi robotun hangi operatöre bağlı olduğu, hiç görev almamış robotlar, bataryalardaki toplam şarj ve robot başına görev sayısı. Veriler `robot_fleet` veritabanında. Sorguları yaz, her sonucun ne anlama geldiğini bir cümleyle açıkla.

Sonra sıra kendi projene geliyor: vizede sunduğun ERD'yi bu derste öğrendiklerinle düzeltip kesinleştireceksin.

## Hazırlık

```bash
psql -d robot_fleet -f data/robot_fleet.sql
```

Tablolar: `operators`, `robots`, `missions`. `\d robots` ile sütunlara bak.

## Bölüm 1: Filo soruları (50 puan)

Ders reposundaki şablonu (`weeks/week-07/sorgular-sablonu.sql`) kendi reponda `odevler/odev-02/sorgular.sql` olarak kopyala. Her sorgunun altına sonucu açıklayan **tek cümlelik** yorum yaz (kaç satır döndü, neden). Çıktını görmeden yorum yazma.

| No | İstek | Puan |
|---|---|---|
| 1 | Her robotun adı, operatör adı ve operatörün telefonu (`INNER JOIN`). | 8 |
| 2 | Aynı liste, ama **bütün robotlar** görünsün (`LEFT JOIN`). 1. sorguyla satır sayısını karşılaştır, kim kayboldu? | 8 |
| 3 | Hiç görev almamış robotların adı ve modeli. | 10 |
| 4 | Görevi olan robotların toplam batarya seviyesi. Önce `robots` ile `missions`'ı birleştirip `sum()` al, sonra aynı toplamı JOIN kullanmadan doğru hesapla. İki sonucu karşılaştır, farkı açıkla. | 12 |
| 5 | Robot başına görev sayısı, hiç görevi olmayanlar 0 görünsün. Aynı sorguda `count(*)` ve `count(m.id)` yan yana olsun. Hangi robotlarda ikisi farklı? | 12 |

İpuçları: sütun adlarını tablo takma adıyla yaz (`r.name`, `m.id`). Eşleşmeyen kayıt arıyorsan `LEFT JOIN` ve sağ tablonun anahtarında `IS NULL`.

## Bölüm 2: Kendi projen (30 puan)

Kuradan çıkan projenin `SCENARIO.md` dosyasındaki veri hikâyesi ve vizedeki ERD'n başlangıç noktan. Aşağıdakileri reponun `README.md` dosyasında "Veri Modeli" başlığı altında topla.

### 2.1 Güncel ERD (12 puan)

Mermaid `erDiagram` ile çiz. En az 3 tablo; her tabloda sütun adı, veri tipi, `PK` ve `FK` işaretleri; her ilişkinin kardinalitesi (1-1, 1-N, M-N; M-N varsa ara tablo) ve katılımı (zorunlu mu, isteğe bağlı mı). ERD'nin altına ilişki başına **bir cümle** yaz: "Bir X, en az/en çok ... Y'ye sahiptir; bir Y, ... X'e aittir."

Çizgi uçları: `||` tam bir (zorunlu), `o|` sıfır veya bir, `}o` sıfır veya çok, `}|` bir veya çok.

### 2.2 Normalizasyon notu (10 puan)

En fazla yarım sayfa, tablo biçiminde: tablo, neden ayrıldı veya neden ayrılmadı (hangi sütun hangisini belirliyor?), hangi form (1NF / 2NF / 3NF). Üç formdan her biri için kendi tablolarından somut bir örnek ver.

### 2.3 İki JOIN sorusu (8 puan)

Şema henüz kurulmadı, sorguları çalıştırman gerekmiyor. Her soru için: Türkçe soru cümlesi, hangi tablo ve sütunlar üzerinden birleşeceği (`a.sutun = b.sutun`), hangi JOIN türü ve neden. Biri eşleşmeyen kayıtları bulan (`LEFT JOIN`) bir soru olsun.

Bu bölüm final projenin ilk adımıdır: buradaki ERD, dönemin devamında kuracağın şemanın temeli olacak.

## Bölüm 3: Kâğıt rapor (20 puan)

`templates/odev-rapor-sablonu.md` şablonunu kullan. Üst bilgileri ve YZ beyanını şablondaki gibi doldur. Gövdede şablonun 1-4. bölümleri yerine yalnızca şu iki soruyu yanıtla. Toplam bir sayfa:

1. **Fan-out:** 4. soruda toplam kaçtan kaça çıktı? Hangi robot kaç kez sayıldı? Gerçek bir raporda bu hata ne yanlışa yol açar?
2. **En zor karar:** Kendi ERD'nde en çok düşündüğün tek karar neydi (bir tabloyu bölmek, bir ilişkinin kardinalitesi, anahtar seçimi)? Hangi seçenekler arasında kaldın, neden birini seçtin?

## Teslim

| Ne | Nerede |
|---|---|
| Sorgular ve yorumlar | `odevler/odev-02/sorgular.sql` |
| ERD, normalizasyon notu, JOIN soruları | `README.md` ("Veri Modeli") |
| Rapor (dijital) | `odevler/odev-02/rapor.md` |
| PR | Branch `odev-02`, reviewer: gizemturker, en az 3 commit |
| Rapor (kâğıt) | Cuma 27 Kasım derste, elden |

Kopya ve YZ kuralları ODEVLER.md'deki gibidir.

## Notlandırma

| Bölüm | Puan |
|---|---|
| 1. Filo soruları (5 sorgu ve yorumları) | 50 |
| 2. Kendi projen (ERD, normalizasyon, JOIN soruları) | 30 |
| 3. Kâğıt rapor | 20 |
| **Toplam** | **100** |

Kâğıt rapor derste teslim edilmezse toplamdan %25 kesilir. Geç teslimde 24 saate kadar %20, 24-72 saat arası %40 kesilir; 72 saatten sonra ödev kabul edilmez.
