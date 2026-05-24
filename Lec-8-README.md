

# ---------------------------Chat GPT-----------------------------------------------

# Lec-8:

# Lec-8: Docker Networks Explained – Containers কিভাবে কথা বলে একে অপরের সাথে?

Docker এ একাধিক Container একসাথে কাজ করার সময় তাদের মধ্যে communication দরকার হয়।

যেমন:

- Backend API ↔ Database
- Frontend ↔ Backend
- Redis ↔ Python App

এই communication handle করার জন্য Docker ব্যবহার করে **Docker Network**।

---

## Docker Network কী?

Docker Network হলো এমন একটি virtual network যেখানে multiple containers একে অপরের সাথে connect হতে পারে।

একই network এ থাকা containers:

- একে অপরকে access করতে পারে
- container name দিয়ে communicate করতে পারে
- isolated environment এ থাকতে পারে

---

### Real Life Example

ভাবুন:

- একটা container = একটা computer
- Docker Network = WiFi router / LAN network

যে devices একই WiFi তে থাকে তারা একে অপরকে access করতে পারে।

একইভাবে একই Docker Network এ থাকা containers communicate করতে পারে।

---

## Docker এর Default Networks

Docker automatically কিছু network তৈরি করে।

সব network দেখতে:

```
docker networkls
```

Example output:

```
NETWORK ID     NAME      DRIVER    SCOPE
xxxxxx         bridge    bridge    local
xxxxxx         host      host      local
xxxxxx         none      null      local
```

---

# Docker Network Types

## 1. Bridge Network (সবচেয়ে common)

Default network type।

একই machine এর containers একে অপরের সাথে communicate করতে পারে।

এটাই সবচেয়ে বেশি use হয়।

---

## 2. Host Network

Container directly host machine এর network use করে।

Linux এ বেশি use হয়।

---

## 3. None Network

Container এর কোনো network থাকবে না।

Completely isolated।

---

# Bridge Network কিভাবে কাজ করে?

চলুন practical example দেখি।

---

# Step-1: দুইটা Ubuntu Container Run করি

```
docker run-dit--name ubuntu1 ubuntu
```

```
docker run-dit--name ubuntu2 ubuntu
```

Explanation:

- `d` → detached mode
- `i` → interactive
- `t` → terminal

---

# Step-2: Running Containers দেখুন

```
dockerps
```

---

# Step-3: Network Inspect করি

```
docker network inspect bridge
```

এখানে আপনি connected containers দেখতে পারবেন।

---

# Step-4: এক Container থেকে আরেক Container এ Ping করি

প্রথম container এ ঢুকুন:

```
docker exec-it ubuntu1bash
```

এখন দ্বিতীয় container কে ping দিন:

```
ping ubuntu2
```

কিছু Ubuntu image এ ping install করা থাকে না।

তখন install করুন:

```
apt update
apt install iputils-ping
```

তারপর:

```
ping ubuntu2
```

যদি reply আসে তাহলে বুঝবেন containers successfully communicate করছে।

---

# গুরুত্বপূর্ণ Concept: Container Name as Hostname

Docker network এর সবচেয়ে cool feature:

আপনি container IP মনে না রেখেও container name দিয়ে access করতে পারবেন।

যেমন:

```
ping ubuntu2
```

এখানে `ubuntu2` automatically hostname হিসেবে কাজ করছে।

Real project এ এটা huge সুবিধা দেয়।

---

# Custom Network কেন দরকার?

Default bridge network এ limitations আছে।

Production বা real projects এ আমরা usually custom network use করি।

Benefits:

- Better isolation
- Better security
- Easier communication
- Cleaner architecture

---

# Custom Docker Network তৈরি করা

## Step-1: Network Create করুন

```
docker network create my-network
```

---

## Step-2: Network List দেখুন

```
docker networkls
```

এখন `my-network` দেখতে পাবেন।

---

# Container কে Custom Network এ Run করা

```
docker run-dit--name container1--network my-network ubuntu
```

```
docker run-dit--name container2--network my-network ubuntu
```

---

# Communication Test

প্রথম container এ ঢুকুন:

```
docker exec-it container1bash
```

Ping দিন:

```
ping container2
```

Successfully communicate করবে।

---

# Network Inspect করা

```
docker network inspect my-network
```

এখানে আপনি দেখতে পারবেন:

- connected containers
- IP addresses
- subnet
- gateway

---

# Existing Container কে Network এ Connect করা

ধরুন container already running।

তখন:

```
docker network connect my-network ubuntu1
```

এখন ubuntu1 network এ join করবে।

---

# Network থেকে Disconnect করা

