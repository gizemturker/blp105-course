# ====================
# Soru 1.1: İz sürme
# ====================


numbers = [4, 7, 2, 9, 5, 1, 8]
total = 0
result = []

for i in range(len(numbers)):
    if numbers[i] % 2 == 0:
        total = total + numbers[i]
    else:
        result.append(numbers[i])

print(total)
print(result)


# ========================
# Soru 1.2: En Uzun Seri
# ========================
# Sozde Kod:
# 1. readings ve threshold degiskenlerini belirle
# 2. current_streak = 0 ve max_streak = 0 sayaclarini olustur
# 3. readings listesindeki her bir val değeri için:
#     a. Eğer val > thrershold ise :
#         - current_streak degerini 1 arttır.
#         - Eğer current_streak > max_streak ise, max_streak = current_streak yap.
#     b. Değilse:
#         - current_streak sayacını sıfırla.
# 4. max_streak değerini ekrana yazdır.


readings = [18, 21, 23, 25, 24, 26, 27, 19, 20, 22, 23, 24, 25, 26]
threshold = 22 
current_streak =  0
max_streak = 0

for val in readings:
    if val > threshold:
        current_streak += 1
        if current_streak > max_streak:
            max_streak = current_streak
    else:
         current_streak = 0
print("En uzun kesintisiz seri:", max_streak)


# =========================
# Soru 1.3: Elle Gruplama
# =========================


records = [
    {"student": "Ece", "course": "VTYS"},
    {"student": "Ali", "course": "Yapay Zeka"},
    {"student": "Ece", "course": "Yapay Zeka"},
    {"student": "Can", "course": "VTYS"},
    {"student": "Ali", "course": "VTYS"},
    {"student": "Ece", "course": "Robotik"},
]

course_counts ={}

for rec in records:
    c = rec["course"]
    if c in course_counts:
        course_counts[c] += 1
    else:
        course_counts[c] = 1
print(course_counts)