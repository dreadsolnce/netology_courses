#!/bin/bash
# Создайте виртуальное окружение
python3 -m venv venv
source venv/bin/activate  # в Windows: venv\Scripts\activate

# Установите зависимости
pip install -r requirements.txt


# Запустите приложение
uvicorn main:app --host 0.0.0.0 --port 5000 --reload
