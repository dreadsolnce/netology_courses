kubectl apply -f /home/ubuntu/app.yml
echo "Пауза в 70 секунд на ожидание поднятия всех контейнеров"
sleep 70
echo "Перезагрузка nginx"
sudo nginx -s reload
echo "Копируем базу данных в подконтейнер mysql"
kubectl -n app get pods | grep mysql | cut -d' ' -f1 | xargs -I {} kubectl -n app cp /home/ubuntu/animals.sql {}:/tmp/animals.sql
echo "Перед импортом показываю статус контейнеров"
kubectl -n app get pods
echo "Импортируем базу данных в mysql"
kubectl -n app get pods | grep mysql | cut -d' ' -f1 | xargs -I {} kubectl -n app exec pods/{} -- /bin/bash -c "cat /tmp/animals.sql | mysql -u mysql -p'mysql' mysql"
