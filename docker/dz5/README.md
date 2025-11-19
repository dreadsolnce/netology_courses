# Описание проекта

С помощью terraform разворачивается инфраструктура в yandex облаке, с помощью ansible выполняется копирование приложения на
развёрнутую инфраструктуру в облаке, и так же с помощью ansible выполняется деплой приложения в кластере docker swarm. Весь 
процесс проходит автоматически до конечного результата без ручного участия!
В результате разворачивается одна управляющая нода и неограниченное число воркеров.

### Замечание

По факту каталог app не нужен, запуск приложения происходит c помощью одного файла compose.yaml с помощью 
docker swarm (сам образ приложения лежит в dockerhub kolchinvladimir/app:5.0.0) 

## Подготовка к запуску

1. Подготовить файл myubuntu.json (Операционные системы разворачиваются из подготовленного файла myubuntu.json, через packer.) <br>
Заполнить переменные:
    - TOKEN (IAM token yandex cloud)
    - FOLDER_ID<br>
<br>
Команда получения IAM токена: yc iam create-token<br>
FOLDER_ID: id ресурса в яндекс облаке

2. Подготовить файл terraform/personal.auto.tfvars<br>
    - Переименовать файл personal.auto.tfvars.example в personal.auto.tfvars<br>
   Заполнить переменные: cloud_id и folder_id
   Terraform для подключения к yandex облаку использует файл file("~/.ssh/id_rsa.pub") из файла local.tf
    - Для хранения файла tfstate используется хранилище s3 в yandex облаке (файл providers.tf)

## Запуск проекта:

Из каталога инициализировать terraform <br>
`terraform init`<br>
<br>Запустить проект:<br>
`trerraform apply` 
   
<img width="641" height="570" alt="Снимок экрана от 2025-10-08 18-16-20" src="https://github.com/user-attachments/assets/8e2d3bfd-3fde-4fc0-afe4-23d1f8bcef51" />

В результате выполнения команды будут созданы три виртуальные машины (одна из них управляющая нода и два воркера по умолчанию)

<img width="740" height="428" alt="Снимок экрана от 2025-10-08 18-20-38" src="https://github.com/user-attachments/assets/e9e70d5b-cd89-4611-9fd6-d8eaad12d173" />


## Результат

Перейдя в браузере по ip адресу управляющей ноды и порту 8090 мы получим следующий ответ:

http://158.160.51.197:8090/

<img width="625" height="184" alt="Снимок экрана от 2025-10-08 18-23-56" src="https://github.com/user-attachments/assets/4b7bc973-58c1-4a03-a946-77156703dc5e" />




