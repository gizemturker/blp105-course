# Dersin amacı ve kazanımları

## Neden bu ders?

Excel'de tuttuğun bir tablo bir yere kadar gider: birkaç kullanıcı, birkaç bin satır, tek bir dosya. Gerçek bir ürün — bir chatbot'un konuşma geçmişi, bir filonun sensör verisi, bir hastanenin kayıt sistemi — aynı anda birden fazla kişinin okuyup yazdığı, milyonlarca satırlık, hatasız kalması gereken bir veri katmanı ister. Bu ders, o katmanı kurmayı öğretir: PostgreSQL ile.

Dönem boyunca tek bir soruyu cevaplayacaksın: **"Bu veriye nasıl güvenilir bir şekilde soru sorarım?"** İlk haftalarda hazır bir veritabanını sorgulayarak başlıyoruz (SELECT, WHERE, JOIN, GROUP BY); tasarım ve modelleme (E-R diyagramı, normalizasyon, DDL) sorgu deneyiminden *sonra* geliyor — çünkü neyi modelleyeceğini, önce ne sorduğunu görmeden bilemezsin.

## Öğrenme kazanımları

Dönem sonunda:

1. **Bir ilişkisel veritabanını doğru sorgularsın.** SELECT, WHERE, JOIN (INNER/LEFT/self-join), GROUP BY, alt sorgular, CTE ve pencere fonksiyonlarıyla çok adımlı analiz sorguları yazarsın.
2. **Bir problem senaryosundan şema üretirsin.** Bir E-R modeli çıkarır, bunu normalize edilmiş (1NF–3NF) bir ilişkisel şemaya dönüştürür ve `CREATE TABLE` ile hayata geçirirsin.
3. **Veriyi güvenle değiştirirsin.** INSERT/UPDATE/DELETE, transaction (`BEGIN`/`COMMIT`/`ROLLBACK`) ve UPSERT kullanarak veri bütünlüğünü bozmadan veri taşırsın.
4. **Bir sorgunun neden yavaş olduğunu okur, hızlandırırsın.** `EXPLAIN ANALYZE` çıktısını yorumlar, doğru yere indeks koyarsın.
5. **En az yetki ilkesine göre erişim tasarlarsın.** Rol, `GRANT`/`REVOKE` ve Row-Level Security ile kim neyi görebilir sorusuna cevap verirsin; SQL injection riskini açıklarsın.
6. **Veritabanını bir YZ bileşenine bağlarsın.** `jsonb` ile yarı yapılandırılmış veri saklar, pgvector ile anlamsal arama kurar ya da bir LLM'in ürettiği SQL'i şemana karşı doğrularsın.
7. **Çalışmanı profesyonel bir şekilde sunarsın.** README, ERD, demo videosu ve 8 dakikalık canlı bir savunmayla kendi projeni anlatırsın — jüri sektörden.

Bu kazanımlar araçtan bağımsız yazıldı: PostgreSQL bu dönemki aracımız, ama öğrendiğin kavramlar (ilişkisel model, normalizasyon, transaction, indeks, en az yetki ilkesi) her VTYS'de — MySQL, SQL Server, hatta bir YZ ajansının arka planındaki veri katmanında — geçerli.

## Nasıl çalışıyoruz?

- **Önce sorgula, sonra tasarla.** Hafta 3-5 hazır veritabanı üzerinde sorgu; tasarım hafta 6'dan sonra.
- **Herkese ayrı senaryo.** Aynı kavramları farklı bir veri alanında (LLM operasyonları ya da robot filosu) uygularsın — kopya çekmek anlamsızlaşır, kendi projen olur.
- **Sınav değil, proje + savunma.** Ayrıntı için ana [README](../README.md#değerlendirme).
- **Gerçek veri, gerçek portfolyo.** Projen GitHub'da kalıcı, isteğe bağlı olarak LinkedIn'de paylaşılabilir bir iş örneği olur.
