# Hafta 6 laboratuvar föyü: JOIN

Ad soyad: ______________________  Öğrenci no: ______________  Tarih: __________

Program (işaretle):  ☐ Yapay Zeka Operatörlüğü (`llm_ops`)  ☐ Robotik ve Yapay Zeka (`robot_fleet`)

Süre: 2 saat.

## Başlarken

Bu hafta birden fazla tablo var. Önce tabloları tanı:

```sql
\dt
\d robots
\d operators
\d missions
```

Her sorgunun altına bir yorum cümlesi yaz (geçen haftaki kural devam ediyor).

Bu föy teslim edilmez, kendi çalışman içindir. Benzer sorular Ödev 2'nin 1. bölümünde: [Ödev 2](../week-07/odev.md)

---

## Isınma (1-5)

**1.** İlk JOIN'in.
- **R:** Her robotun adı, bölgesi ve operatörünün telefonu.
- **Y:** Her çağrının id'si, modeli ve sağlayıcısı (`provider`).

Kaç satır döndü? ______ Tabloda kaç kayıt vardı? ______ Fark varsa neden?

______________________________________________________________

**2.** `ON` ile `WHERE` birlikte.
- **R:** Gece vardiyasındaki operatörlerin robotları.
- **Y:** Anthropic modellerine yapılan çağrılar.

**3.** Bir-çok ilişkisi.
- **R:** Bütün görevler, robot adıyla birlikte.
- **Y:** Bütün çağrılar, modelin 1000 token fiyatıyla (`price_per_1k_usd`) birlikte.

**R için:** Atlas-01 kaç kere göründü? ______ Neden?

______________________________________________________________

**4.** `LEFT JOIN`.
- **R:** **Bütün** robotlar, operatör telefonu varsa yanında.
- **Y:** **Bütün** çağrılar, sağlayıcı varsa yanında.

**5.** İki JOIN türünü karşılaştır. Aynı sorguyu `JOIN` ve `LEFT JOIN` ile çalıştır, satır sayılarını yaz.

INNER: ______ satır   LEFT: ______ satır   Fark: ______

---

## Orta (6-10)

**6.** Eşleşmeyeni bul.
- **R:** Operatörü atanmamış robotlar.
- **Y:** Katalogda olmayan modellere yapılan çağrılar.

İpucu: `LEFT JOIN` + `WHERE sag_tablo.anahtar IS NULL`

**Y için düşün:** Bu çağrıyı `INNER JOIN` ile yazılmış bir maliyet raporunda görür müydün?

______________________________________________________________

**7.** Aynı hile, ters yön.
- **R:** Hiç robotu olmayan operatörler.
- **Y:** Hiç çağrılmamış modeller.

**8.** Boş tarafı da göster.
- **R:** Hiç görev almamış robotlar.
- **Y:** Her modelin çağrı sayısı, hiç çağrılmayanlar dahil.

**9.** JOIN ve `GROUP BY` birlikte.
- **R:** Robot başına görev sayısı, hiç görevi olmayanlar dahil.
- **Y:** Sağlayıcı başına çağrı sayısı ve toplam maliyet.

**10.** Sayma tuzağı. Tek sorguda `count(*)` ve `count(sag_tablo.sutun)` sütunlarını yan yana koy.

Hangi satırlarda ikisi farklı çıktı? ______________________

Hangisi doğru ve neden?

______________________________________________________________

---

## Zor (11-15)

**11.** Fan-out. Bir toplamı JOIN'li ve JOIN'siz hesapla.
- **R:** Görevi olan robotların toplam bataryası.
- **Y:** Çağrılan modellerin liste fiyatları toplamı.

JOIN'li sonuç: ______  Doğru sonuç: ______

Neden şişti? Hangi kayıt kaç kere sayıldı?

______________________________________________________________

______________________________________________________________

**12.** Self join.
- **R:** Aynı vardiyada çalışan operatör çiftleri (sadece gece vardiyası).
- **Y:** Aynı sağlayıcıya ait model çiftleri.

Birleştirme koşuluna `a.anahtar < b.anahtar` eklemezsen ne olur? Dene ve yaz:

______________________________________________________________

**13.** Üç tablo (R) / iki kırılım (Y).
- **R:** Her operatör, robotu ve o robotun görev sayısı. Robotu olmayan operatör de listede olsun.
- **Y:** Kullanıcı ve sağlayıcı kırılımında çağrı sayısı. Katalogda olmayan model de ayrı satır olsun.

**R için:** `LEFT JOIN` zincirinde ikinciyi `INNER JOIN` yaparsan kim kaybolur?

______________________________________________________________

**14.** `COALESCE` ile etiketle.
- **R:** Bütün robotlar; operatörü, telefonu ve vardiyası boşsa okunur bir yazı görünsün.
- **Y:** Sağlayıcı dağılımı; katalogda olmayanlar "Katalogda yok" olarak görünsün.

**15.** Senaryo sorusu. *Beş adımı uygula: tablolar → birleşim → tür → sütunlar → koşul.*
- **R:** "Gece vardiyasındaki operatörlerin robotlarının tamamlanmış görevlerini, robot adı ve görev türüyle, en uzun süreden başlayarak listele."
- **Y:** "Her sağlayıcının toplam maliyetini ve ortalama gecikmesini listele; katalogda olmayan çağrılar da ayrı bir satır olarak görünsün."

---

## Bonus (isteğe bağlı)

**B1.** Diğer programın sorularını da çöz.

**B2.** [SQL Murder Mystery](https://mystery.knightlab.com/): bir cinayeti JOIN'lerle çöz. Çözüm sorgunu ekle.

**B3.** `CROSS JOIN` dene: `SELECT count(*) FROM robots CROSS JOIN missions;` Kaç satır döndü ve neden? ______

---

## Kontrol listesi

- [ ] 1-5 çalışıyor
- [ ] 6-10 çalışıyor
- [ ] 11-15 çalışıyor
- [ ] Her sorgunun altına yorum cümlemi yazdım
- [ ] Fan-out'u kendi gözümle gördüm
- [ ] `LEFT JOIN` sonrası `count(*)` kullanmadım

## YZ kullanım beyanı

| Soru | Araç | Ne sordun | Nasıl doğruladın |
|---|---|---|---|
| | | | |

## Takıldığın yer

Bu haftanın en şaşırtıcı sonucu neydi?

______________________________________________________________
