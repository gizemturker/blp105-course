# BÖLÜM 2 : VERİTABANI KAVRAMLARI
### 1. Excel vs Veritabanı
Excel dosyalarında eşzamanlı erişim çakışmaları veri tekrarları ve büyük verilerde yavaşlama sorunları yaşanır. Veritabanları ise birden fazla kullanıcının aynı anda güvenle çalışmasını sağlar ve veri bütünlüğü kurallarıyla hatalı kayıtları engeller. Ayrıca gelişmiş indeksleme sayesinde milyonlarca veriyi saniyeler içinde sorgular.

### 2. Birincil Anahtar (Primary Key)
Birincil anahtar veritabanındaki her bir satırın benzersiz ve tekil olmasını sağlayan kimlik bilgisidir. Öğrenci numarası her kişiye özel ve değişmez olduğu için ideal bir birincil anahtardır. Ad soyad ise aynı isimde birden fazla kişi olabileceği için birincil anahtar olarak kullanılamaz.

### 3. Veritabanı ve DBMS Farkı
Veritabanı verilerin tutulduğu depolama alanıdır. Veritabanı Yönetim Sistemi (DBMS) ise bu verileri yönetmeyi, sorgulamayı ve güvenliğini sağlamayı mümkün kılan yazılımdır. PostgreSQL ise bir veritabanı değil bu verileri yöneten bir veritabanı yönetim sistemidir (DBMS).

### 4. Eşzamanlı Erişim (Concurrency)
Aynı anda iki kişi aynı kaydı değiştirmeye kalkarsa veri çakışması ve tutarsızlığı oluşur. Veritabanı yönetim sistemleri bu durumu kilit mekanizmalarıyla sıraya koyarak güvenle çözer