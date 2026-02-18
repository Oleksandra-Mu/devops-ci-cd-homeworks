# Lesson 8-9 — AWS EKS Infrastructure & Django Deployment with Helm

## Опис
У цьому проєкті реалізовано повний цикл розгортання інфраструктури та застосунку: від створення мережі та кластера EKS за допомогою Terraform до автоматизованого деплою Django за допомогою Jenkins та Argo CD.

Основні компоненти:
Infrastructure (Terraform): VPC, S3 Backend, ECR, EKS Cluster.

Application (Helm): Django Deployment, Service (LoadBalancer), ConfigMap, HPA.

---

## Структура проєкту

```text
.
├── manage.py            # Точка входу Django
├── goit/                # Налаштування проєкту (settings.py, urls.py)
├── Dockerfile           # Інструкції для збірки образу
├── Jenkinsfile          # Пайплайн автоматизації (CI)
├── requirements.txt     # Залежності Python
├── main.tf              # Основний файл Terraform
├── lesson-7/
│   ├── django-chart/    # Helm-чарт для деплою (CD)
│   │   ├── values.yaml  # Конфігурація застосунку та тег образу
│   │   └── templates/   # Маніфести Kubernetes
│   └── modules/         # Модулі інфраструктури (VPC, EKS, ECR, S3)
└── README.md

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

##Налаштування доступу до кластера
```bash
aws eks update-kubeconfig --region eu-west-2 --name <cluster_name>
```

##Перевірка Jenkins
```bash
kubectl get svc -n jenkins jenkins
```
Відкрити http://<EXTERNAL-IP> → Увійти → Натиснути django-ci-cd → Build Now

##Перевірка ArgoCD
```bash
kubectl get svc -n argocd argo-cd-argocd-server
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
Відкрити https://<EXTERNAL-IP> → Перевірити django-app: Synced, Healthy

##Доступ до застосунку
```bash
kubectl get svc -n default django-app-django
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
terraform destroy
```

##Screenshots
!(images/Screenshot%202026-02-18%20191036.png)
!(images/Screenshot%202026-02-18%20191125.png)
!(images/Screenshot%202026-02-18%20191139.png)