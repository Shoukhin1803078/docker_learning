# Lec-15: **React/Next.js Frontend Dockerize করা শিখি**

Frontend (React, Next.js) Dockerize করার দুটি প্রধান পদ্ধতি:

1. **Static build + Nginx** — CRA/Vite React (production)
2. **Node server** — Next.js `next start` (SSR)

---

## **পদ্ধতি ১: React (Vite) + Nginx — Multi-stage**

### **ধাপ ১: React app তৈরি (যদি নেই)**

```
npm create vite@latest react-docker-demo -- --template react
cd react-docker-demo
npm install
```

### **ধাপ ২: `Dockerfile`**

```dockerfile
# Build stage
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

Vite output `dist/`; Create React App হলে `build/` path বদলুন।

### **ধাপ ৩: Build & Run**

```
docker build -t react-nginx .
docker run -d -p 3000:80 --name react-fe react-nginx
```

ব্রাউজার: http://localhost:3000

### **ধাপ ৪: API URL (environment)**

Build time-এ API URL দিতে:

```dockerfile
ARG VITE_API_URL=http://localhost:8000
ENV VITE_API_URL=$VITE_API_URL
RUN npm run build
```

```
docker build --build-arg VITE_API_URL=http://api:8000 -t react-nginx .
```

---

## **পদ্ধতি ২: Next.js (SSR) — Node image**

### **সাধারণ `Dockerfile` (standalone output)**

`next.config.js`:

```javascript
module.exports = { output: 'standalone' };
```

```dockerfile
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci

FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public
EXPOSE 3000
CMD ["node", "server.js"]
```

```
docker build -t nextjs-app .
docker run -p 3000:3000 nextjs-app
```

---

## **Development vs Production**

| পরিবেশ   | পদ্ধতি                                      |
|----------|---------------------------------------------|
| Dev      | `npm run dev` + volume mount (বা host-এ dev) |
| Prod     | Multi-stage build, nginx বা standalone      |

Dev compose উদাহরণ:

```yaml
services:
  frontend:
    image: node:20-alpine
    working_dir: /app
    volumes:
      - .:/app
    command: npm run dev
    ports:
      - "5173:5173"
```

---

## **CORS ও Backend URL**

Frontend container থেকে backend:

- Browser user-এর মেশিন থেকে call → `http://localhost:8000`
- SSR server-side call → compose service name `http://backend:8000`

এটা confuse করার একটি সাধারণ জায়গা — **কে call করছে** (browser vs server) সেটা বুঝুন।

---

## **Homework**

1. Vite React app দিয়ে multi-stage nginx image build করুন।
2. Browser-এ UI খুলে verify করুন।
3. `docker history react-nginx` দিয়ে layer দেখুন।
4. (ঐচ্ছিক) Next.js tutorial app dockerize করুন।
5. Backend `docker_learning` চালু রেখে frontend থেকে API call plan লিখুন (URL কী হবে)।

---

**পরবর্তী:** Lec-16 — MySQL, PostgreSQL Database Dockerize।
