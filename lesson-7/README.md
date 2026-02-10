# Lesson 7 — AWS EKS Infrastructure & Django Deployment with Helm

## Опис
У цьому проєкті реалізовано повний цикл розгортання інфраструктури та застосунку: від створення мережі та кластера EKS за допомогою Terraform до деплою Django за допомогою Helm з налаштованим автоскейлінгом (HPA).

Основні компоненти:
Infrastructure (Terraform): VPC, S3 Backend, ECR, EKS Cluster.

Application (Helm): Django Deployment, Service (LoadBalancer), ConfigMap, HPA.

---

## Структура проєкту

```text
lesson-7/
├── backend.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── s3-backend/
│   │   ├── s3.tf
│   │   ├── dynamodb.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── vpc/
│   │   ├── vpc.tf
│   │   ├── outputs.tf
│   │   ├── routes.tf
│   │   └── variables.tf
│   ├── eks/
│   │   ├── eks.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── ecr/
│       ├── ecr.tf
│       ├── variables.tf
│       └── outputs.tf
├── django-chart/
│   ├── templates/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── configmap.yaml
│   │   └── hpa.yaml
│   ├── Chart.yaml
│   └── values.yaml 
├── README.md
└──.gitignore 

```

## Аутентифікація в AWS

Terraform використовує облікові дані AWS, що збережені локально у файлах:
* `~/.aws/credentials`
* `~/.aws/config`

Щоб перевірити, під яким користувачем ви працюєте, виконайте:
```bash
aws sts get-caller-identity
```

## Як запустити

1. Ініціалізація
Завантаження провайдерів та ініціалізація backend-частини (S3/DynamoDB).

```bash
terraform init
```

2. Перевірка плану
Перегляд списку ресурсів, які будуть створені в AWS.

```bash
terraform plan
```

3. Створення інфраструктури
Застосування конфігурації.

```bash
terraform apply
```

Для підтвердження необхідно ввести: yes

## Outputs (Результати)
Після успішного виконання команди apply ви отримаєте:

Назву S3 bucket для зберігання стану.

Ім'я DynamoDB таблиці для блокування.

URL ECR репозиторію для пушу ваших Docker-образів.


## Робота з Docker та ECR
Збірка образу (виконується в папці з Dockerfile) та відправка в AWS:

Логін в ECR
```bash
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.eu-west-2.amazonaws.com
```

Збірка та Пуш
```bash
docker build -t django-app .
docker tag django-app:latest <ecr_repository_url>:latest
docker push <ecr_repository_url>:latest
```

## Розгортання через Helm
Перейдіть у папку з чартом та виконайте встановлення:

```bash
cd charts/django-app
helm install my-django .
```

## Перевірка роботи
Щоб перевірити статус розгорнутих ресурсів, використовуйте:

```bash
kubectl get pods     # Має бути 2/2 Running
kubectl get hpa      # Перевірка статусу автоскейлера
kubectl get svc      # Отримання EXTERNAL-IP для доступу до сайту
```

## Видалення ресурсів
Щоб повністю видалити всю створену інфраструктуру та уникнути зайвих витрат:

```bash
helm uninstall my-django
terraform destroy
```