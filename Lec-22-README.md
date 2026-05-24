# Lec-22: **Top 10 Docker Commands প্রতিদিনের কাজে লাগবে**

প্রতিদিন Docker ব্যবহারকারীর জন্য সবচেয়ে কাজের **১০টি কমান্ড** — বাংলায় সংক্ষিপ্ত ব্যাখ্যা সহ।

---

## **১. `docker ps`**

চলমান container তালিকা।

```
docker ps
docker ps -a          # বন্ধ সহ সব
docker ps -a --filter "name=api"
```

**কখন:** কোন container চলছে, port mapping কী।

---

## **২. `docker images`**

লোকাল image তালিকা।

```
docker images
docker images | grep fastapi
```

**কখন:** disk খালি, tag/version খুঁজে।

---

## **৩. `docker run`**

Image থেকে নতুন container চালানো।

```
docker run -d -p 8000:8000 --name api myimage
docker run -it ubuntu bash
docker run --rm alpine echo hi    # exit后 auto remove
```

**গুরুত্বপূর্ণ flags:** `-d`, `-p`, `-e`, `-v`, `--name`, `-it`, `--rm`

---

## **৪. `docker build`**

Dockerfile থেকে image।

```
docker build -t myapp:v1 .
docker build --no-cache -t myapp:v1 .
```

---

## **৫. `docker stop` / `docker start`**

```
docker stop api
docker start api
docker restart api
```

---

## **৬. `docker rm` / `docker rmi`**

Container / image মুছে ফেলা।

```
docker rm api
docker rm -f api          # চলমান হলে force
docker rmi myapp:v1
docker image prune        # unused images
docker system prune -a    # সাবধান — বড় cleanup
```

---

## **৭. `docker logs`**

```
docker logs api
docker logs -f --tail 50 api
```

---

## **৮. `docker exec`**

চলমান container-এ command।

```
docker exec -it api sh
docker exec api cat /app/requirements.txt
```

---

## **৯. `docker compose`**

Multi-container প্রজেক্ট।

```
docker compose up -d
docker compose down
docker compose ps
docker compose logs -f backend
docker compose up --build
```

---

## **১০. `docker pull` / `docker push`**

Registry থেকে image আনা / পাঠানো।

```
docker pull nginx:alpine
docker push yourusername/myapp:v1
```

---

## **Bonus — দ্রুত reference**

| কমান্ড              | কাজ                    |
|---------------------|------------------------|
| `docker inspect X`  | বিস্তারিত JSON config  |
| `docker stats`      | CPU/RAM live           |
| `docker network ls` | networks               |
| `docker volume ls`  | volumes                |
| `docker login`      | Hub auth               |

---

## **এক দিনের typical workflow**

```bash
# সকালে প্রজেক্ট
cd docker_learning
docker compose up -d --build

# bug fix
docker compose logs -f backend
docker compose exec backend sh

# শেষে
docker compose down
```

---

## **Homework**

1. উপরের ১০ কমান্ড নিজে টাইপ করে একবার করে run করুন।
2. `docker system df` — disk usage দেখুন।
3. `docker compose` দিয়ে ২ service চালিয়ে `ps` + `logs` practice।
4. নিজের cheat sheet (১ পেজ) বাংলায় লিখুন।
5. Lec-23 interview-এর আগে এই তালিকা revise করুন।

---

**পরবর্তী:** Lec-23 — Docker Interview Questions।
