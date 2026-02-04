# Lesson 5 — Terraform AWS Infrastructure

## Опис
У цьому завданні за допомогою **Terraform** було розгорнуто базову інфраструктуру в **AWS (регіон Europe)** з використанням модульного підходу.

Інфраструктура включає:
- S3 bucket для зберігання Terraform state
- DynamoDB таблицю для блокування state
- VPC з публічними та приватними сабнетами
- Internet Gateway та NAT Gateway
- ECR репозиторій для Docker-образів

---

## Структура проєкту

```text
lesson-5/
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
│   └── ecr/
│       ├── ecr.tf
│       ├── variables.tf
│       └── outputs.tf
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

## Видалення ресурсів
Щоб повністю видалити всю створену інфраструктуру та уникнути зайвих витрат:

```bash
terraform destroy
```