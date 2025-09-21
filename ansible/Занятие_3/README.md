# Домашнее задание к занятию 2 «Работа с Playbook»

## Что делает playbook:

Выполняет скачивание и установку программ: clickhouse, vector и lighthouse.

## Параметры playbook:

### Переменные

#### clickhouse:

clickhouse_version:  - версия программы clickhouse<br>
clickhouse_packages: - пакеты необходимые для установки clickhouse<br>

#### vector:
vector_version:      - версия программы vector<br>

#### lighthouse:

repo_lighthouse:     - каталог с исходным кодом программы<br>
dest_lighthouse:     - каталог куда выполняется установка программы<br>

### Шаблоны

vector.j2            - конфигурационный файл программы vector<br> 
nginx.conf.j2        - конфигурационный файл веб сервера nginx для запуска программы lighthouse
