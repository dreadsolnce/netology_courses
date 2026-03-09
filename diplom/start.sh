#!/bin/bash

set -e

echo "Подгружаем переменные из файла .env"
set -o allexport
source .env
set +o allexport

echo "Запускаем основной проект"
cd main/
terraform "$1"