```
docker network disconnect my-network ubuntu1
```

---

# Container IP Address দেখা

```
docker inspect container1
```

অনেক বড় output আসবে।

Specific IP দেখতে:

```
docker inspect-f'{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container1
```

---

# Real Project Example

ধরুন:

## Backend Container

```
backend-api
```

## Database Container

```
postgres-db
```

একই network এ থাকলে backend simply database access করতে পারবে:

```
DB_HOST="postgres-db"
```

এখানে IP লাগছে না।

Container name দিয়েই connection হচ্ছে।

এটাই Docker networking এর magic 🔥

---

# Important Docker Network Commands

## সব network দেখুন

```
docker networkls
```

---

## Network create করুন

```
docker network create my-network
```

---

## Network details দেখুন

```
docker network inspect my-network
```

---

## Network delete করুন

```
docker networkrm my-network
```

---

## Container কে network এ connect করুন

```
docker network connect my-network container1
```

---

## Container disconnect করুন

```
docker network disconnect my-network container1
```

---

# Mini Real Project Practice

চলুন ছোট একটা practice করি।

---

## Step-1: Network Create

```
docker network create app-network
```

---

## Step-2: MySQL Container Run

```
docker run-d \
--name mysql-db \
--network app-network \
-eMYSQL_ROOT_PASSWORD=root \
mysql
```

---

## Step-3: Ubuntu Container Run

```
docker run-it \
--name app-container \
--network app-network \
ubuntubash
```

---

## Step-4: MySQL Container কে Ping করুন

Ubuntu container এর ভিতরে:

```
ping mysql-db
```

Communication successful হলে বুঝবেন:

✅ Containers একই network এ আছে

✅ তারা একে অপরের সাথে কথা বলতে পারছে

---

# Docker Networking Flow Diagram

```
+---------------------+
|   Docker Network    |
|     app-network     |
+---------------------+
      |         |
      |         |
+-----------+   +-----------+
| Backend   |   | Database  |
| Container |   | Container |
+-----------+   +-----------+
```

---

# Interview Questions

## Question-1:

Docker network কেন দরকার?

### Answer:

Multiple containers এর মধ্যে communication enable করার জন্য Docker network ব্যবহার করা হয়।

---

## Question-2:

Default Docker network type কী?

### Answer:

Bridge network।

---

## Question-3:

Container name দিয়ে communication possible কেন?

### Answer:

Docker internal DNS provide করে।

---

## Question-4:

Custom network use করার benefit কী?

### Answer:

- Better isolation
- Better security
- Easy communication
- Better architecture

---

# Homework 🔥

## Task-1

একটি custom network তৈরি করুন:

```
docker network create practice-network
```

---

## Task-2

দুইটা Ubuntu container run করুন একই network এ।

---

## Task-3

এক container থেকে অন্য container কে ping দিন।

---

## Task-4

`docker network inspect` ব্যবহার করে IP address দেখুন।

---

# Lec-8 Summary

আজকে আপনি শিখলেন:

✅ Docker Network কী
✅ Bridge network
✅ Custom network
✅ Container communication
✅ Container name as hostname
✅ Network inspect
✅ Connect/disconnect container
✅ Real project communication flow


---

# ---------------------------Cursor-----------------------------------------------



# Lec-8: **Docker Networks Explained – Containers কিভাবে কথা বলে একে অপরের সাথে?**

Docker-এ একাধিক Container একসাথে চালালে প্রায়ই দরকার হয়: একটি **API** আর একটি **Database** যেন একে অপরের সাথে কথা বলতে পারে। এই গাইডে আমরা Docker Network কী, কেন দরকার, এবং Container-গুলো কীভাবে একে অপরের সাথে যোগাযোগ করে তা শিখব।

---

## **কেন Network দরকার?**

প্রতিটি Container আলাদা **isolated** পরিবেশে চলে। Network ছাড়া:

- Container A, Container B-কে `localhost` দিয়ে খুঁজে পাবে না (প্রতিটির নিজস্ব `localhost`)
- IP ঠিকানা Container restart হলে বদলে যেতে পারে

**Docker Network** দিয়ে আমরা একাধিক Container-কে একই ভার্চুয়াল নেটওয়ার্কে রাখি। সেখানে তারা **Container name** দিয়ে একে অপরকে খুঁজে পায় — IP মুখস্থ করার দরকার নেই।

---

## **ডিফল্ট Network Driver: bridge**

Docker Desktop/Mac-এ সাধারণত প্রতিটি Container **bridge** network-এ যুক্ত হয়। এটি একটি ভার্চুয়াল সুইচের মতো কাজ করে।

**সব Network দেখুন:**

