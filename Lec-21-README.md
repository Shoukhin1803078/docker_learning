# Lec-21: **Docker Security Best Practices – Container নিরাপদ রাখুন**

Container হালকা হলেও **ভুল কনফিগ** security ঝুঁকি বাড়ায়। এই গাইডে প্রতিদিনের dev ও production-এর জন্য গুরুত্বপূর্ণ অভ্যাস।

---

## **১. Image বিশ্বাসযোগ্যতা**

- **Official / verified** image ব্যবহার (`python`, `nginx`, `postgres`)
- Hub-এ random image — maintainer, pull count, Dockerfile review
- **Pin tag:** `python:3.11.9-slim` not always `latest`

```
docker scan <image>   # Docker Scout / scan features (যদি available)
```

---

## **২. Secret management**

| ❌ করবেন না              | ✅ করবেন                    |
|-------------------------|------------------------------|
| Password Dockerfile-এ   | `-e` / `--env-file` / secrets |
| `.env` Git commit       | `.env.example` + gitignore   |
| API key image layer-এ   | Vault, cloud secret manager  |

---

## **৩. Non-root user**

```dockerfile
RUN adduser --disabled-password appuser
USER appuser
```

```
docker run --user 1000:1000 myimage
```

Container root = host-এ escape ঝুঁকি বাড়াতে পারে (kernel bug সহ)।

---

## **৪. Read-only filesystem (যখন সম্ভব)**

```
docker run --read-only -v /tmp tmpfs myimage
```

অ্যাপ যদি লিখতে না চায় — attack surface কমে।

---

## **৫. Capability ও privileged mode**

```
docker run --privileged myimage   # ❌ শুধু খুব বিশেষ ক্ষেত্রে
```

**Privileged** container প্রায় host-level power — avoid।

---

## **৬. Network exposure কমানো**

- DB port (`5432`) host-এ publish না — শুধু internal network
- Production: firewall + শুধু Nginx 80/443 public

```yaml
services:
  db:
    # ports: - "5432:5432"  ❌ public dev ছাড়া
    expose:
      - "5432"
```

---

## **৭. Resource limits**

```yaml
services:
  api:
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
```

DoS বা memory leak অন্য service ক্ষতি কমায়।

---

## **৮. Image vulnerability scanning**

CI-তে:

- `docker scout cves` বা Trivy
- Critical CVE fix করে rebuild

---

## **৯. `.dockerignore` ও minimal image**

- Secret file copy না
- Attack surface ছোট base (`-slim`, `alpine`)

---

## **১০. Updates**

- Base image regularly update
- `docker compose pull` + redeploy

---

## **১১. Logging ও audit**

```
docker logs
docker events
```

Suspicious restart loop monitor করুন।

---

## **১২. Socket mount সাবধান**

```
-v /var/run/docker.sock:/var/run/docker.sock
```

Container ভিতর থেকে **পুরো Docker control** — শুধু trusted tooling-এ।

---

## **Security Checklist**

- [ ] Non-root USER in Dockerfile
- [ ] No secrets in image layers
- [ ] Trusted base images, pinned tags
- [ ] DB not exposed publicly
- [ ] `--privileged` avoided
- [ ] `.env` in `.gitignore`
- [ ] Scan images in CI

---

## **Homework**

1. আপনার `Dockerfile`-এ non-root user যোগ করার plan লিখুন।
2. `docker history` দিয়ে secret layer আছে কিনা চেক করুন।
3. Compose-এ DB `ports` সরিয়ে শুধু internal রাখুন।
4. Hub থেকে একটি image vs official `nginx` — maintainer compare লিখুন।
5. Checklist ৮টির মধ্যে ৫টি আপনার প্রজেক্টে apply করুন।

---

**পরবর্তী:** Lec-22 — Top 10 Docker Commands।
