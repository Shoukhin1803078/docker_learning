# Lec-16: **Database Dockerize করা শিখি – MySQL, PostgreSQL Use Case**

Database container-এ চালানো development-এর জন্য দ্রুত ও সুবিধাজনক। Production-এ managed DB (RDS, Cloud SQL) বেশি দেখা যায় — তবে Docker দিয়ে শেখা এবং local dev একই প্যাটার্ন।

---

## **কেন Database Container?**

- টিমে একই version (PostgreSQL 16)
- `docker compose up` দিয়ে API + DB একসাথে
- **Volume** দিয়ে data persist (Lec-7)

---

## **ধাপ ১: PostgreSQL চালানো**

```
docker run -d \
  --name postgres-db \
  -e POSTGRES_USER=appuser \
  -e POSTGRES_PASSWORD=secretpass \
  -e POSTGRES_DB=myappdb \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql/data \
  postgres:16-alpine
```

| Flag / Env              | অর্থ                    |
|-------------------------|-------------------------|
| `POSTGRES_USER`         | DB user                 |
| `POSTGRES_PASSWORD`     | password                |
| `POSTGRES_DB`           | default database name   |
| `-v pgdata:...`         | named volume — data রেখে |
| `-p 5432:5432`          | host থেকে connect       |

**চেক:**

```
docker logs postgres-db
docker exec -it postgres-db psql -U appuser -d myappdb
```

psql-এ:

```sql
\dt
CREATE TABLE users (id SERIAL PRIMARY KEY, name TEXT);
INSERT INTO users (name) VALUES ('Docker Learner');
SELECT * FROM users;
\q
```

---

## **ধাপ ২: MySQL চালানো**

```
docker run -d \
  --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=myappdb \
  -e MYSQL_USER=appuser \
  -e MYSQL_PASSWORD=secretpass \
  -p 3306:3306 \
  -v mysql_data:/var/lib/mysql \
  mysql:8
```

**Connect:**

```
docker exec -it mysql-db mysql -u appuser -p myappdb
```

Password: `secretpass`

---

## **ধাপ ৩: App থেকে Connection String**

**Host machine থেকে (Python on Mac, DB in Docker):**

```
postgresql://appuser:secretpass@localhost:5432/myappdb
```

**অন্য Container থেকে (same compose network):**

```
postgresql://appuser:secretpass@postgres-db:5432/myappdb
```

Hostname = **container name** বা compose **service name**, `localhost` নয়।

---

## **ধাপ ৪: Docker Compose — DB + API**

`docker-compose.yml`:

```yaml
services:
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: appuser
      POSTGRES_PASSWORD: secretpass
      POSTGRES_DB: myappdb
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  api:
    build: .
    ports:
      - "8000:8000"
    environment:
      DATABASE_URL: postgresql://appuser:secretpass@db:5432/myappdb
    depends_on:
      - db

volumes:
  pgdata:
```

```
docker compose up -d
```

---

## **Data Backup (সংক্ষিপ্ত)**

PostgreSQL dump:

```
docker exec postgres-db pg_dump -U appuser myappdb > backup.sql
```

Restore:

```
docker exec -i postgres-db psql -U appuser myappdb < backup.sql
```

---

## **MySQL vs PostgreSQL — Docker-এ**

| বিষয়        | PostgreSQL        | MySQL           |
|--------------|-------------------|-----------------|
| Image        | `postgres:16-alpine` | `mysql:8`   |
| Default port | 5432              | 3306            |
| Volume path  | `/var/lib/postgresql/data` | `/var/lib/mysql` |
| Env prefix   | `POSTGRES_*`      | `MYSQL_*`       |

---

## **সাবধানতা**

- Production secret `.env`-এ, image-এ নয়
- Root password শক্ত রাখুন
- Dev-এ `-p 5432:5432` ঠিক আছে; prod-এ часто DB port public করা হয় না

---

## **Homework**

1. PostgreSQL container চালিয়ে table create + insert করুন।
2. Container remove করে আবার same volume দিয়ে data আছে কিনা দেখুন।
3. MySQL container চালিয়ে একই কাজ করুন।
4. `DATABASE_URL` লিখে FastAPI-তে (ঐচ্ছিক) connect করার plan করুন।
5. `docker volume ls` দিয়ে `pgdata` দেখুন।

---

**পরবর্তী:** Lec-17 — Full Stack Compose Real Project।
