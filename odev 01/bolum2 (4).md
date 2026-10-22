# Ödev 1 — Bölüm 2: Veritabanı Kavramları

## Soru 1 — Excel yerine veritabanı kullanmak
Birden fazla çalışan aynı Excel dosyasını güncellediğinde farklı kopyalar oluşabilir ve hangi dosyanın güncel olduğu karışır; merkezi veritabanı tek bir ortak veri kaynağı sağlar. Öğrenci numarası ya da ürün kodu yanlış veya tekrarlı girilebilir; veritabanındaki `PRIMARY KEY`, `UNIQUE` ve uygun veri türü kısıtları bu hataları azaltır. Ayrıca dosya üzerinde kimin hangi veriyi değiştirebileceğini yönetmek zordur; DBMS kullanıcı yetkileriyle erişimi sınırlandırır ve işlemleri daha güvenli yönetir.

## Soru 2 — Birincil anahtar
`PRIMARY KEY`, bir tablodaki her satırı diğerlerinden benzersiz biçimde ayırır; boş olamaz ve tekrar edemez. Öğrenci numarası kurumda tekil ve değişmez olarak atanıyorsa iyi bir birincil anahtardır. Ad ve soyad ise farklı kişilerde aynı olabileceği veya zamanla değişebileceği için güvenilir değildir.

## Soru 3 — Veritabanı ile DBMS farkı
Veritabanı, birbiriyle ilişkili bilgilerin saklandığı düzenli veri bütünüdür; örneğin öğrenciler ve dersler tabloları. Veritabanı yönetim sistemi (DBMS), bu verileri oluşturan, sorgulayan, erişimi kontrol eden ve güvenli biçimde değiştiren yazılımdır. PostgreSQL bir ilişkisel **DBMS** örneğidir; `robot_fleet` veya `llm_ops` ise onun içinde oluşturulabilen veritabanlarıdır.

## Soru 4 — Eş zamanlı değişiklik
İki kişi aynı kaydı değiştirdiğinde işlemler kontrolsüz yürütülürse birinin güncellemesi diğerini ezebilir; DBMS, eş zamanlılık denetimi ve transaction mekanizmalarıyla işlemleri belirli kurallara göre yönetir (kullanılan izolasyon düzeyine göre davranış değişebilir).
