# Lec-18: **Docker ও Nginx দিয়ে Production Ready App বানানো শিখি**

Production-এ সাধারণত **একটি entry point** (Nginx) থাকে যা SSL, static files, এবং backend API-তে request forward করে। এই লেকচারে reverse proxy ও basic production pattern শিখব।

---

## **Nginx কেন?**

- **Reverse proxy:** এক domain → অনেক internal service
- **Static files:** React build দ্রুত serve
- **SSL termination:** HTTPS (Let's Encrypt + certbot)
- **Load balancing:** একাধিক backend instance (উন্নত)

---

## **ধাপ ১: সরল Reverse Proxy — API behind Nginx**

**`nginx.conf`:**

```nginx
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server backend:8000;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
```

**Compose:**

```yaml
services:
  backend:
    build: ./backend
    expose:
      - "8000"    # শুধু internal — host-এ publish নয়

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - backend
```

ব্রাউজার: http://localhost → Nginx → FastAPI

---

## **ধাপ ২: Frontend + API এক Nginx-এ**

```nginx
server {
    listen 80;

    location / {
        root /usr/share/nginx/html;
        try_files $uri $uri/ /index.html;
    }

    location /api/ {
        proxy_pass http://backend:8000/;
    }
}
```

React build `root`-এ copy; API `/api/` prefix-এ।

---

## **ধাপ ৩: Multi-stage — Frontend build inside Compose**

```yaml
services:
  frontend-build:
    build: ./frontend
    # output volume বা nginx image-এ copy — Lec-15 pattern

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - frontend_dist:/usr/share/nginx/html:ro
```

---

## **ধাপ ৪: HTTPS (পরিচয়)**

Production server-এ:

- Domain DNS → server IP
- Certbot + Nginx SSL block
- `listen 443 ssl;`

Local dev-এ HTTPS optional; অনেকেই dev-এ HTTP, prod-এ HTTPS।

---

## **ধাপ ৫: Security headers (basic)**

```nginx
add_header X-Frame-Options "SAMEORIGIN";
add_header X-Content-Type-Options "nosniff";
```

---

## **ধাপ ৬: Rate limit (পরিচয়)**

```nginx
limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;

location /api/ {
    limit_req zone=api burst=20;
    proxy_pass http://backend:8000/;
}
```

---

## **Production Checklist**

- [ ] Backend port public না — শুধু Nginx expose
- [ ] `.env` / secrets compose-এ
- [ ] Healthcheck backend + db
- [ ] Logs: `docker compose logs`
- [ ] Restart policy: `restart: unless-stopped`
- [ ] Resource limits (ঐচ্ছিক): `deploy.resources.limits`

```yaml
services:
  backend:
    restart: unless-stopped
```

---

## **Homework**

1. FastAPI backend + nginx reverse proxy compose বানান।
2. `curl http://localhost/` দিয়ে API response verify করুন।
3. `docker compose exec nginx nginx -t` — config test।
4. Static React + `/api/` proxy nginx config লিখুন (ফাইল হিসেবে)।
5. Production checklist পূরণ করে নিজের প্রজেক্টে tick করুন।

---

**পরবর্তী:** Lec-19 — Docker vs Podman vs VM।
