# BLP 105 - Robotik ve Yapay Zeka - Odev 1 - Bolum 1
# 1.1 Iz surme, 1.2 en uzun seri, 1.3 elle gruplama.

# Soru 1.1: Kodun elle izlenmesi (i, sayi, total, result).
# Beklenen izleme tablosu (cozum taslagi, elle tekrar kontrol edilebilir):
# i | numbers[i] | total | result
# --+------------+-------+----------------
# 0 |      4     |   4   | []
# 1 |      7     |   4   | [7]
# 2 |      2     |   6   | [7]
# 3 |      9     |   6   | [7, 9]
# 4 |      5     |   6   | [7, 9, 5]
# 5 |      1     |   6   | [7, 9, 5, 1]
# 6 |      8     |  14   | [7, 9, 5, 1]
# Beklenen: total = 14, result = [7, 9, 5, 1].
# Kontrol: kodun ciktisi beklenen sonucla ayni. Ciftler toplandi, tekler listeye eklendi.

print("=== Soru 1.1: Iz surme ===")
numbers = [4, 7, 2, 9, 5, 1, 8]
total = 0
result = []
print("i | deger | total | result")
for i in range(len(numbers)):
    if numbers[i] % 2 == 0:
        total = total + numbers[i]
    else:
        result.append(numbers[i])
    print(i, "|", numbers[i], "|", total, "|", result)
print("Toplam:", total)
print("Tek sayilar:", result)
assert total == 14 and result == [7, 9, 5, 1]

# Soru 1.2: En uzun kesintisiz esik ustu seri.
# Sozde kod:
# en_uzun = 0, mevcut = 0
# Her okuma icin:
#    okuma > esik ise mevcut = mevcut + 1
#    degilse mevcut = 0
#    mevcut > en_uzun ise en_uzun = mevcut
# Sonuc: en_uzun
# 22 esige ESIT degerler esik ustunde sayilmaz; bu nedenle seriyi keser.

print("\n=== Soru 1.2: En uzun seri ===")
readings = [18, 21, 23, 25, 24, 26, 27, 19, 20, 22, 23, 24, 25, 26]
threshold = 22
current_streak = 0
longest_streak = 0
for reading in readings:
    if reading > threshold:
        current_streak = current_streak + 1
    else:
        current_streak = 0
    if current_streak > longest_streak:
        longest_streak = current_streak
print("En uzun kesintisiz seri:", longest_streak)
assert longest_streak == 5

# Soru 1.3: Hazir gruplama araci olmadan ders basina kayit sayisi.
# GROUP BY course, COUNT(*) ile ayni mantik: anahtari bul, sayaci artir.
print("\n=== Soru 1.3: Elle gruplama ===")
records = [
    {"student": "Ece", "course": "VTYS"},
    {"student": "Ali", "course": "Yapay Zeka"},
    {"student": "Ece", "course": "Yapay Zeka"},
    {"student": "Can", "course": "VTYS"},
    {"student": "Ali", "course": "VTYS"},
    {"student": "Ece", "course": "Robotik"},
]
counts = {}
for record in records:
    course = record["course"]
    if course in counts:
        counts[course] = counts[course] + 1
    else:
        counts[course] = 1
print("Ders kayitlari:", counts)
assert counts == {"VTYS": 3, "Yapay Zeka": 2, "Robotik": 1}
# Her kayit bir ogrenci-ders ciftidir. Ayni ders icin ayni ogrenci iki kez
# kaydedilseydi bu cozum kayit sayardi; farkli ogrenciyi saymak icin DISTINCT gerekir.
