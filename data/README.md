# Örnek veritabanları

Derste iki örnek veritabanı kullanıyoruz. Haftalık alıştırmaları **kendi programının** veritabanında yaparsın, ama ikisi de herkese açıktır; diğerine de bakabilirsin.

| Veritabanı | Program | Ne anlatıyor |
|---|---|---|
| `robot_fleet` | Robotik ve Yapay Zeka | Bir depo robot filosu: robotlar, operatörler, görevler |
| `llm_ops` | Yapay Zeka Operatörlüğü | Bir LLM uygulamasının çağrı kayıtları: model kataloğu ve çağrı logları |

Veriler kurgusaldır. Model adları gerçektir ama fiyat ve gecikme değerleri uydurmadır, gerçek fiyat listesi olarak kullanma.

## Kurulum

Codespaces ya da kendi bilgisayarında, bu klasörün içinden:

```bash
createdb robot_fleet
createdb llm_ops
psql -d robot_fleet -f robot_fleet.sql
psql -d llm_ops     -f llm_ops.sql
```

Bağlanmak için:

```bash
psql -d robot_fleet
```

Her iki dosya da baştan `DROP TABLE` çalıştırır: istediğin zaman tekrar çalıştırıp veriyi ilk haline döndürebilirsin. Bir şeyi bozmaktan korkma, kurtarmak tek komut.

## Tablolar

### robot_fleet

```
operators (operator_name PK, phone, shift, hired_at)        10 satır
robots    (id PK, name, model, status, battery_level,       10 satır
           zone, operator_name)
missions  (id PK, robot_id → robots.id, mission_type,       14 satır
           status, started_at, duration_min)
```

- `status`: `active` görevde, `charging` şarjda, `maintenance` bakımda, `offline` kapalı
- `battery_level`: yüzde (0-100)
- `missions.status`: `completed`, `failed`, `in_progress`

### llm_ops

```
model_catalog (model_name PK, provider, price_per_1k_usd,    7 satır
               context_window)
llm_calls     (id PK, model_name, user_name, task_type,     12 satır
               prompt_tokens, completion_tokens,
               latency_ms, cost_usd, created_at)
```

- `latency_ms`: milisaniye (1 saniye = 1000 ms)
- `cost_usd`: dolar
- `task_type`: `summarize`, `code`, `classify`, `translate`, `chat`

## llm_ops_tekrar (isteğe bağlı tekrar föyü)

`llm_ops`'a benzer ama daha geniş, ayrı bir veri seti. [Hafta 4-7 tekrar föyü](../weeks/week-07/tekrar-foyu.md) için kullanılır; `llm_ops` ile karıştırma, ayrı bir veritabanına yüklenir.

```bash
createdb llm_ops_tekrar
psql -d llm_ops_tekrar -f llm_ops_tekrar.sql
```

```
model_catalog   (model_name PK, provider, price_per_1k_input_usd,     7 satır
                 price_per_1k_output_usd, context_window)
llm_calls       (id PK, model_name, user_name, task_type,           12 satır
                 prompt_preview, prompt_tokens, completion_tokens,
                 latency_ms, cost_usd, status, called_at)
llm_evaluations (id PK, call_id → llm_calls.id, criterion, score)   26 satır
```

- `status`: `ok`, `error`, `rate_limited`
- `criterion`: `dogruluk`, `faydalilik`, `guvenlik`; `score`: 1-5
- Dosya, bağlı veritabanı `llm_ops_tekrar` değilse hiçbir şey yapmadan durur (yanlışlıkla `llm_ops` tablolarının silinmesini önler). Tekrar çalıştırılabilir.

## Verideki kasıtlı boşluklar ve tuzaklar

Bu veri bilerek "kirli" bırakıldı, çünkü gerçek veri de kirli olur. Her boşluğun bir hikâyesi ve bir dersi var:

| Nerede | Ne var | Hangi hafta |
|---|---|---|
| `robots.zone`, `robots.operator_name` | Mars-03 henüz atanmadı, ikisi de NULL | Hafta 5 (NULL) |
| `robots.battery_level` | Kartal-04'ün sensörü bozuk, NULL | Hafta 5 (NULL, AVG tuzağı) |
| `llm_calls.cost_usd` | 11 numaralı çağrının faturası gelmedi, NULL | Hafta 5 (SUM ve NULL) |
| `llm_calls.user_name` | 12 numaralı çağrıyı anonim bir betik yaptı, NULL | Hafta 5 (COUNT farkı) |
| `missions` | 4, 7, 9, 10 numaralı robotların hiç görevi yok | Hafta 6 (LEFT JOIN) |
| `model_catalog` | `gemini-pro` katalogda yok ama çağrılmış | Hafta 6 (INNER vs LEFT JOIN) |
| `model_catalog` | `mistral-large` katalogda var ama hiç çağrılmamış | Hafta 6 (ters yön LEFT JOIN) |

## Tasarımla ilgili bir not

`operators` ve `model_catalog` tablolarında birincil anahtar olarak doğrudan ismin kendisi kullanıldı (natural key). Bu, JOIN öğrenirken işi kolaylaştırır. Hafta 7'de bunun neden riskli olduğunu tartışacağız: aynı isimde ikinci bir operatör işe alınırsa bu tasarım çöker. Gerçek projende yapay bir anahtar (`id`) kullanacaksın.

## Sorun giderme

| Belirti | Çözüm |
|---|---|
| `database "robot_fleet" does not exist` | `createdb robot_fleet` çalıştır |
| `relation "robots" does not exist` | Doğru veritabanına bağlı mısın? `\c robot_fleet` |
| Türkçe karakterler bozuk görünüyor | Terminalin UTF-8 olmalı; `psql -d robot_fleet` içinde `SHOW server_encoding;` |
| Veriyi bozdum | Seed dosyasını tekrar çalıştır, her şey eski haline döner |
