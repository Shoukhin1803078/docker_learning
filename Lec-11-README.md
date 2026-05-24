# Lec-11: **Environment Variables in Docker – Config Manage করার Best Practice**

ডাটাবেস password, API key, debug mode — এগুলো কোডে hard-code করা উচিত নয়। **Environment variables** দিয়ে আমরা একই image বিভিন্ন পরিবেশে (dev, staging, prod) আলাদা config দিয়ে চালাই।

---

## **কেন Environment Variable?**

- **Security:** সিক্রেট কোডে নয়, runtime-এ inject
- **Flexibility:** dev-এ `DEBUG=true`, prod-এ `false`
- **12-Factor App:** config environment-এ রাখার standard practice

---

## **ধাপ ১: `docker run -e` দিয়ে একক variable**

```
docker run -e APP_NAME=MyApp -e DEBUG=true nginx:alpine env | grep APP
```

একাধিক:

```
docker run -e DB_HOST=localhost -e DB_PORT=5432 ubuntu env
```

**হোস্টের variable pass করা:**

```
export MY_SECRET=abc123
docker run -e MY_SECRET ubuntu env
```

শুধু নাম pass (মান হোস্ট থেকে):

```
docker run -e MY_SECRET ubuntu env
```

---

## **ধাপ ২: `--env-file` ব্যবহার**

প্রজেক্টে `.env` ফাইল (Git-এ commit করবেন না sensitive data সহ):

```
# .env.example (টিমের জন্য টেমপ্লেট)
APP_NAME=docker_learning
DEBUG=true
DATABASE_URL=postgresql://user:pass@db:5432/mydb
```

চালানো:

```
docker run --env-file .env ubuntu env
```

**`.gitignore`-এ যোগ করুন:**

```
.env
```

---

## **ধাপ ৩: Dockerfile-এ `ENV`**

```dockerfile
FROM python:3.11-slim
WORKDIR /app
ENV PYTHONUNBUFFERED=1
ENV APP_ENV=production
COPY . .
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

`ENV` image-এর default; `docker run -e` দিয়ে override করা যায়।

**Python/FastAPI-এ পড়া:**

```python
import os
debug = os.getenv("DEBUG", "false").lower() == "true"
```

---

## **ধাপ ৪: Docker Compose-এ env**

**সরাসরি YAML:**

```yaml
services:
  api:
    build: .
    environment:
      - DEBUG=true
      - DATABASE_URL=postgresql://app:secret@db:5432/mydb
```

**`.env` ফাইল (compose.yml এর পাশে):**

Compose automatically `.env` পড়ে variable substitute-এর জন্য:

```yaml
# docker-compose.yml
services:
  api:
    image: myapi
    environment:
      - DATABASE_URL=${DATABASE_URL}
```

```
# .env
DATABASE_URL=postgresql://localhost:5432/dev
```

**`env_file` key:**

```yaml
services:
  api:
    env_file:
      - .env
      - .env.local
```

---

## **Best Practices**

| করবেন                         | করবেন না                          |
|-------------------------------|-------------------------------------|
| `.env.example` টিমে শেয়ার    | `.env`-এ real password commit     |
| Production-এ secrets manager  | Dockerfile-এ `ENV PASSWORD=xxx`   |
| `docker secret` (Swarm)       | Public Hub image-এ secret baked   |

**Docker Compose secrets (Swarm mode):** production multi-host-এ; সিম্পল dev-এ `env_file` যথেষ্ট অনেক সময়।

---

## **ধাপ ৫: FastAPI প্রজেক্টে প্রয়োগ**

`docker_learning` চালানোর উদাহরণ:

```
docker run -p 8000:8000 -e APP_ENV=development docker_learning:latest
```

Compose উদাহরণ:

```yaml
services:
  backend:
    build: .
    ports:
      - "8000:8000"
    environment:
      APP_ENV: development
    env_file:
      - .env
```

---

## **Homework**

1. `.env.example` তৈরি করুন (`APP_NAME`, `DEBUG`)।
2. `docker run --env-file .env` দিয়ে Ubuntu container-এ `env` দেখান।
3. Dockerfile-এ `ENV APP_VERSION=1.0` যোগ করে build করুন; run-এ `-e APP_VERSION=2.0` দিয়ে override দেখান।
4. `app/main.py`-এ `os.getenv("APP_NAME")` পড়ে response-এ দেখান (ঐচ্ছিক ছোট কোড)।
5. `.gitignore`-এ `.env` আছে কিনা নিশ্চিত করুন।

---

**পরবর্তী:** Lec-12 — Logs ও Debugging।
