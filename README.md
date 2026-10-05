# Database Management Systems · Fall 2026

**Doğuş University · Vocational School**
BLP 1005 · Yapay Zeka Operatörlüğü  |  BLP 105 · Robotik ve Yapay Zeka

> Bu dönem herkes kendi benzersiz yapay zekâ projesini sıfırdan bir veritabanına dönüştürecek ve dönem sonunda sektörden bir jürinin önünde sunacak. Projen GitHub'da portfolyon olacak.

**Bu repo nedir?** Dersin kaynak merkezi — amaç, haftalık konular, kaynak kitaplar, kurallar. Ödev ve lab föyleri burada değil; onlar her hafta ayrıca paylaşılır. Kendi projen için ayrı bir depo açacaksın (aşağıda).

📎 [Dersin amacı ve öğrenme kazanımları](docs/amac-ve-kazanimlar.md) · [Haftalık konular (tam liste)](docs/haftalik-konular.md) · [Kaynaklar (tam liste)](docs/kaynaklar.md)

---

## Nasıl başlarım? (Hafta 3)

1. GitHub hesabına giriş yap.
2. [Proje şablonunu](https://github.com/ORG_NAME/project-template) aç → yeşil **Use this template** → **Create a new repository**.
3. Adım adım rehber: [guides/create-your-repo.md](guides/create-your-repo.md)
4. Kayıt formunu doldur: **[FORM_LINK]**

## Ortam

| Araç | Ne için | Ne zaman |
|---|---|---|
| GitHub | Proje reposu, haftalık teslim | Hafta 3 |
| PostgreSQL | Veritabanı sunucusu | Hafta 4 |
| GitHub Codespaces | Tarayıcıda hazır çalışma ortamı | Hafta 4 |
| VS Code | Editör (SQL, Markdown, Python) | Hafta 4 |
| Python (isteğe bağlı) | Veri toplama ve yükleme | Plus / Pro seviyesi |

Kurulum rehberi: [guides/tools-setup.md](guides/tools-setup.md)

## Haftalık plan

| Hafta | Konu | Proje adımı |
|---|---|---|
| 3 | Veritabanı temel kavramları ve mimari | Kura, repo, senaryo kartı |
| 4 | Ortam kurulumu · SELECT, WHERE | Gerçek veri kaynağı, ham CSV |
| 5 | SQL fonksiyonları ve gruplama (GROUP BY) | İlk analiz sorguları |
| 6 | Varlık-İlişki (E-R) modeli | ERD taslağı |
| 7 | Normalizasyon (1NF, 2NF, 3NF) | Normalizasyon planı |
| 8 | **Ara sınav · mini proje sunumu** | Veri hikâyesi + ERD + plan |
| 9 | DDL · anahtarlar ve ilişkiler | Şema (CREATE TABLE) |
| 10 | DML · INSERT, UPDATE, DELETE · transaction | Veriyi şemaya taşıma |
| 11 | Çoklu tablo sorguları (JOIN) | JOIN sorguları |
| 12 | Alt sorgular ve görünümler · text-to-SQL | Görünümler ve YZ bileşeni |
| 13 | Veritabanı güvenliği | README, demo, portfolyo |
| 14 | **Final · jüri önünde sunumlar** | Ana proje teslimi |

## Değerlendirme

| Bileşen | Ağırlık | İçerik |
|---|---|---|
| Ara sınav | %30 | Hafta 8 mini proje ve sunum |
| Proje | %30 | Haftalık commit'ler ve lab föyleri |
| Yarıyıl sonu | %40 | Ana proje ve sektör jürisi önünde 5 dakikalık sunum |

## Kurallar

- **Her hafta commit.** Son gece atılan tek dev commit yerine haftalar boyunca ilerleyen bir geçmiş.
- **Tablo ve sütun adları İngilizce**, küçük harf ve `snake_case`: `sensor_readings`, `battery_level`.
- **YZ kullanmak serbest, beyan zorunlu.** Lab föyünün "YZ kullanım beyanı" bölümüne aracı ve prompt'u yaz.
- **Gerçek veri kuralı.** Her projede en az bir gerçek veri kaynağı olacak.
- **Gizli bilgi yok.** Şifre, API anahtarı ve kişisel veri repoya girmez.
- **LinkedIn paylaşımı gönüllüdür** ve notu etkilemez.

## Erişilebilirlik

- Her haftanın slaytları, haftanın klasöründe **metin sürümü** olarak da yayımlanır (`slides-text.md`). Ekran okuyucuyla okunabilir, tarayıcıda büyütülebilir.
- Görme, işitme ya da başka bir nedenle farklı bir düzenlemeye ihtiyacın varsa derse ya da ders saatine gelmeden hocana yazman yeterli: büyük punto föy, sınavda ek süre veya farklı sunum biçimi birlikte planlanır.
- GitHub, ekran okuyucularla kullanılabilir; klavye kısayolları için GitHub'da `?` tuşuna bas.

## Haftalar

- [Hafta 3 · Veritabanı temel kavramları ve mimari](weeks/week-03/README.md)

Diğer haftaların içerik özeti için: [docs/haftalik-konular.md](docs/haftalik-konular.md). Lab föyü ve o haftanın klasörü, hafta geldiğinde burada açılır.

## Kaynaklar

En sık kullanacakların:

- [PostgreSQL Documentation](https://www.postgresql.org/docs/current/)
- [SQLBolt](https://sqlbolt.com/) · interaktif SQL alıştırmaları
- [SQL Murder Mystery](https://mystery.knightlab.com/) · SQL ile dedektiflik
- [GitHub Docs](https://docs.github.com/)

Ana ders kitabı, konu başına dokümantasyon linkleri ve ileri okuma için tam liste: [docs/kaynaklar.md](docs/kaynaklar.md)
