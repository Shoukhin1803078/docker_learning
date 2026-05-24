# Lec-19: **Docker vs Podman vs VM – কোনটা কবে ব্যবহার করবেন?**

তিনটি ভিন্ন ধারণা — অনেক সময় নতুনরা এগুলো মিশিয়ে ফেলে। এই লেকচারে **কী পার্থক্য** এবং **কখন কোনটা** সেটা স্পষ্ট করব।

---

## **Virtual Machine (VM)**

**কী:** হাইপারভাইজার (VMware, VirtualBox, cloud hypervisor) প্রতিটি VM-এ **পুরো OS** (guest kernel) চালায়।

| সুবিধা                    | অসুবিধা                |
|---------------------------|-------------------------|
| সম্পূর্ণ isolation        | ভারী — RAM/CPU বেশি     |
| ভিন্ন OS (Linux on Mac)   | Boot ধীর                |
| Strong security boundary  | Image size বড়          |

**কখন VM:** ভিন্ন OS দরকার, legacy app, kernel-level isolation, Windows on Mac full desktop।

---

## **Docker (Container)**

**কী:** হোস্টের **একই kernel** শেয়ার; process-level isolation (namespaces, cgroups)।

| সুবিধা              | অসুবিধা                          |
|---------------------|-----------------------------------|
| হালকা, দ্রুত start  | Linux-centric (Mac-এ VM layer)   |
| Image layer cache   | Full OS isolation নয় VM-এর মতো  |
| Dev/prod parity     | Root/security সাবধানে manage     |

**কখন Docker:** Microservices, CI/CD, local dev stack, cloud-native deploy (Kubernetes, ECS)।

---

## **Podman**

**কী:** Docker-এর **বিকল্প** container engine — daemon-less option, rootless focus, OCI-compatible images।

| Docker                    | Podman                          |
|---------------------------|---------------------------------|
| `dockerd` daemon          | প্রায়ই daemon-less             |
| `docker` CLI              | `podman` CLI (অনেক কমান্ড একই) |
| Docker Compose            | `podman compose`                |
| Docker Desktop ecosystem  | Red Hat / Fedora বেশি দেখা যায় |

**কখন Podman:** Rootless security policy, daemon ছাড়া চালানো, Docker license/policy issue এড়াতে।

**মনে রাখুন:** একই `Dockerfile` অনেক সময় Podman-এও build হয় (`podman build`).

---

## **তুলনা টেবিল**

| বিষয়           | VM        | Docker Container | Podman        |
|-----------------|-----------|------------------|---------------|
| Boot time       | মিনিট     | সেকেন্ড          | সেকেন্ড       |
| OS overhead     | পুরো OS   | shared kernel    | shared kernel |
| Typical size    | GB+       | MB–স几百 MB      | same as Docker|
| Isolation       | শক্তিশালী | process-level    | process-level |
| Mac dev         | Parallels | Docker Desktop   | Podman machine|

---

## **Docker Desktop on Mac — বাস্তবতা**

Mac-এ Linux kernel নেই — Docker Desktop ভিতরে একটি **ছোট Linux VM** চালায়, তার ভিতরে container। তাই “container হালকা” এখানেও সত্য, কিন্তু পুরো VM-এর মতো ভারী নয়।

---

## **কোনটা বেছে নেবেন? — সিদ্ধান্ত গাছ**

```
আপনার অ্যাপ পুরো OS / kernel দরকার?
  └─ হ্যাঁ → VM
  └─ না → Container
        └─ টিম Docker ব্যবহার করে / Compose / K8s?
              └─ হ্যাঁ → Docker (সবচেয়ে common)
              └─ Rootless / no daemon → Podman
```

---

## **Kubernetes সংক্ষেপে**

Production scale-এ **Docker/Podman** image build করে **Kubernetes** orchestrate করে — Lec-20 Swarm-এর বিকল্প/industry standard।

---

## **Homework**

1. আপনার laptop-এ `docker info` চালিয়ে OS/Architecture লিখুন।
2. (ঐচ্ছিক) Podman install করে `podman run hello-world` চেষ্টা করুন।
3. VM vs Container — ৩টি বাক্যে পার্থক্য লিখুন (বাংলায়)।
4. আপনার প্রজেক্টে কেন VM নয় Container — ৫ বুলেট লিখুন।
5. Interview-style: “Docker vs VM” — ১ মিনিটের উত্তর প্র্যাকটিস করুন (Lec-23)।

---

**পরবর্তী:** Lec-20 — Docker Swarm।
