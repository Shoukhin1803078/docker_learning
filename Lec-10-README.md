# Lec-10: **Docker Hub & Private Registry – Image Upload এবং Pull করার উপায়**

আপনি লোকালে `docker build` করে image বানান। এটা অন্য মেশিনে বা টিমের সাথে শেয়ার করতে **Registry** দরকার। সবচেয়ে জনপ্রিয় public registry হলো **Docker Hub** (https://hub.docker.com)।

---

## **Docker Hub কী?**

- Image store করার **central repository**
- `nginx`, `python`, `ubuntu` — এগুলো Hub-এর official/public image
- আপনি নিজের account-এ **private বা public** image push করতে পারেন

---

## **ধাপ ১: Docker Hub account ও Login**

1. https://hub.docker.com এ সাইন আপ করুন
2. টার্মিনালে login:

```
docker login
```

Username ও password (বা access token) দিন। সফল হলে `Login Succeeded` দেখাবে।

**Logout:**

```
docker logout
```

---

## **ধাপ ২: Image-এ সঠিক Tag দেওয়া**

Hub-এ push করতে image name হতে হয়:

```
<dockerhub_username>/<image_name>:<tag>
```

**উদাহরণ — আপনার Flask বা FastAPI image:**

```
docker build -t yourusername/fastapi-app:v1 .
```

অথবা existing image-কে retag:

```
docker tag flask-docker:latest yourusername/flask-docker:v1
```

**লোকাল image তালিকা:**

```
docker images
```

---

## **ধাপ ৩: Hub-এ Push**

```
docker push yourusername/fastapi-app:v1
```

প্রথম push-এ layer upload হতে সময় লাগতে পারে। Hub-এ ওয়েবসাইটে image দেখা যাবে।

---

## **ধাপ ৪: অন্য মেশিনে Pull**

```
docker pull yourusername/fastapi-app:v1
docker run -p 8000:8000 yourusername/fastapi-app:v1
```

টিমমেট শুধু `pull` + `run` করলেই same environment পায় — Dockerfile ছাড়াও চলে (তবে source থাকলে build ও করা যায়)।

---

## **Tag ও Versioning Best Practice**

| Tag        | ব্যবহার                          |
|------------|-----------------------------------|
| `v1.0.0`   | release version (স্পষ্ট)         |
| `latest`   | সর্বশেষ build (সাবধানে ব্যবহার) |
| `dev`      | development branch               |

```
docker tag myapp:latest yourusername/myapp:1.0.0
docker push yourusername/myapp:1.0.0
docker push yourusername/myapp:latest
```

---

## **Private Image on Docker Hub**

Hub-এ repository তৈরি করার সময় **Private** সিলেক্ট করলে শুধু আপনি/টিম login করে pull করতে পারবে।

```
docker pull yourusername/private-api:v1
```

---

## **Private Registry (সংক্ষিপ্ত পরিচয়)**

কোম্পানি নিজের server-এ registry চালাতে পারে (Docker Hub-এর বিকল্প):

**লোকাল test — Registry container:**

```
docker run -d -p 5000:5000 --name registry registry:2
```

Image tag করুন local registry-র জন্য:

```
docker tag myapp:latest localhost:5000/myapp:v1
docker push localhost:5000/myapp:v1
```

**মনে রাখুন:** Production private registry-এ HTTPS, auth, backup দরকার। বিস্তারিত: https://docs.docker.com/registry/

---

## **অফিসিয়াল vs Verified Image**

Hub থেকে pull করার সময়:

- **Official** — Docker-এর partner maintain (যেমন `python`, `nginx`)
- **Verified Publisher** — trusted vendor
- Random user image — source/review দেখে নিন (security, Lec-21)

---

## **Homework**

1. Docker Hub-এ `docker_learning` বা একটি ছোট test image-এর জন্য repository তৈরি করুন (public ঠিক আছে)।
2. `docker build -t <username>/hello-docker:1.0 .` করুন (ছোট Dockerfile থাকলে ভালো)।
3. `docker push <username>/hello-docker:1.0` করুন।
4. Hub ওয়েবসাইটে image verify করুন।
5. (ঐচ্ছিক) `docker rmi` করে শুধু `docker pull` দিয়ে আবার run করুন।

---

**পরবর্তী:** Lec-11 — Environment Variables দিয়ে config manage করা।
