# Lec-12: **Docker Logs & Debugging – সমস্যা সমাধান করার সহজ উপায়**

Container চালু কিন্তু অ্যাপ কাজ করছে না? পোর্ট খোলা নেই? ক্র্যাশ হচ্ছে? এই লেকচারে **logs**, **exec**, **inspect**, **stats** দিয়ে সমস্যা খুঁজে বের করার পদ্ধতি শিখব।

---

## **ধাপ ১: Container Logs (`docker logs`)**

চলমান বা বন্ধ Container-এর stdout/stderr দেখুন:

```
docker logs <container_name_or_id>
```

**Real-time follow (tail -f এর মতো):**

```
docker logs -f my-container
```

**শেষ ১০০ লাইন:**

```
docker logs --tail 100 my-container
```

**টাইমস্ট্যাম্প সহ:**

```
docker logs -t my-container
```

**উদাহরণ — FastAPI container:**

```
docker run -d --name api -p 8000:8000 <your-image>
docker logs -f api
```

Uvicorn error থাকলে এখানেই দেখা যাবে।

---

## **ধাপ ২: চলমান Container-এ ঢোকা (`docker exec`)**

ইন্টারেক্টিভ shell:

```
docker exec -it api bash
```

Alpine image-এ `bash` নাও থাকতে পারে — তখন:

```
docker exec -it api sh
```

**এক লাইন কমান্ড:**

```
docker exec api ls -la /app
docker exec api cat /app/requirements.txt
```

**প্রসেস দেখা:**

```
docker exec api ps aux
```

---

## **ধাপ ৩: বিস্তারিত তথ্য (`docker inspect`)**

Container/network/volume সম্পূর্ণ JSON config:

```
docker inspect api
```

**নির্দিষ্ট field (Go template):**

```
docker inspect -f '{{.State.Status}}' api
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' api
```

**কখন কাজে লাগে:**

- IP ঠিকানা
- Mount path (volume কোথায়)
- Exit code কেন stop হয়েছে
- Port binding ঠিক আছে কিনা

---

## **ধাপ ৪: রিসোর্স মনিটর (`docker stats`)**

CPU, memory, network live:

```
docker stats
```

একটি Container:

```
docker stats api
```

মেমরি leak বা অতিরিক্ত load খুঁজতে সহায়ক।

---

## **ধাপ ৫: Container Events**

কখন start/stop/die হয়েছে:

```
docker events
```

নির্দিষ্ট filter:

```
docker events --filter container=api
```

---

## **ধাপ ৬: সাধারণ সমস্যা — চেকলিস্ট**

| সমস্যা              | কী দেখবেন                                      |
|---------------------|------------------------------------------------|
| Port খোলা নেই       | `docker ps` → PORTS; `inspect` → PortBindings |
| App crash loop      | `docker logs`; `docker ps -a` → STATUS Exited  |
| File missing        | `docker exec` → `ls /app`                      |
| DB connect fail     | network same? hostname `db` not `localhost`?   |
| Permission error    | volume mount path, user in Dockerfile          |
| Build fail          | `docker build` output; layer যেখানে fail       |

**Exit code দেখুন:**

```
docker inspect -f '{{.State.ExitCode}}' api
```

`0` = normal stop; non-zero = error।

---

## **ধাপ ৭: Compose-এ Debugging**

```
docker compose logs -f backend
docker compose exec backend sh
docker compose ps
```

সব সার্ভিস:

```
docker compose logs
```

---

## **ধাপ ৮: Healthcheck (পরিচয়)**

Dockerfile-এ:

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8000/ || exit 1
```

Status:

```
docker inspect -f '{{.State.Health.Status}}' api
```

Compose:

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8000/"]
  interval: 10s
  retries: 3
```

---

## **Homework**

1. একটি ভুল CMD দিয়ে container চালান (যেমন nonexistent command) — `docker ps -a` ও `docker logs` দিয়ে কারণ খুঁজুন।
2. চলমান nginx container-এ `docker exec` দিয়ে `/usr/share/nginx/html` দেখুন।
3. `docker inspect` দিয়ে আপনার FastAPI container-এর IP ও port mapping লিখুন।
4. `docker stats` ৩০ সেকেন্ড চালিয়ে observation লিখুন।
5. (ঐচ্ছিক) `docker compose` প্রজেক্টে `docker compose logs` ব্যবহার করুন।

---

**পরবর্তী:** Lec-13 — Dockerfile Best Practices।
