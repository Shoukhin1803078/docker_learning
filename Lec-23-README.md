# Lec-23: **Docker Interview Questions – চাকরির জন্য প্রস্তুতি**

সাধারণ **Docker interview** প্রশ্ন ও সংক্ষিপ্ত উত্তর (বাংলা + ইংরেজি টার্ম)। মুখস্থ না করে **ধারণা** বুঝে উত্তর দিন।

---

## **বেসিক**

### **১. Docker কী?**

**উত্তর:** Docker হলো container platform — অ্যাপ্লিকেশন ও তার dependencies এক **image**-এ প্যাক করে যেকোনো জায়গায় একইভাবে চালানোর সুবিধা দেয়। VM-এর চেয়ে হালকা কারণ host kernel share করে।

---

### **২. Image vs Container?**

**উত্তর:** **Image** = read-only template/blueprint। **Container** = image থেকে চালু instance (writable layer সহ)। analogy: class vs object।

---

### **৩. Dockerfile কী?**

**উত্তর:** Image build করার instruction ফাইল (`FROM`, `COPY`, `RUN`, `CMD` ইত্যাদি)।

---

### **৪. `COPY` vs `ADD`?**

**উত্তর:** সাধারণত **COPY** ব্যবহার করুন। ADD URL/tar auto-extract করতে পারে — কম প্রয়োজনে ADD avoid।

---

### **৫. `CMD` vs `ENTRYPOINT`?**

**উত্তর:** **ENTRYPOINT** = container সবসময় যে executable। **CMD** = default arguments; override সহজ। একটি Dockerfile-এ এক ENTRYPOINT, CMD optional defaults।

---

## **নেটওয়ার্ক ও ডেটা**

### **৬. Container কীভাবে একে অপরের সাথে কথা বলে?**

**উত্তর:** Same **custom network**-এ container **name** = hostname। `http://db:5432`। `localhost` অন্য container নয়।

---

### **৭. Volume কেন দরকার?**

**উত্তর:** Container delete হলে internal data হারায়। **Volume/bind mount** দিয়ে data persist ও share করা যায়।

---

### **৮. Bind mount vs Named volume?**

**উত্তর:** Bind = host path সরাসরি (`/Users/...:/app`). Named = Docker-managed (`my-vol:/data`) — portable, backup সহজ।

---

## **Compose ও Production**

### **৯. Docker Compose কী?**

**উত্তর:** Multi-container YAML define; `docker compose up` এক কমান্ডে stack চালায়। Dev ও small deploy-এ জনপ্রিয়।

---

### **১০. `depends_on` কী guarantee করে?**

**উত্তর:** শুধু **start order**, DB ready নয়। **healthcheck** + `condition: service_healthy` বেশি নির্ভরযোগ্য।

---

### **১১. `-p 8080:80` মানে কী?**

**উত্তর:** Host port 8080 → container port 80 map। ব্রাউজার `localhost:8080`।

---

### **১২. `EXPOSE` কি port খোলে?**

**উত্তর:** না — documentation। Actual publish = `-p` বা compose `ports`।

---

## **Build ও Optimization**

### **১৩. Layer caching কীভাবে কাজ করে?**

**উত্তর:** প্রতিটি instruction layer। unchanged layer cache থেকে rebuild skip। `requirements.txt` আগে copy = smart caching।

---

### **১৪. Multi-stage build কেন?**

**উত্তর:** Build tools final image-এ না রেখে ছোট, secure production image।

---

### **১৫. `.dockerignore` কেন?**

**উত্তর:** অপ্রয়োজনীয় ফাইল build context থেকে বাদ — দ্রুত build, secret কম leak।

---

## **Security ও Architecture**

### **১৬. Container root user ঝুঁকি?**

**উত্তর:** Container compromise হলে host impact বাড়তে পারে — **non-root USER** best practice।

---

### **১৭. Docker vs VM?**

**উত্তর:** VM = full OS, heavy isolation। Container = shared kernel, light, fast। ভিন্ন use case।

---

### **১৮. Docker vs Kubernetes?**

**উত্তর:** Docker = build/run container। Kubernetes = many container **orchestrate** (scale, self-heal, rolling update)। K8s often Docker/containerd runtime ব্যবহার করে।

---

### **১৯. Docker Swarm কী?**

**উত্তর:** Docker native clustering — services, replicas, stack deploy। K8s-এর চেয়ে সহজ, বাজারে K8s বেশি।

---

### **২০. Production checklist (৩টি)?**

**উত্তর উদাহরণ:** non-root, secrets not in image, DB not public, healthcheck, pinned images, logging, reverse proxy (Nginx), backups।

---

## **হাতে-কলমে (Practical round)**

ইন্টারভিউয়ার চাইতে পারে:

```bash
docker ps -a
docker logs <container>
docker exec -it <container> sh
docker build -t app .
docker run -p 8000:8000 app
docker compose up -d
```

**Scenario:** “API DB-তে connect করতে পারছে না” — logs, `DATABASE_URL` host `db` vs `localhost`, network, `docker compose ps`.

---

## **Behavioral / Experience**

- আপনি কোন প্রজেক্ট Dockerize করেছেন? → `docker_learning` FastAPI উদাহরণ দিন।
- CI/CD-এ image build/push?
- সমস্যা solve: logs + inspect + exec।

---

## **Homework — Interview Prep**

1. উপরের ২০ প্রশ্নের উত্তর **নিজের কথায়** ২-৩ বাক্যে লিখুন।
2. একজন বন্ধুকে “Docker কী” ১ মিনিটে ব্যাখ্যা করুন।
3. Whiteboard: Image → Container → Volume → Network diagram আঁকুন।
4. `docker ps`, `logs`, `exec` live demo practice।
5. আপনার resume-এ Docker bullet — Lec-14/17 project link যোগ করুন।

---

**অভিনন্দন!** Lec-1 থেকে Lec-23 — Docker learning path সম্পূর্ণ করার গাইড প্রস্তুত। প্র্যাকটিসই মূল — প্রতিটি Homework করুন।
