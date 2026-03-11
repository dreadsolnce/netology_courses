#!/bin/bash

echo "Изменяем файл app.yml для работы с gitlab после того как он задеплоился с образом по умолчанию kolchinvladimir/app-animals:1.0.5"

sed -i "s|kolchinvladimir/app-animals:1.0.5|__IMAGE__|g" /home/ubuntu/app.yml

