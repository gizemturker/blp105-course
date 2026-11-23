# Ödevler ve Teslim Kuralları

Bu derste **2 notlu ödev** var. Hepsi aynı şekilde teslim edilir: GitHub'da kendi reponda bir **pull request (PR)** açarsın, ayrıca **bir sayfalık raporu derste elden teslim edersin.**

İki teslimin ikisi de zorunludur. PR'ı açıp raporu getirmezsen ödev eksik sayılır; raporu getirip PR açmazsan da öyle.

---

## 1. Teslim akışı özeti

```
Kendi repon  →  yeni branch  →  çalış, commit at  →  PR aç  →  beni reviewer ekle
                                                                      ↓
                                                        Derste bir sayfalık rapor
```

Neden PR? Çünkü sektörde kod böyle teslim edilir. Kimse doğrudan main'e yazmaz: branch açar, işi bitirir, PR açar, biri inceler, sonra merge edilir. Bu dersten çıkarken bu alışkanlığı kazanmanı istiyorum. Ödevlerin aynı zamanda bu akışın provası.

---

## 2. Bir kerelik kurulum

Bunu **bir kez** yaparsın, sonra her ödevde tekrar etmezsin. Kurulum notlandırılmıyor, sadece teslim yolu. Henüz yapmadıysan Ödev 1'den önce bitir.

### 2.1 Repoyu oluştur

