echo "Добавление переменных окружения для базы данных"
echo "export db_host=${db_host}" >> ~/.bashrc
echo "export db_user=${db_user}" >> ~/.bashrc
echo "export db_password=${db_password}" >> ~/.bashrc
echo "export db_name=${db_name}" >> ~/.bashrc
echo "export mysql_root_password=${mysql_root_password}" >> ~/.bashrc

echo "Создаем namespace под наш проект"
kubectl create namespace app

echo "Создаем секрет mysqlsecret из шаблона"
envsubst < /home/ubuntu/mysqlsecret.yaml.tmpl | kubectl apply -f -

echo "Создаем ConfigMap с файлом дампа базы данных первоначального импорта в mysql"
kubectl -n app create configmap mysql-init-sql --from-file=/home/ubuntu/animals.sql

echo "Деплоим наше приложение"
kubectl apply -f /home/ubuntu/app.yml

echo "Проверяем готовность контейнера mysql"
while [ "$(kubectl -n app get pods | grep mysql | cut -d' ' -f15)" != "Running" ]
do
  echo "Контейнер mysql еще не запущен!"
  sleep 10
done

echo "Перезагрузка nginx"
sudo nginx -s reload

#echo "Копируем базу данных в подконтейнер mysql"
#kubectl -n app get pods | grep mysql | cut -d' ' -f1 | xargs -I {} kubectl -n app cp /home/ubuntu/animals.sql {}:/tmp/animals.sql

echo "Статус состояния контейнеров"
kubectl -n app get pods
