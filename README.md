Here’s a professional and attractive `README.md` for your GitHub project based on the workflow you described:

---

# 🐳 Django + MySQL Dockerized Setup

This project demonstrates how to run a **Django application** with a **MySQL database** in Docker containers. It also covers **database persistence** using Docker volumes and how to connect Django to MySQL.

---

## 📌 Features

* 🚀 Fully containerized Django app & MySQL
* 🛠 Automatic migrations on startup
* 💾 Persistent MySQL data storage
* 📡 Networked containers for communication
* 🐙 Easy setup using Docker commands

---

## 📂 Project Structure

```
.
my-notes-app/
├── api/ # Django REST API
├── mynotes/ # React frontend
├── notesapp/ # Django project settings
├── nginx/ # Nginx configuration
├── database/ # Database container setup
├── staticfiles/ # Static assets for Django
├── Dockerfile # Backend Dockerfile
├── requirements.txt
└── Jenkinsfile # CI/CD pipeline
```

---

## ⚙️ Prerequisites

Make sure you have:

* [Docker](https://docs.docker.com/get-docker/) installed
* [Docker Compose](https://docs.docker.com/compose/) (optional but recommended)
* Basic understanding of Django & MySQL

---

## 🚀 Setup Instructions

### 1️⃣ Create a Docker Network

```bash
docker network create my-web
```

---

### 2️⃣ Run MySQL Container

```bash
docker run -d \
  --name my-db \
  --network my-web \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=test \
  -p 3306:3306 \
  -v /home/hello/Desktop/New_folder:/var/lib/mysql \
  my-sql
```

**Notes:**

* `MYSQL_DATABASE=test` → Creates an empty database named `test`.
* The volume `/home/hello/Desktop/New_folder:/var/lib/mysql` stores MySQL data for persistence.

---

### 3️⃣ Build and Run Django Container

```bash
docker build -t my-django-app .
```

```bash
docker run -d \
  --name my-django \
  --network my-web \
  -p 8000:8000 \
  -e DB_NAME=test \
  -e DB_USER=root \
  -e DB_PASSWORD=root \
  -e DB_HOST=my-db \
  my-django-app
```

---

## 📜 `entrypoint.sh` Explanation

```bash
#!/bin/bash
set -e

echo "Running migrations..."
python manage.py makemigrations
python manage.py migrate

exec "$@"
```

* **`makemigrations`** → Prepares database migration files based on Django models.
* **`migrate`** → Applies those migrations to the MySQL database.
* This ensures the database schema matches your Django app **before** the server starts.

---

## 💾 Data Persistence

We are mounting:

```
/home/hello/Desktop/New_folder:/var/lib/mysql
```

This means MySQL data is stored on your host machine.
Even if the MySQL container is deleted, your data **should** remain in that folder.

**⚠️ Common Issue:**
If you start a new MySQL container **with a fresh image** but the data folder contains files from a different MySQL version or configuration, MySQL might fail or overwrite the data.

---

## 🧪 Testing Data Persistence

1. Create a record in your Django app.
2. Stop and remove the MySQL container:

   ```bash
   docker rm -f my-db
   ```
3. Recreate MySQL container using the **same volume**:

   ```bash
   docker run -d \
     --name my-db \
     --network my-web \
     -e MYSQL_ROOT_PASSWORD=root \
     -e MYSQL_DATABASE=test \
     -p 3306:3306 \
     -v /home/hello/Desktop/New_folder:/var/lib/mysql \
     my-sql
   ```
4. Your data should still be there 🎉.

---

## 🛑 Why Django Stops When MySQL Stops

* Django connects to MySQL when it starts.
* If MySQL is removed/stopped, the connection is lost, and Django may crash or fail to serve requests.
* Solution: Start MySQL first, then Django.

---

## 📸 Demo Screenshot

<img width="1916" height="951" alt="Screenshot 2025-08-12 235405" src="https://github.com/user-attachments/assets/1cbc3bff-603e-481c-b273-a0ae51c6fa44" />


---