1. [Proje şablonunu](https://github.com/gizemturker/project-template) aç, **Use this template** → **Create a new repository**.
2. Owner: kendi kullanıcı adın. Repository name: önce `db-project`, kuradan sonra projene uygun İngilizce bir adla değiştir (`smart-farm-drone-db` gibi).
3. **Public** seç. Portfolyo için herkese açık olması gerekir. Gizli tutmak istersen Private seç ve beni collaborator ekle.

### 2.2 Beni ekle

Settings → Collaborators → Add people → **gizemturker**

Bu adım olmadan PR'larını göremem ve ödevin teslim edilmemiş sayılır. Dönem başında bir kez yap, sonra unut.

### 2.3 main'i koru (önerilir, zorunlu değil)

Settings → Branches → Add branch protection rule → `main` → "Require a pull request before merging" işaretle.

Bunu açarsan main'e doğrudan yazamazsın, kendini PR açmaya zorlarsın. Gerçek projelerde bu ayar hep açıktır.

### 2.4 Klasör yapısı

Şablon bu yapıyla gelir, sen doldurursun:

```
senin-repon/
├── README.md              projenin tanıtımı
├── SCENARIO.md            senaryo kartın (Ödev 2'den itibaren)
├── data/
│   ├── raw/               indirdiğin ham veri (CSV)
│   └── seed/              kendi veritabanına yüklediğin veri
├── migrations/            şema dosyaların (Hafta 9'dan itibaren)
├── queries/               analiz sorguların
├── odevler/
│   ├── odev-01/           dönemin ilk ödevi, dört bölüm
│   │   ├── bolum1.py      algoritma ve izleme
│   │   ├── bolum2.md      veritabanı kavramları
│   │   ├── bolum3.sql     SELECT ve WHERE
│   │   ├── bolum4.sql     gruplama ve NULL
│   │   └── rapor.md       raporun (yazdırıp derse getireceğin)
│   ├── odev-02/
│   │   ├── sorgular.sql
│   │   └── rapor.md
│   └── ...
└── docs/
    └── erd.md             ERD'n (Hafta 7'den itibaren)
```

---

## 3. Her ödevde yapacakların

### Adım 1: Branch aç

```bash
git checkout main
git pull
git checkout -b odev-01
```

Branch adı her zaman `odev-NN` biçiminde: `odev-01`, `odev-02`.

### Adım 2: Çalış ve commit at

Dosyalarını `odevler/odev-01/` klasörüne koy.

```bash
git add odevler/odev-01/
git commit -m "Odev 1: SELECT ve WHERE cozumleri"
```

**En az üç commit** istiyorum. Tek bir dev commit yerine işi parçalara böl: "soru 1-5", "soru 6-10", "rapor". Son gece atılan tek commit yerine ilerleyen bir geçmiş görmek istiyorum.

İyi commit mesajı: `Odev 1: soru 6-10, BETWEEN ve IN`
Kötü commit mesajı: `update`, `son hali`, `asdf`

### Adım 3: Gönder ve PR aç

```bash
git push -u origin odev-01
```

GitHub'da repona git, çıkan **Compare & pull request** düğmesine bas.

| Alan | Ne yazacaksın |
|---|---|
| Başlık | `Ödev 1 / Ad Soyad / Öğrenci No` |
| base (hedef) | `main` |
| compare (kaynak) | `odev-01` |
| Açıklama | PR şablonunu doldur ([templates/pull_request_template.md](templates/pull_request_template.md)) |
| Reviewers | **gizemturker** |

Reviewer olarak beni eklemezsen PR'ın bana düşmez.

### Adım 4: PR'ı merge etme

**PR'ı kendin merge etme.** Ben inceleyip yorum bırakacağım. Düzeltme istersem aynı branch'e commit atarsın, PR kendiliğinden güncellenir. Onayladıktan sonra merge edebilirsin.

### Adım 5: Raporu derste teslim et

Raporunu (`odevler/odev-01/rapor.md`) **yazdır**, imzala ve **ödev tesliminin yapılacağı derste elden ver.**

Şablon: [templates/odev-rapor-sablonu.md](templates/odev-rapor-sablonu.md)

Bir sayfa, en fazla iki. Elle doldurulacak alanlar var, bilgisayarda doldurup yazdırman da olur.

> Neden hem dijital hem kâğıt? Kâğıt rapor resmi arşiv için gerekli. Ayrıca sorgularını yazdıktan sonra "bu sonuç ne anlama geliyor" sorusunu bir kez de kalemle cevaplamanı istiyorum: ekranda düşünmekle kâğıtta düşünmek aynı şey değil.

---

## 4. Ödev takvimi

| Ödev | Kapsam | Konu | PR son tarihi | Rapor teslimi |
|---|---|---|---|---|
| **Ödev 1** | Hafta 1-5 | Algoritma, VT kavramları, SELECT/WHERE, gruplama ve NULL | **23 Ekim 2026 Cuma, ders saatinden önce** | **23 Ekim 2026, derste** |
| **Ödev 2** | Hafta 6-7 | JOIN, ERD ve normalizasyon (vizenin devamı) | **27 Kasım 2026 Cuma, ders saatinden önce (09:00)** | **27 Kasım 2026, derste** |
| Final | Hafta 12 | Ana proje (repo), rapor ve repodan bir soru | 5-17 Aralık arasında ilan edilecek | Final günü |

**Ödev 1 dönemin ilk notlu ödevi ve beş haftayı birden kapsıyor.** İlk beş hafta algoritmik düşünme, veritabanı kavramları ve tek tablolu sorgularla geçti. Bu ödev dört bölümde hepsini topluyor. Repo kurulumu ödevin bir parçası değil, sadece teslim yolu; bölüm 2'de anlatılıyor.

**Kural:** son commit'in, teslim günündeki **dersin başlama saatinden önce** gönderilmiş olmalı. GitHub her commit'in saatini kaydediyor. Kâğıt raporu da aynı gün derse getirirsin.

**Dönemde iki notlu ödev var:** Ödev 1 (teslim edildi) ve Ödev 2. Gerisi final projesinin içinde.

---

## 5. Notlandırma

İki ödevin ortalaması dönem notunun **%20'sini** oluşturur (SYLLABUS.md'deki "Ödev" bileşeni).

Her ödev 100 puan üzerinden, ayrıntılı ölçütler: **[RUBRIK.md](RUBRIK.md)**

### Geç teslim

| Gecikme | Kesinti |
|---|---|
| 24 saate kadar | %20 |
| 24-72 saat | %40 |
| 72 saatten fazla | Kabul edilmez (0) |

