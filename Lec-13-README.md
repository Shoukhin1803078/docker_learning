# Lec-13: **Dockerfile Best Practices – Lightweight, Efficient Image তৈরি করুন**

ভালো Dockerfile মানে: **ছোট image**, **দ্রুত build**, **নিরাপদ** এবং **maintainable**। এই গাইডে production-এর কাছাকাছি অভ্যাস শিখব।

---

## **১. ছোট Base Image ব্যবহার করুন**

| Base              | আনুমানিক সাইজ | কখন ব্যবহার      |
|-------------------|---------------|------------------|
| `python:3.11`     | বড়           | avoid if possible |
| `python:3.11-slim`| ছোট           | Python apps      |
| `alpine`          | খুব ছোট       | সাবধান — musl libc |
| `distroless`      | minimal       | advanced prod    |

```dockerfile
FROM python:3.11-slim
```

---

## **২. Layer Caching — `requirements.txt` আগে**

আপনার `docker_learning` Dockerfile ইতিমধ্যে সঠিক প্যাটার্ন follow করে:

```dockerfile
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
```

কোড বদলালে pip layer cache থেকে rebuild দ্রুত হয়।

---

## **৩. `.dockerignore` ব্যবহার করুন**

অপ্রয়োজনীয় ফাইল build context-এ পাঠাবেন না:

```
# .dockerignore
.git
.gitignore
__pycache__
*.pyc
.env
.venv
node_modules
README.md
Lec-*-README.md
.dockerignore
```

ফলাফল: ছোট context, দ্রুত build, accidentally secret কম যাওয়া।

---

## **৪. এক RUN-এ related কমান্ড (যেখানে যুক্তিসংগত)**

```dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
 && rm -rf /var/lib/apt/lists/*
```

প্রতিটি `RUN` = নতুন layer; cache clean একসাথে করলে image ছোট হয়।

---

## **৫. Multi-stage Build (উন্নত)**

Build tools final image-এ রাখবেন না:

```dockerfile
# Stage 1: build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: production
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
```

Final image-এ শুধু static files — Node/npm নেই।

---

## **৬. Root user এড়ানো (security)**

```dockerfile
RUN adduser --disabled-password --gecos "" appuser
USER appuser
```

অথবা official image-এর non-root user (যেখানে আছে)।

---

## **৭. `CMD` vs `ENTRYPOINT`**

- **CMD:** default command, override সহজ
- **ENTRYPOINT:** container সবসময় এই executable হিসেবে চলে

```dockerfile
ENTRYPOINT ["uvicorn"]
CMD ["app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

সাধারণ শিক্ষার জন্য শুধু `CMD` যথেষ্ট (আপনার প্রজেক্টে)।

---

## **৮. Secret image-এ bake করবেন না**

```dockerfile
# ❌ খারাপ
ENV DATABASE_PASSWORD=supersecret

# ✅ ভালো — runtime
# docker run -e DATABASE_PASSWORD=...
```

---

## **৯. `EXPOSE` — ডকুমেন্টেশন**

```dockerfile
EXPOSE 8000
```

Network খোলে না automatically — `-p` বা compose `ports` দরকার। তবে টিমের জন্য স্পষ্ট।

---

## **১০. Pin versions**

```dockerfile
FROM python:3.11.9-slim
```

`latest` tag surprise update এড়ায়।

---

## **উন্নত Dockerfile উদাহরণ (FastAPI)**

```dockerfile
FROM python:3.11-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

`--no-cache-dir` pip cache image-এ জমায় না।

---

## **Image সাইজ চেক**

```
docker images
docker history <image_name>
```

অফিসিয়াল guide: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

---

## **Homework**

1. `docker_learning`-এ `.dockerignore` যোগ করুন।
2. `docker build` আগে/পরে image size compare করুন।
3. `python:3.11` vs `python:3.11-slim` দিয়ে দুটি build — size পার্থক্য নোট করুন।
4. (ঐচ্ছিক) একটি multi-stage Node+nginx উদাহরণ বানান।
5. Dockerfile-এ `PYTHONUNBUFFERED=1` যোগ করে logs তৎক্ষণাৎ দেখান।

---

**পরবর্তী:** Lec-14 — Python/Node step-by-step project।
