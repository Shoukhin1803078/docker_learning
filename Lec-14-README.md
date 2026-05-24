# Lec-14: **Python/Node.js App Dockerize করে দেখাই – Step by Step Project**

এই লেকচারে আমরা **Python FastAPI** (আপনার `docker_learning` প্রজেক্ট) এবং সংক্ষেপে **Node.js Express** — দুটোই step-by-step containerize করব।

---

## **ভাগ ১: Python FastAPI (আপনার প্রজেক্ট)**

### **প্রজেক্ট স্ট্রাকচার**

```
docker_learning/
├── app/
│   └── main.py
├── requirements.txt
├── Dockerfile
└── .dockerignore
```

### **ধাপ ১: `requirements.txt`**

```
fastapi
uvicorn[standard]
```

### **ধাপ ২: `app/main.py`**

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello, World!"}
```

### **ধাপ ৩: `Dockerfile`**

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### **ধাপ ৪: Build**

প্রজেক্ট রুটে:

```
cd /Users/mdalamintokder/docker_learning
docker build -t fastapi-docker .
```

### **ধাপ ৫: Run**

```
docker run -d --name fastapi-app -p 8000:8000 fastapi-docker
```

ব্রাউজার: http://localhost:8000  
API docs: http://localhost:8000/docs

### **ধাপ ৬: Logs ও Stop**

```
docker logs fastapi-app
docker stop fastapi-app
docker rm fastapi-app
```

### **ধাপ ৭: Dev — কোড change (bind mount)**

প্রতিবার rebuild ছাড়া dev:

```
docker run -p 8000:8000 -v $(pwd):/app fastapi-docker
```

অথবা compose (Lec-9) + `--reload` uvicorn।

---

## **ভাগ ২: Node.js Express (নতুন ছোট প্রজেক্ট)**

### **ধাপ ১: ফোল্ডার**

```
mkdir node-docker-demo && cd node-docker-demo
npm init -y
npm install express
```

### **ধাপ ২: `index.js`**

```javascript
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.json({ message: 'Hello from Node in Docker!' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server on port ${PORT}`);
});
```

### **ধাপ ৩: `Dockerfile`**

```dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY index.js .

EXPOSE 3000

CMD ["node", "index.js"]
```

### **ধাপ ৪: Build & Run**

```
docker build -t node-express .
docker run -d -p 3000:3000 --name node-app node-express
curl http://localhost:3000
```

---

## **Python vs Node — তুলনা**

| ধাপ        | Python/FastAPI        | Node/Express        |
|------------|------------------------|---------------------|
| Base image | `python:3.11-slim`     | `node:20-alpine`    |
| Dependencies | `pip install -r`   | `npm ci`            |
| Run command | `uvicorn ...`         | `node index.js`     |
| Default port | 8000                | 3000                |

---

## **Homework**

1. `docker_learning` build করে browser-এ `/docs` খুলুন।
2. `node-docker-demo` বানিয়ে curl দিয়ে test করুন।
3. Python container-এ `docker exec` দিয়ে `pip list` দেখান।
4. Node container-এ `docker exec` দিয়ে `node -v` দেখান।
5. দুটো image-এর size `docker images` দিয়ে compare করুন।

---

**পরবর্তী:** Lec-15 — React/Next.js Frontend Dockerize।
