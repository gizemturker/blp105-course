**SORU1.1-CEVAP**

--i--       --Sayı--       --Çift mi?--       --Total--       --Result--
i = 0          4	            Evet	              4  
i = 1          7	            Hayır	              4	              7
i = 2	         2	            Evet	              6	              7
i = 3	         9	            Hayır	              6	              7, 9|
i = 4	         5	            Hayır	              6	              7, 9, 5
i = 5	         1	            Hayır	              6	              7, 9, 5, 1
i = 6	         8	            Evet	              14	            7, 9, 5, 1

**SORU1.2-CEVAP**

Hocam listedeki sayıları for ile sırayla gezdim. 22'den büyük olunca sayacı 1 artırdım, küçük veya eşit olunca sıfırladım. En sonda da en büyük sayacı ekrana yazdırdım.

1-Sayıları ve 22 sınırını belirle
2-Sayacı ve en uzun seriyi sıfırdan başlat
3-Listeden her sayıyı sırayla al:
  **Eğer sayı 22'den büyükse:
    **Sayacı 1 artır
    **Eğer sayaç en uzun seriden büyükse, yeni en uzun seri bu sayaç olsun
  **Eğer sayı 22'den küçük veya eşitse:
    **Sayacı sıfırla
4-En uzun seriyi ekrana yazdır

**Python**

readings = \[18, 21, 23, 25, 24, 26, 27, 19, 20, 22, 23, 24, 25, 26]
threshold = 22

sayac = 0
en\_uzun = 0

for x in readings:
    if x > threshold:
        sayac = sayac + 1
        if sayac > en\_uzun:
            en\_uzun = sayac
    if x <= threshold:
        sayac = 0

print(en\_uzun)

**SORU1.3-CEVAP**

records = [
    {"student": "Ece", "course": "VTYS"},
    {"srtudent": "Ali", "course": "Yapay Zeka"},
    {"student": "Ece", "course": "Yapay Zeka"},
    {"student": "Can", "course": "VTYS"},
    {"student": "Ali", "course": "VTYS"},
    {"student": "Ece", "course": "Robotik"},
]

d = {}

for k in records:
    ders = k["course"]
    if ders not in d:
        d[ders] = 0
    if ders in d:
        d[ders] = d[ders] + 1

print(d)
