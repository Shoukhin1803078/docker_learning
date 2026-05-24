From python:3.11-slim
WORKDIR /app
COPY requirements.txt .               # requirements.txt file copy kore container er app/ ('.' dot mane holo directory) ei directory te paste koro
RUN pip install -r requirements.txt 
COPY . .                              #  eikhane frist dot mane holo host machine er directory /Users/mdalamintokder/docker_learning theke sob kisu copy kore  — container er app/ ei directory te paste koro
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]  