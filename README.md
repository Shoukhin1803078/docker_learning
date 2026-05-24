# docker_learning

currently i have learn a docker playlist from a tutor. i have already learn these topic:
- Lec-1: Docker কি? কেন শিখবো Docker? – Complete Intro in Bangla
- Lec-2: Docker File vs Docker Image vs Docker Container
- Lec-3: Docker ইনস্টলেশন - Docker Desktop on Mac
- Lec-4: Docker আর্কিটেকচার Explained – Client, Daemon, Images, Containers
- Lec-5: Hello World & Ubuntu with Docker – প্রথম Docker Container!
- Lec-6: Dockerfile কীভাবে কাজ করে? – লিখে ফেলি আমাদের প্রথম Dockerfile
- Lec-7: Docker Volumes Explained – ডেটা কিভাবে সেভ করবেন Container এ

Now My remaining topics are these:

- Lec-8: Docker Networks Explained – Containers কিভাবে কথা বলে একে অপরের সাথে?
- Lec-9: Docker Compose শিখুন – Multiple Containers সহজে Run করুন
- Lec-10: Docker Hub & Private Registry – Image Upload এবং Pull করার উপায়
- Lec-11: Environment Variables in Docker – Config Manage করার Best Practice
- Lec-12: Docker Logs & Debugging – সমস্যা সমাধান করার সহজ উপায়
- Lec-13: Dockerfile Best Practices – Lightweight, Efficient Image তৈরি করুন
- Lec-14: Python/Node.js App Dockerize করে দেখাই – Step by Step Project
- Lec-15: React/Next.js Frontend Dockerize করা শিখি
- Lec-16: Database Dockerize করা শিখি – MySQL, PostgreSQL Use Case
- Lec-17: Docker Compose দিয়ে Full Stack App Deploy করুন – Real Project
- Lec-18: Docker ও Nginx দিয়ে Production Ready App বানানো শিখি
- Lec-19: Docker vs Podman vs VM – কোনটা কবে ব্যবহার করবেন?
- Lec-20: Intro to Docker Swarm – Multi-host Deployments in Bangla
- Lec-21: Docker Security Best Practices – Container নিরাপদ রাখুন
- Lec-22: Top 10 Docker Commands প্রতিদিনের কাজে লাগবে
- Lec-23: Docker Interview Questions – চাকরির জন্য প্রস্তুতি


---

# Lec-5: **Hello World & Ubuntu with Docker – প্রথম Docker Container!**

এই গাইডটিতে, আমরা Docker Hub থেকে "Hello World" Image কিভাবে পুল করতে হয় এবং চালাতে হয় তা শিখব।

## **ধাপ ১: Docker Hub থেকে Image পুল করা**

