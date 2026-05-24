From python:3.11-slim
WORKDIR /app
COPY requirements.txt .                             # Copy the requirements.txt file from the current directory to the working directory in the container
RUN pip install -r requirements.txt 
COPY . .                                            # Copy all files from the current directory to the working directory in the container
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]  