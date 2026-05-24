# Lec-9: **Docker Compose শিখুন – Multiple Containers সহজে Run করুন**

একাধিক Container (API, Database, Cache) আলাদা আলাদা `docker run` দিয়ে চালানো কষ্টকর। **Docker Compose** একটি YAML ফাইল (`docker-compose.yml`) দিয়ে সব সার্ভিস একসাথে define এবং run করতে দেয়।

---

## **কেন Docker Compose?**

- **এক কমান্ডে সব:** `docker compose up`
- **Network automatic:** একই project-এর সার্ভিসগুলো default network-এ যুক্ত হয়, **service name** দিয়ে একে অপরকে call করা যায়
- **Volumes, env, ports** — সব YAML-এ version control করা যায়
- **Dev ও small production**-এর জন্য খুব জনপ্রিয়

---

## **প্রয়োজনীয় জিনিস**

Docker Desktop ইনস্টল থাকলে সাধারণত Compose ইতিমধ্যে আছে। চেক করুন:

```
docker compose version
```

---

## **ধাপ ১: প্রজেক্ট ফোল্ডার ও ফাইল**

```
mkdir compose-demo && cd compose-demo
```

**`docker-compose.yml` তৈরি করুন:**

```yaml
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    networks:
      - app-net

  api:
    image: python:3.11-slim
    command: python -c "print('Hello from API service')"
    networks:
      - app-net

networks:
  app-net:
    driver: bridge
```

---

## **ধাপ ২: Compose চালানো**

ফোল্ডারে থেকে:

```
docker compose up
```

**Background-এ চালাতে:**

```
docker compose up -d
```

**চলমান সার্ভিস দেখুন:**

```
docker compose ps
```

**লগ দেখুন:**

```
docker compose logs
docker compose logs web
```

---

## **ধাপ ৩: Service name দিয়ে যোগাযোগ**

Compose-এ প্রতিটি `services:` এর key (যেমন `web`, `api`) হলো **hostname**।

আপনার `docker_learning` FastAPI প্রজেক্টের জন্য উদাহরণ (পরে Lec-17-এ full stack):

```yaml
services:
  backend:
    build: .
    ports:
      - "8000:8000"

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: app
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: mydb
```

`backend` থেকে DB host: `db` (IP নয়, নাম)।

---

## **ধাপ ৪: `depends_on` — ক্রম নির্ধারণ**

Database আগে উঠুক, তারপর API:

```yaml
services:
  api:
    build: .
    depends_on:
      - db
  db:
    image: postgres:16-alpine
```

**মনে রাখুন:** `depends_on` শুধু **start order**; DB “ready” হওয়া guarantee নয়। Production-এ healthcheck ব্যবহার করা ভালো (Lec-17)।

---

## **ধাপ ৫: Build + Run একসাথে**

লোকাল Dockerfile থেকে image বানিয়ে চালানো:

```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
```

```
docker compose up --build
```

---

## **ধাপ ৬: বন্ধ ও পরিষ্কার**

```
docker compose down
```

Volumes সহ মুছতে:

```
docker compose down -v
```

Image-ও মুছতে:

```
docker compose down --rmi local
```

---

## **প্রধান Compose কমান্ড**

| কমান্ড                    | কাজ                              |
|--------------------------|----------------------------------|
| `docker compose up`      | সব সার্ভিস start                 |
| `docker compose up -d`   | detached (background)            |
| `docker compose stop`    | stop (remove নয়)                 |
| `docker compose start`   | আগে বন্ধ করা সার্ভিস আবার start  |
| `docker compose exec web sh` | চলমান সার্ভিসে shell        |
| `docker compose config`  | YAML validate / merged output    |

---

## **Homework**

1. `compose-demo` ফোল্ডারে `web` (nginx) + `redis` (redis:alpine) দুটি service যোগ করুন।
2. `web` সার্ভিসে `depends_on: - redis` দিন।
3. `docker compose up -d` চালিয়ে `docker compose ps` দেখুন।
4. `docker compose exec web sh` দিয়ে ভিতরে `ping redis` বা `wget -O- redis:6379` (redis HTTP নয় — শুধু network test) চেষ্টা করুন।
5. `docker compose down -v` দিয়ে clean up করুন।

---

**পরবর্তী:** Lec-10 — Docker Hub-এ image push/pull এবং private registry।
