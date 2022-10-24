# Дипломный практикум в YandexCloud

Выполнил: Cамохин Максим Игоревич

E-mail: scaryck@gmail.com

## Цели:

1. Зарегистрировать доменное имя (любое на ваш выбор в любой доменной зоне).
2. Подготовить инфраструктуру с помощью Terraform на базе облачного провайдера YandexCloud.
3. Настроить внешний Reverse Proxy на основе Nginx и LetsEncrypt.
4. Настроить кластер MySQL.
5. Установить WordPress.
6. Развернуть Gitlab CE и Gitlab Runner.
7. Настроить CI/CD для автоматического развёртывания приложения.
8. Настроить мониторинг инфраструктуры с помощью стека: Prometheus, Alert Manager и Grafana.

## Этапы выполнения:

### 1. Регистрация доменного имени

На [reg.ru](https://reg.ru) зарегистрирован домен `maksam.ru`.

Настроены DNS:

![img.png](https://github.com/mksamm/devops-netology-diplom/blob/master/images/diplom.PNG)

![img.png](https://github.com/mksamm/devops-netology-diplom/blob/master/images/dns.jpg)

### 2.Создание инфраструктуры

Для развертывания инфраструктуры:
- Создать облако. ID облака - в переменную `cloud_id` в файле `variables.tf` 
- Создать каталог в облаке. ID каталога - в переменную `folder_id` в файле `variables.tf`
- Создать Object Storage (bucket). Добавить имя бакета в файл `backend.conf` `bucket     = <your-bucket-name>`
- Создать сервисный аккаунт с ролью `editor`. Сгенерировать статический ключ доступа для этого аккаунта. ID и секрет ключа записать в соответствующие параметры в файл `backend.conf`: `access_key = <your-access-key>` `secret_key = <your-secret-key>`
- Указать зарезервированный IP адрес - в переменную `yc_dedicated_ip`в файле `variables.tf`
- Указать имя зарегистрированного домена - в переменную `domain_name`в файле `variables.tf`
- Получить OAuth токен по инструкции [здесь](https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token) 
- Запуск происходит в workspace `stage`

Выполняемые команды:

```
$ export TF_VAR_token=<ваш OAuth токен>
$ cd terraform
$ terraform workspace new stage
$ terraform workspace select stage 
$ terraform init -backend-config=backend.conf
$ terraform plan
$ terraform apply
```
Создан S3 bucket в YC.

![img.png](https://github.com/mksamm/devops-netology-diplom/blob/master/images/bucket.jpg)

Подготовлена инфраструктура с помощью Terraform на базе облачного провайдера YandexCloud.

![img.png](https://github.com/mksamm/devops-netology-diplom/blob/master/images/%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0.jpg)

### 3. Установка Nginx и LetsEncrypt

Выполняемые команды:

`ansible-playbook nginx.yml -i inventory/inventory.yml`

![img.png](https://github.com/mksamm/devops-netology-diplom/blob/master/images/diplom6.PNG)
___

Просмотр сертификатов:

![img.png](https://github.com/mksamm/devops-netology-diplom/blob/master/images/diplom4.PNG)

### 4.Установка кластера MySQL

`ansible-playbook mysql.yml -i inventory/inventory.yml`

Результаты работы роли:

* db01
```bash 
ubuntu@db01:~$ sudo mysql
...
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| wordpress          |
+--------------------+
5 rows in set (0.00 sec)
mysql> select host,user,password_expired,account_locked from mysql.user;
+-----------+------------------+------------------+----------------+
| host      | user             | password_expired | account_locked |
+-----------+------------------+------------------+----------------+
| %         | wordpress        | N                | N              |
| localhost | debian-sys-maint | N                | N              |
| localhost | mysql.infoschema | N                | Y              |
| localhost | mysql.session    | N                | Y              |
| localhost | mysql.sys        | N                | Y              |
| localhost | root             | N                | N              |
+-----------+------------------+------------------+----------------+
6 rows in set (0.00 sec)
mysql> show grants for wordpress;
+----------------------------------------------------------+
| Grants for wordpress@%                                   |
+----------------------------------------------------------+
| GRANT USAGE ON *.* TO `wordpress`@`%`                    |
| GRANT ALL PRIVILEGES ON `wordpress`.* TO `wordpress`@`%` |
+----------------------------------------------------------+
2 rows in set (0.00 sec)
mysql> SHOW MASTER STATUS;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000007 |  1354949 | wordpress    |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```
* db02
```bash
mysql> SHOW REPLICA STATUS\G;
*************************** 1. row ***************************
             Replica_IO_State: Waiting for source to send event
                  Source_Host: db01
                  Source_User: replica_user
                  Source_Port: 3306
                Connect_Retry: 60
              Source_Log_File: mysql-bin.000006
          Read_Source_Log_Pos: 157
               Relay_Log_File: mysql-relay-bin.000001
                Relay_Log_Pos: 4
        Relay_Source_Log_File: mysql-bin.000006
           Replica_IO_Running: Yes
          Replica_SQL_Running: Yes

```
### 5.Установка WordPress

`ansible-playbook wordpress.yml -i inventory/inventory.yml`

![img.png](https://github.com/mksamm/devops-netology-diplom/blob/master/images/Diplom9.PNG)

### 6.Установка Gitlab CE и Gitlab Runner

`ansible-playbook gitlab.yml -i inventory/inventory.yml`

![img.png](https://github.com/mksamm/devops-netology-diplom/blob/master/images/diplom5.PNG)

![img.png](https://github.com/mksamm/devops-netology-diplom/blob/master/images/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202022-10-23%20%D0%B2%2018.48.59.png)

### 7. Настроить CI/CD для автоматического развёртывания приложения.

Проверка работы пайплайна:

![img.png](https://github.com/mksamm/DIPLOM/blob/main/images/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202022-10-23%20%D0%B2%2018.47.24.png)

___

![img.png](https://github.com/mksamm/DIPLOM/blob/main/images/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202022-10-23%20%D0%B2%2020.00.22.png)

Проверим изменения на сайте WordPres:

![img.png](https://github.com/mksamm/DIPLOM/blob/main/images/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202022-10-23%20%D0%B2%2018.47.39.png)

### 8.Установка Prometheus, Alert Manager, Node Exporter и Grafana

Для данной задачи созданы роли node-exporter, prometheus, alertmanager, и grafana

![img.png](https://github.com/mksamm/DIPLOM/blob/main/images/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202022-10-23%20%D0%B2%2018.48.41.png)

![img.png](https://github.com/mksamm/DIPLOM/blob/main/images/diplom1200.jpg)

![img.png](https://github.com/mksamm/DIPLOM/blob/main/images/diplom7.PNG)

## Ссылки на ansible и terraform 

- [ansible](https://github.com/mksamm/devops-netology-diplom/tree/master/src/ansible)

- [terraform](https://github.com/mksamm/devops-netology-diplom/tree/master/src/terraform)

- [pipeline](https://github.com/mksamm/devops-netology-diplom/blob/master/src/gitlab-ci.yml)