```
docker network ls
```

আউটপুটে সাধারণত দেখবেন:

| NAME      | DRIVER | বর্ণনা                          |
|-----------|--------|----------------------------------|
| bridge    | bridge | ডিফল্ট — একক Container-এর জন্য |
| host      | host   | হোস্টের নেটওয়ার্ক সরাসরি ব্যবহার |
| none      | null   | কোনো নেটওয়ার্ক নেই              |

---

## **ধাপ ১: Custom Network তৈরি করা**

আমরা একটি নিজস্ব network বানাব যেখানে আমাদের Container-গুলো থাকবে:

```
docker network create my-app-network
```

**বিস্তারিত দেখুন:**

```
docker network inspect my-app-network
```

এখানে `Subnet`, `Gateway` এবং পরে যুক্ত Container-গুলোর তথ্য পাবেন।

---

## **ধাপ ২: দুটি Container একই Network-এ চালানো**

**প্রথম Container — একটি সিম্পল ওয়েব সার্ভার (nginx):**

```
docker run -d --name web-server --network my-app-network nginx:alpine
```

**দ্বিতীয় Container — Ubuntu, একই network-এ:**

```
docker run -it --name test-client --network my-app-network ubuntu bash
```

`test-client` Container-এর ভিতরে থেকে `web-server` **নাম** দিয়ে ping করুন:

```
apt update && apt install -y curl
curl http://web-server
```

আপনি nginx-এর ডিফল্ট HTML পেজ দেখতে পাবেন। এর মানে: **Container name = hostname** (একই custom network-এ)।

`exit` লিখে বেরিয়ে আসুন।

---

## **ধাপ ৩: Default bridge vs Custom network**

| বিষয়              | Default `bridge`     | Custom network (যেমন `my-app-network`) |
|--------------------|----------------------|----------------------------------------|
| Name resolution    | সাধারণত নেই          | Container name দিয়ে resolve হয়       |
| `--link` (পুরনো)  | আগে ব্যবহার হত       | এখন custom network বেশি ভালো          |
| Production pattern | একা Container        | API + DB একসাথে                      |

**উদাহরণ — default bridge-এ দুটি Container (name resolve নাও হতে পারে):**

```
docker run -d --name app1 nginx:alpine
docker run -it --name app2 ubuntu bash
# app2 থেকে: curl http://app1  — অনেক সময় কাজ নাও করতে পারে
```

Custom network ব্যবহার করাই **best practice**।

---

## **Network Types সংক্ষেপে**

- **bridge:** এক মেশিনে একাধিক Container (সবচেয়ে সাধারণ)
- **host:** Container সরাসরি হোস্টের network stack ব্যবহার করে (`-p` ম্যাপিংয়ের দরকার কম)
- **none:** কোনো external network নেই — সম্পূর্ণ বিচ্ছিন্ন
- **overlay:** Swarm / multi-host (Lec-20-এ আরও)

---

## **ধাপ ৪: Container-কে পরে Network-এ যুক্ত করা**

চলমান Container-কে নতুন network-এ attach:

```
docker network connect my-app-network <container_name>
```

Disconnect:

```
docker network disconnect my-app-network <container_name>
```

---

## **ধাপ ৫: Port Publishing vs Internal Communication**

- **ভিতরের যোগাযোগ:** `http://web-server:80` — শুধু একই network-এর Container-গুলো
- **বাইরের দুনিয়া (আপনার ব্রাউজার):** `-p 8080:80` — হোস্ট পোর্ট ম্যাপ

```
docker run -d --name web-public --network my-app-network -p 8080:80 nginx:alpine
```

ব্রাউজারে: `http://localhost:8080`

---

## **Network পরিষ্কার করা**

```
docker stop web-server test-client web-public
docker rm web-server test-client web-public
docker network rm my-app-network
```

কোনো Container ব্যবহার করলে network remove হবে না — আগে Container remove করুন।

---

## **Homework**

1. `docker network create homework-net` দিয়ে network তৈরি করুন।
2. `redis:alpine` image দিয়ে `--name my-redis --network homework-net` Container চালান।
3. Ubuntu Container দিয়ে একই network-এ `redis-cli -h my-redis ping` চালান (redis-cli install লাগতে পারে)।
4. `docker network inspect homework-net` দিয়ে কোন Container যুক্ত আছে দেখুন।
5. সব clean up করুন (`docker rm`, `docker network rm`)।

---

**পরবর্তী:** Lec-9-এ আমরা **Docker Compose** দিয়ে একাধিক Container এক ফাইলে চালানো শিখব — network সেখানে আরও সহজ হয়ে যায়।
