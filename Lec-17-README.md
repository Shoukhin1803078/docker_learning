# Lec-17: **Docker Compose দিয়ে Full Stack App Deploy করুন – Real Project**

এই লেকচারে **Frontend + Backend API + PostgreSQL** — তিনটি সার্ভিস এক `docker-compose.yml`-এ চালানোর সম্পূর্ণ উদাহরণ। `docker_learning` FastAPI backend ধরে নেওয়া হয়েছে।

---

## **লক্ষ্য আর্কিটেকচার**

```
[Browser] → localhost:5173 (React)
                ↓ API calls
           localhost:8000 (FastAPI)
                ↓
           db:5432 (PostgreSQL, internal network)
```

---

## **ধাপ ১: ফোল্ডার স্ট্রাকচার (monorepo উদাহরণ)**

```
fullstack-docker/
├── backend/          # FastAPI (আপনার app/ copy)
│   ├── app/
│   ├── requirements.txt
│   └── Dockerfile
├── frontend/         # Vite React
│   ├── Dockerfile
│   └── ...
├── docker-compose.yml
└── .env.example
```

---

## **ধাপ ২: `backend/Dockerfile`**

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

## **ধাপ ৩: `docker-compose.yml`**

```yaml
services:
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-appuser}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-secretpass}
      POSTGRES_DB: ${POSTGRES_DB:-myappdb}
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U appuser -d myappdb"]
      interval: 5s
      timeout: 5s
      retries: 5

  backend:
    build: ./backend
    ports:
      - "8000:8000"
    environment:
      DATABASE_URL: postgresql://${POSTGRES_USER:-appuser}:${POSTGRES_PASSWORD:-secretpass}@db:5432/${POSTGRES_DB:-myappdb}
    depends_on:
      db:
        condition: service_healthy

  frontend:
    build: ./frontend
    ports:
      - "5173:80"
    depends_on:
      - backend

volumes:
  pgdata:
```

---

## **ধাপ ৪: `.env.example`**

```
POSTGRES_USER=appuser
POSTGRES_PASSWORD=secretpass
POSTGRES_DB=myappdb
```

কপি করে `.env` বানান (Git-এ commit নয়)।

---

## **ধাপ ৫: চালানো**

```
cd fullstack-docker
docker compose up --build
```

**পরীক্ষা:**

- API: http://localhost:8000/docs
- DB: `docker compose exec db psql -U appuser -d myappdb`
- Frontend: http://localhost:5173 (আপনার frontend port অনুযায়ী)

---

## **ধাপ ৬: Healthcheck কেন?**

`depends_on` শুধু container **start** করে; PostgreSQL ready হতে সময় লাগে। `healthcheck` + `condition: service_healthy` API-কে DB ready হওয়ার পর start করতে সাহায্য করে।

---

## **ধাপ ৭: Logs ও Debug**

```
docker compose logs -f backend
docker compose ps
docker compose exec backend sh
```

---

## **ধাপ ৮: বন্ধ ও reset**

```
docker compose down
docker compose down -v   # DB data মুছে — সাবধান!
```

---

## **সাধারণ সমস্যা**

| সমস্যা              | সমাধান                                      |
|---------------------|---------------------------------------------|
| API DB connect fail | `DATABASE_URL`-এ host `db` not `localhost` |
| Port conflict       | `8000`/`5432` অন্য app ব্যবহার করছে কিনা   |
| Stale build         | `docker compose up --build`                 |
| CORS error          | FastAPI `CORSMiddleware` frontend origin     |

---

## **Homework**

1. `fullstack-docker` স্ট্রাকচার বানান (`backend` = আপনার `docker_learning`)।
2. শুধু `db` + `backend` দিয়ে compose up করুন; `/docs` খুলুন।
3. `healthcheck` ছাড়া ও সহ — পার্থক্য observe করুন।
4. (ঐচ্ছিক) React frontend যোগ করুন।
5. `docker compose down -v` করার আগে volume backup নিন (`pg_dump`)।

---

**পরবর্তী:** Lec-18 — Docker + Nginx Production Ready Setup।
