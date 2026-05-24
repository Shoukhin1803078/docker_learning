# Lec-20: **Intro to Docker Swarm – Multi-host Deployments in Bangla**

**Docker Swarm** হলো Docker-এর built-in **orchestration** — একাধিক মেশিনে (node) container cluster হিসেবে চালানো। ছোট production বা শেখার জন্য Kubernetes-এর চেয়ে সহজ entry point।

---

## **Swarm মূল ধারণা**

| শব্দ      | অর্থ                                      |
|-----------|-------------------------------------------|
| **Manager** | cluster control plane (schedule, deploy) |
| **Worker**  | container চালায়                        |
| **Service** | কতগুলো replica চালবে define করে       |
| **Stack**   | `docker stack deploy` — compose file swarm-এ |
| **Overlay network** | বিভিন্ন node-এর container যোগাযোগ |

---

## **ধাপ ১: Swarm initialize (এক মেশিনে শেখা)**

```
docker swarm init
```

আউটপুটে worker join token থাকতে পারে — অন্য মেশিন worker হিসেবে যোগ করতে।

**Swarm status:**

```
docker info | grep -i swarm
docker node ls
```

---

## **ধাপ ২: Service তৈরি — replicated nginx**

```
docker service create --name web --replicas 3 -p 8080:80 nginx:alpine
```

**দেখুন:**

```
docker service ls
docker service ps web
```

ব্রাউজার: http://localhost:8080 — load balancer কোনো replica-তে পাঠাতে পারে।

**Scale:**

```
docker service scale web=5
```

**আপডেট image:**

```
docker service update --image nginx:1.25-alpine web
```

---

## **ধাপ ৩: Stack deploy (Compose → Swarm)**

`docker-compose.yml` (version 3+ style, `deploy` key):

```yaml
services:
  api:
    image: yourusername/fastapi-app:v1
    ports:
      - "8000:8000"
    deploy:
      replicas: 2
      restart_policy:
        condition: on-failure

  db:
    image: postgres:16-alpine
    volumes:
      - pgdata:/var/lib/postgresql/data
    deploy:
      placement:
        constraints:
          - node.role == manager   # উদাহরণ — prod-এ আলাদা planning

volumes:
  pgdata:
```

**Deploy:**

```
docker stack deploy -c docker-compose.yml mystack
```

**দেখুন:**

```
docker stack ls
docker stack services mystack
docker stack ps mystack
```

**সরানো:**

```
docker stack rm mystack
```

---

## **ধাপ ৪: Overlay network**

Multi-node-এ same service name resolve:

```
docker network create -d overlay my-overlay
docker service create --network my-overlay --name app nginx:alpine
```

---

## **Swarm vs Kubernetes (সংক্ষেপ)**

| Swarm              | Kubernetes           |
|--------------------|----------------------|
| Docker-এ built-in  | আলাদা ecosystem      |
| সহজ, ছোট টিম       | industry standard    |
| feature কম         | বিশাল ecosystem      |

নতুন job market-এ **Kubernetes** বেশি; Swarm শেখা concept (service, replica, stack) বুঝতে সাহায্য করে।

---

## **ধাপ ৫: Swarm ছাড়া (leave)**

```
docker swarm leave --force
```

শুধু test cluster-এ; production data আগে backup।

---

## **Homework**

1. `docker swarm init` করে ৩ replica nginx service চালান।
2. `docker service ps` দিয়ে replica distribution দেখুন।
3. `scale` 2 ও 4 করে observe করুন।
4. ছোট `docker-compose.yml` + `deploy.replicas` দিয়ে stack deploy চেষ্টা করুন।
5. Swarm vs Kubernetes — ৫ বুলেট তুলনা লিখুন।

---

**পরবর্তী:** Lec-21 — Docker Security Best Practices।