প্রথমে, আমাদের Docker Hub থেকে `hello-world` Image টি ডাউনলোড করতে হবে। আপনি Docker Hub এ (https://hub.docker.com/_/hello-world) দেখতে পারেন। টার্মিনালে নিম্নলিখিত কমান্ডটি চালান:

```
docker pull hello-world
```

এই কমান্ডটি Docker Hub থেকে `hello-world` Image-এর সর্বশেষ সংস্করণটি আপনার লোকাল মেশিনে ডাউনলোড করবে।

## **ধাপ ২: Container-টি চালানো**

Image টি ডাউনলোড হয়ে গেলে, আপনি নিম্নলিখিত কমান্ডটি ব্যবহার করে একটি Container চালাতে পারেন:

```
docker run hello-world
```

এই কমান্ডটি চালানোর পর, আপনি আপনার টার্মিনালে একটি বার্তা দেখতে পাবেন যা নিশ্চিত করবে যে আপনার Docker ইনস্টলেশন সঠিকভাবে কাজ করছে। আউটপুটটি অনেকটা এইরকম হবে:

```
Hello from Docker!
This message shows that your installation appears to be working correctly.

... (বাকি বার্তা) ...
```

## **ধাপ ৩: চলমান Container-গুলো দেখা**

আপনি `docker ps -a` কমান্ডটি ব্যবহার করে আপনার সিস্টেমের সমস্ত Container এর একটি তালিকা দেখতে পারেন, যার মধ্যে চলমান এবং বন্ধ থাকা উভয়ই অন্তর্ভুক্ত।

```
docker ps -a
```

আপনি আউটপুটে `hello-world` Container টি দেখতে পাবেন।

## **ধাপ ৪: Container বন্ধ করা এবং সরানো**

যেহেতু `hello-world` Container টি তার কাজ শেষ করার পরে নিজে থেকেই বন্ধ হয়ে যায়, তাই আপনাকে এটি ম্যানুয়ালি বন্ধ করতে হবে না।

আপনি যদি Container টি Remove করতে চান, প্রথমে Container আইডি বা নামটি `docker ps -a` কমান্ড দিয়ে খুঁজে বের করুন। তারপর, নিম্নলিখিত কমান্ডটি ব্যবহার করে Container টি Remove করুন:

```
docker rm <container_id_or_name>
```

## **ধাপ ৫: Container Start এবং Stop করা**

`hello-world` কন্টেইনারটি নিজে থেকেই বন্ধ হয়ে যায়, কিন্তু অন্যান্য কন্টেইনার, যেমন একটি Ubuntu কন্টেইনার, আপনি নিজে থেকে চালাতে বা বন্ধ করতে পারেন।

একটি কন্টেইনার আবার চালু করতে, তার আইডি বা নাম দিয়ে `docker start` কমান্ডটি ব্যবহার করুন:

```
docker start <container_id_or_name>
```

এবং একটি চলমান কন্টেইনার বন্ধ করতে, `docker stop` কমান্ডটি ব্যবহার করুন:

```
docker stop <container_id_or_name>
```

## **Homework**

এখন আপনার জন্য একটি ছোট কাজ। Docker Hub থেকে `ubuntu` ইমেজটি পুল করুন এবং চালান।

লিঙ্ক: https://hub.docker.com/_/ubuntu

1. প্রথমে, `ubuntu` ইমেজটি পুল করুন:
    
    ```
    docker pull ubuntu
    ```
    
2. তারপর, নিম্নলিখিত কমান্ডটি ব্যবহার করে একটি ইন্টারেক্টিভ টার্মিনাল দিয়ে Ubuntu কন্টেইনারটি চালান:
    
    ```
    docker run -it ubuntu
    ```
    
    এখানে `-it` ফ্ল্যাগটি আপনাকে কন্টেইনারের ভেতরে একটি ইন্টারেক্টিভ টার্মিনাল সেশন দেয়।
    
3. Next time again calate gele ei command use korte hobe -ai ( attatch interactive )

---


# Lec-6: **Dockerfile কীভাবে কাজ করে? – লিখে ফেলি আমাদের প্রথম Dockerfile**

Dockerfile হলো একটি টেক্সট ফাইল যেখানে আমরা আমাদের অ্যাপ্লিকেশনের জন্য একটি কাস্টম Docker ইমেজ তৈরি করার জন্য প্রয়োজনীয় সব নির্দেশনা (instructions) লিখে রাখি। Docker এই ফাইলটি পড়ে এবং সেই অনুযায়ী একটি ইমেজ তৈরি করে।

## **কেন Dockerfile ব্যবহার করবো?**

- **Automation:** Dockerfile ব্যবহার করে আমরা ইমেজ তৈরির প্রক্রিয়াটি স্বয়ংক্রিয় (automate) করতে পারি।
- **Version Control:** Dockerfile-কে আমরা আমাদের সোর্স কোডের সাথে ভার্সন কন্ট্রোল সিস্টেমে (যেমন Git) রাখতে পারি, যার ফলে আমাদের অ্যাপ্লিকেশন এনভায়রনমেন্টের ইতিহাস ট্র্যাক করা সহজ হয়।
- **Portability:** Dockerfile আমাদের অ্যাপ্লিকেশনকে যেকোনো পরিবেশে সহজে চালানোর উপযোগী করে তোলে।

## **বেসিক Dockerfile নির্দেশনা (Instructions)**

কিছু সাধারণ নির্দেশনা যা আমরা Dockerfile-এ ব্যবহার করি:

- `FROM`: আমাদের নতুন ইমেজটি কোন বেস ইমেজ (base image) থেকে তৈরি হবে তা নির্দিষ্ট করে। যেমন: `python:3.9-slim` বা `ubuntu:latest`.
- `WORKDIR`: কন্টেইনারের ভিতরে একটি ওয়ার্কিং ডিরেক্টরি সেট করে। এর পরে `RUN`, `CMD`, `COPY`, `ADD` কমান্ডগুলো এই ডিরেক্টরিতেই এক্সিকিউট হবে।
- `COPY`: হোস্ট মেশিন থেকে ফাইল বা ফোল্ডার কন্টেইনারের ফাইল সিস্টেমে কপি করে।
- `RUN`: ইমেজ তৈরির সময় কন্টেইনারের ভিতরে কোনো কমান্ড চালানোর জন্য ব্যবহৃত হয়। যেমন: প্যাকেজ ইনস্টল করা (`RUN pip install -r requirements.txt`)।
- `CMD`: কন্টেইনার চালু করার সময় ডিফল্ট কমান্ড নির্দিষ্ট করে। একটি Dockerfile-এ কেবল একটি `CMD` থাকতে পারে।

সম্পূর্ণ নির্দেশনার তালিকা এবং তাদের ব্যবহার সম্পর্কে জানতে [অফিসিয়াল Dockerfile রেফারেন্স](https://docs.docker.com/engine/reference/builder/) দেখুন।

## **উদাহরণ: একটি Python Flask ওয়েব অ্যাপ্লিকেশনের জন্য Dockerfile**

আসুন, আমরা একটি সাধারণ Python Flask ওয়েব অ্যাপ্লিকেশনের জন্য একটি Dockerfile তৈরি করি।

**আমাদের প্রজেক্ট স্ট্রাকচার:**

```
.
├── app.py
├── requirements.txt
└── Dockerfile
```

**১. `app.py` ফাইল তৈরি করুন:**

এই ফাইলটিতে আমাদের Flask অ্যাপ্লিকেশনের কোড থাকবে।

```
from flaskimport Flask
app= Flask(__name__)
@app.route("/")defread_root():return{"Hello":"Docker"}
```

**২. `requirements.txt` ফাইল তৈরি করুন:**

এই ফাইলে আমাদের অ্যাপ্লিকেশনের জন্য প্রয়োজনীয় পাইথন প্যাকেজগুলোর তালিকা থাকবে।

```
Flask
```

**৩. `Dockerfile` তৈরি করুন:**

এখন আমরা আমাদের অ্যাপ্লিকেশনের জন্য `Dockerfile` লিখব।

```python
# 1. Start with a base
# We'll use an official, lightweight Python image
FROM python:3.12.12-slim

# 2. Set the "working directory" inside the container
# This is like an empty folder for our project
WORKDIR /app

# 3. Copy requirements FIRST
# This is a cool trick for faster builds
COPY requirements.txt .

# 4. Install our app's needs (Flask)
RUN pip install -r requirements.txt

# 5. Copy the rest of our app code
COPY . .

# 6. Set an environment variable
# This tells Flask where our app is
ENV FLASK_APP=app.py

# 7. Expose the port
# Our Flask app runs on port 5000 by default
EXPOSE 5000

# 8. The final command to run the app   
# This starts the Flask server
CMD ["flask", "run", "--host=0.0.0.0"]
```

## **ইমেজ বিল্ড এবং কন্টেইনার রান**

এখন টার্মিনাল খুলে Dockerfile থাকা ডিরেক্টরিতে যান এবং নিচের কমান্ডগুলো চালান:

**১. Docker ইমেজ বিল্ড করুন:**

```
docker build -t flask-docker .
```

- `-t flask-docker`: ইমেজটির একটি নাম (`flask-docker`) এবং ট্যাগ (`latest` ডিফল্ট) সেট করে। Calile docker build -t flask-docker:v1 . eivabeo dite partam
- `.`: বর্তমান ডিরেক্টরিতে থাকা Dockerfile ব্যবহার করতে বলা হচ্ছে।

**২. কন্টেইনার রান করুন:**

```
docker run -p 8000:5000 flask-docker
```

- `-p 8080:5000`: হোস্টের 8080 পোর্টকে কন্টেইনারের 5000 পোর্টের সাথে ম্যাপ করে।

এখন আপনার ওয়েব ব্রাউজারে `http://localhost:5000` ভিজিট করলে `{"Hello": "Docker"}` লেখা দেখতে পাবেন।

এভাবেই আমরা Dockerfile ব্যবহার করে সহজেই আমাদের অ্যাপ্লিকেশনকে কন্টেইনারাইজ করতে পারি।

---

# Lec-7:**Docker Volumes Explained – ডেটা কিভাবে সেভ করবেন Container এ**

Docker কন্টেইনারগুলো সাধারণত ক্ষণস্থায়ী (ephemeral) হয়। এর মানে হলো, যখন একটি কন্টেইনার ডিলিট করা হয়, তখন তার ভিতরে তৈরি করা বা পরিবর্তন করা সমস্ত ডেটাও হারিয়ে যায়। এই সমস্যা সমাধানের জন্য Docker Volume ব্যবহার করা হয়।

## **কন্টেইনারে ডেটা পারসিস্টেন্সের সমস্যা**

আসুন, আমরা একটি উদাহরণ দিয়ে বিষয়টি বুঝি। আমরা একটি Ubuntu কন্টেইনার চালু করব এবং তার ভিতরে একটি ফাইল তৈরি করব।

**১. একটি Ubuntu কন্টেইনার রান করুন:**

```
docker run -it --name my-ubuntu ubuntu bash
```

- `it`: কন্টেইনারের সাথে ইন্টারেক্টিভ টার্মিনাল সেশন চালু করে।
- `-name my-ubuntu`: কন্টেইনারটির একটি নাম দেয়।

**২. কন্টেইনারের ভিতরে একটি ফাইল তৈরি করুন:**

কন্টেইনারের টার্মিনালে নিচের কমান্ডটি চালান:

```
# একটি নতুন ফাইল তৈরি করুন
echo "Hello from inside the container" > /data.txt

# ফাইলটি দেখুন
cat /data.txt
```

আপনি `Hello from inside the container` আউটপুট দেখতে পাবেন। এখন `exit` লিখে কন্টেইনার থেকে বেরিয়ে আসুন।

**৩. কন্টেইনারটি ডিলিট করুন:**

```
docker rm my-ubuntu
```

এখন আমরা যদি আবার একটি নতুন Ubuntu কন্টেইনার চালাই, তাহলে আগের তৈরি করা `data.txt` ফাইলটি আর খুঁজে পাওয়া যাবে না। কারণ কন্টেইনার ডিলিট করার সাথে সাথে তার ডেটাও ডিলিট হয়ে গেছে।

এই সমস্যার সমাধান হলো **Docker Volume**।

## **Docker Volume কী?**

Docker Volume হলো হোস্ট মেশিনের একটি বিশেষ ডিরেক্টরি যা Docker নিজে ম্যানেজ করে। এই ভলিউম আমরা এক বা একাধিক কন্টেইনারের সাথে যুক্ত (mount) করতে পারি। যখন একটি ভলিউম কন্টেইনারের সাথে মাউন্ট করা হয়, তখন সেই ভলিউমে থাকা ডেটা কন্টেইনারের ভিতরে অ্যাক্সেস করা যায় এবং কন্টেইনারের ভিতরের নির্দিষ্ট ডিরেক্টরিতে করা পরিবর্তনগুলোও সেই ভলিউমে সেভ হয়।

কন্টেইনার ডিলিট করে দিলেও ভলিউম ডিলিট হয় না, ফলে আমাদের ডেটা সুরক্ষিত থাকে।

ডেটা পারসিস্ট করার জন্য দুটি প্রধান পদ্ধতি আছে:

১. **Bind Mount:** হোস্ট মেশিনের যেকোনো ফাইল বা ফোল্ডারকে সরাসরি কন্টেইনারের সাথে মাউন্ট করা। ২. **Named Volume:** Docker দ্বারা পরিচালিত একটি ভলিউম তৈরি করে সেটি কন্টেইনারের সাথে মাউন্ট করা।

আসুন, আমরা দুটি পদ্ধতিই বিস্তারিতভাবে দেখি।

## **পদ্ধতি ১: Bind Mount**

Bind Mount ব্যবহার করে আমরা হোস্ট মেশিনের একটি নির্দিষ্ট ডিরেক্টরিকে কন্টেইনারের একটি ডিরেক্টরির সাথে সরাসরি যুক্ত করতে পারি।

**১. হোস্ট মেশিনে একটি ডিরেক্টরি তৈরি করুন:**

আপনার ডেস্কটপে `docker-shared-folder` নামে একটি ফোল্ডার তৈরি করুন এবং তার ভিতরে একটি ফাইল রাখুন।

```
# ডেস্কটপে একটি ডিরেক্টরি তৈরি করুন
mkdir ~/Desktop/docker-shared-folder

# সেই ডিরেক্টরিতে একটি ফাইল তৈরি করুন
echo "Data from host machine" > ~/Desktop/docker-shared-folder/host_file.txt
```

**২. Bind Mount সহ কন্টেইনার রান করুন:**

এখন আমরা একটি কন্টেইনার রান করব এবং হোস্টের `~/Desktop/docker-shared-folder` ডিরেক্টরিকে কন্টেইনারের `/app/data` ডিরেক্টরির সাথে মাউন্ট করব।

```
docker run -it --name my-bound-container -v ~/Desktop/docker-shared-folder:/app/data ubuntu bash
```

- `v ~/Desktop/docker-shared-folder:/app/data`: এখানে `v` ফ্ল্যাগটি ভলিউম মাউন্ট করার জন্য ব্যবহৃত হয়।
    - `~/Desktop/docker-shared-folder`: এটি আপনার ডেস্কটপে থাকা ফোল্ডারের পাথ।
    - `/app/data`: এটি কন্টেইনারের ভিতরের ডিরেক্টরি যেখানে হোস্টের ফোল্ডারটি মাউন্ট হবে।
    - `:`: এটি হোস্ট পাথ এবং কন্টেইনার পাথের মধ্যে বিভাজক হিসেবে কাজ করে।

**৩. ডেটা পরীক্ষা করুন:**

কন্টেইনারের টার্মিনালে নিচের কমান্ডগুলো চালান:

```
# কন্টেইনারের মাউন্টেড ডিরেক্টরিতে যান
cd /app/data

# ফাইলগুলো দেখুন
ls
```

আপনি `host_file.txt` ফাইলটি দেখতে পাবেন। এখন কন্টেইনারের ভিতর থেকে একটি নতুন ফাইল তৈরি করুন:

```
echo "Data from container" > container_file.txt
ls
```

এখন `container_file.txt` ফাইলটিও দেখা যাবে। `exit` লিখে বেরিয়ে আসুন।

এবার আপনার হোস্ট মেশিনের `my-app-data` ফোল্ডারে দেখুন, `container_file.txt` ফাইলটি সেখানেও তৈরি হয়ে গেছে।

এভাবে Bind Mount ব্যবহার করে হোস্ট এবং কন্টেইনারের মধ্যে ডেটা শেয়ার করা যায় এবং ডেটা পারসিস্ট করা যায়।

## **পদ্ধতি ২: Named Volume**

Named Volume হলো Docker দ্বারা পরিচালিত ভলিউম। এক্ষেত্রে আমরা Docker-কে একটি ভলিউম তৈরি করতে বলি এবং Docker তার নিজস্ব স্টোরেজ লোকেশনে সেই ভলিউম ম্যানেজ করে। এটি Bind Mount-এর চেয়ে বেশি নিরাপদ এবং ফ্লেক্সিবল।

**১. একটি Named Volume তৈরি করুন:**

```
docker volume create my-data-volume
```

এই কমান্ডটি `my-data-volume` নামে একটি ভলিউম তৈরি করবে।

**২. Named Volume সহ কন্টেইনার রান করুন:**

এখন আমরা এই ভলিউমটি একটি কন্টেইনারের সাথে মাউন্ট করব।

```
docker run -it --name my-volume-container -v my-data-volume:/app/data ubuntu bash
```

- `v my-data-volume:/app/data`: এখানে আমরা হোস্টের পাথের পরিবর্তে ভলিউমের নাম (`my-data-volume`) ব্যবহার করেছি।

**৩. ডেটা পরীক্ষা করুন:**

কন্টেইনারের টার্মিনালে যান এবং একটি ফাইল তৈরি করুন:

```
cd /app/data
echo "This is saved in a named volume" > test.txt
cat test.txt
```

`exit` লিখে বেরিয়ে আসুন এবং কন্টেইনারটি ডিলিট করুন:

```
docker rm my-volume-container
```

**৪. ডেটা পুনরুদ্ধার করুন:**

এখন আমরা একটি নতুন কন্টেইনার রান করব এবং একই ভলিউম মাউন্ট করব:

```
docker run -it --name another-container -v my-data-volume:/app/data ubuntu bash
```

কন্টেইনারের টার্মিনালে গিয়ে দেখুন:

```
ls /app/data
```

আপনি `test.txt` ফাইলটি দেখতে পাবেন। এর মানে হলো, কন্টেইনার ডিলিট হয়ে গেলেও আমাদের ডেটা ভলিউমে সুরক্ষিত আছে।

**ভলিউম ম্যানেজমেন্ট:**

- **সব ভলিউম দেখুন:** `docker volume ls`
- **একটি ভলিউম সম্পর্কে বিস্তারিত জানুন:** `docker volume inspect my-data-volume`
    - এই কমান্ডটি ভলিউম সম্পর্কে বিস্তারিত তথ্য দেখাবে, যার মধ্যে `Mountpoint` একটি গুরুত্বপূর্ণ অংশ। `Mountpoint` হলো হোস্ট মেশিনের সেই ফিজিক্যাল পাথ যেখানে আপনার ভলিউমের ডেটা সেভ করা হয়।
- **একটি ভলিউম ডিলিট করুন:** `docker volume rm my-data-volume` (কেবলমাত্র কোনো কন্টেইনার দ্বারা ব্যবহৃত না হলেই ডিলিট করা যাবে)

এভাবেই আমরা Docker Volume ব্যবহার করে আমাদের অ্যাপ্লিকেশনের ডেটা স্থায়ীভাবে সংরক্ষণ করতে পারি।

---

## **Lec-8 থেকে Lec-23 — আলাদা গাইড ফাইল**

নিচের লেকচারগুলো Lec-5, 6, 7-এর মতোই ধাপে ধাপে + Homework সহ আলাদা README-তে লেখা আছে:

| লেকচার | ফাইল | বিষয় |
|--------|------|--------|
| Lec-8 | [Lec-8-README.md](./Lec-8-README.md) | Docker Networks |
| Lec-9 | [Lec-9-README.md](./Lec-9-README.md) | Docker Compose |
| Lec-10 | [Lec-10-README.md](./Lec-10-README.md) | Docker Hub & Registry |
| Lec-11 | [Lec-11-README.md](./Lec-11-README.md) | Environment Variables |
| Lec-12 | [Lec-12-README.md](./Lec-12-README.md) | Logs & Debugging |
| Lec-13 | [Lec-13-README.md](./Lec-13-README.md) | Dockerfile Best Practices |
| Lec-14 | [Lec-14-README.md](./Lec-14-README.md) | Python/Node Dockerize |
| Lec-15 | [Lec-15-README.md](./Lec-15-README.md) | React/Next.js Frontend |
| Lec-16 | [Lec-16-README.md](./Lec-16-README.md) | MySQL & PostgreSQL |
| Lec-17 | [Lec-17-README.md](./Lec-17-README.md) | Full Stack Compose |
| Lec-18 | [Lec-18-README.md](./Lec-18-README.md) | Docker + Nginx Production |
| Lec-19 | [Lec-19-README.md](./Lec-19-README.md) | Docker vs Podman vs VM |
| Lec-20 | [Lec-20-README.md](./Lec-20-README.md) | Docker Swarm |
| Lec-21 | [Lec-21-README.md](./Lec-21-README.md) | Security Best Practices |
| Lec-22 | [Lec-22-README.md](./Lec-22-README.md) | Top 10 Commands |
| Lec-23 | [Lec-23-README.md](./Lec-23-README.md) | Interview Questions |