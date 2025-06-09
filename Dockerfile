FROM python:3.10-slim

# Рабочая директория внутри контейнера
WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Копируем весь проект в контейнер
COPY . .

# Переходим в папку Django-проекта
WORKDIR /app/taskmanager

# Открываем порт
EXPOSE 8000

# Запускаем Django
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