Geçerli mazeretin varsa (sağlık raporu, resmi görev) **önceden** yaz. Sonradan gelen mazeret kesintiyi kaldırmaz.

---

## 6. Yapay zeka kullanımı

**Serbest, beyan zorunlu.**

ChatGPT, Claude, Copilot ya da başka bir araç kullanabilirsin. Ama her ödevin raporunda ve PR açıklamasında şunları yazacaksın:

- Hangi aracı kullandın
- Hangi soruda kullandın
- Ne sordun (prompt'un özeti)
- Çıkan cevabı nasıl doğruladın

Son madde en önemlisi. Bir YZ'nin ürettiği SQL'i çalıştırmadan teslim edersen, çalışmadığında sorumluluk senindir.

**Beyan etmemek, kullanmaktan daha ağır bir sorundur.** Beyan edilmemiş YZ kullanımı tespit edilirse o ödev sıfırlanır.

Şunu da unutma: Hafta 11'de bir LLM'e kendi şemanı verip ürettiği SQL'i test edeceğiz. YZ bu derste bir düşman değil, öğrenmen gereken bir araç. Ama araçla ne yaptığını bilmen gerekiyor.

## 7. Kopya

Ödevler bireyseldir. Arkadaşınla konuşabilir, birlikte düşünebilirsin; **kodu kopyalayamazsın.**

Ayırt etme kuralı basit: tahtaya kalkıp kendi çözümünü satır satır anlatabiliyor musun? Anlatamıyorsan o çözüm senin değildir.

Tespit edilen kopyada her iki tarafa da sıfır verilir.

## 8. Güvenlik

- Şifre, API anahtarı, token repoya **girmez**. Bir kez commit ettiysen o anahtar yanmıştır, iptal et ve yenisini al.
- Kişisel veri (ad, soyad, telefon, TC kimlik, e-posta) repoya girmez. Projende gerçek kişi verisi kullanman gerekiyorsa anonimleştir.
- Benim de dahil kimseyle şifre paylaşma. Senden hiçbir zaman şifre istemeyeceğim.

---

## 9. Sık sorulanlar

**PR'ı yanlışlıkla merge ettim, ne olacak?**
Sorun değil, yorumlarımı commit üzerine yazarım. Bir dahakine bekle.

**Branch açmayı unuttum, doğrudan main'e commit attım.**
Yeni bir branch aç, main'deki işi oraya taşı, main'i geri sar. Takılırsan lab saatinde çözeriz. İkinci kez olursa branch koruma kuralını açmanı isterim (bölüm 2.3).

**Sorgularımın hepsi doğru ama rapor yazmayı unuttum.**
Ödev eksiktir. Rapor, ödevin yarısı sayılabilecek kadar önemli; rubrikteki "Yorum ve analiz" ölçütü oradan geliyor.

**Dersi kaçırdım, raporu nasıl teslim edeceğim?**
Bir sonraki derste getir ve geç teslim kesintisini kabul et. Resmi mazeretin varsa önceden yaz.

**Ham verim çok büyük, repoya sığmıyor.**
100 MB üstü dosyayı GitHub kabul etmez. Verinin küçük bir örneğini (ilk 1000 satır) koy, tamamının indirme linkini `SCENARIO.md` içine yaz.

**Diğer programın sorularını da çözdüm, ekstra puan var mı?**
Bonus bölümleri notu yükseltmez ama rubrikte "Tam" seviyeye çıkmanı kolaylaştırır. Asıl faydası: iki veri alanını birden görmüş olursun.

---

## İlgili dosyalar

- [RUBRIK.md](RUBRIK.md): notlandırma ölçütleri
- [templates/odev-rapor-sablonu.md](templates/odev-rapor-sablonu.md): derste teslim edeceğin rapor
- [templates/pull_request_template.md](templates/pull_request_template.md): PR açıklaması
- [SETUP.md](SETUP.md): kurulum
- [SYLLABUS.md](SYLLABUS.md): değerlendirme ağırlıkları
