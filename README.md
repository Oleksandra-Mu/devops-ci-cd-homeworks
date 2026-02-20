# RDS Module

## Приклад використання

```hcl
module "rds" {
  source = "./modules/rds"

  name                       = "myapp-db"
  use_aurora                 = true
  aurora_instance_count      = 2

  # --- Aurora-only ---
  engine_cluster             = "aurora-postgresql"
  engine_version_cluster     = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"
  

  # --- RDS-only ---
  engine                     = "postgres"
  engine_version             = "17.2"
  parameter_group_family_rds = "postgres17"

  # Common
  instance_class             = "db.t3.medium"
  allocated_storage          = 20
  db_name                    = "myapp"
  username                   = var.db_username
  password                   = var.db_password
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = true
  vpc_id                     = module.vpc.vpc_id
  multi_az                   = true
  backup_retention_period    = 7
  parameters = {
    max_connections              = "200"
    log_min_duration_statement   = "500"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

## Змінні

| Змінна | Тип | Default | Опис |
|--------|-----|---------|------|
| `name` | string | - | Назва RDS інстансу або Aurora кластера |
| `use_aurora` | bool | false | Використовувати Aurora (true) чи стандартну RDS (false) |
| `engine` | string | postgres | БД engine (для RDS) |
| `engine_cluster` | string | aurora-postgresql | БД engine (для Aurora) |
| `engine_version` | string | 14.7 | Версія engine (для RDS) |
| `engine_version_cluster` | string | 15.3 | Версія engine (для Aurora) |
| `instance_class` | string | db.t3.micro | Тип EC2 інстансу (db.t3.micro, db.t3.medium, db.t3.large) |
| `allocated_storage` | number | 20 | Розмір диска у GB (для RDS) |
| `db_name` | string | - | Ім'я бази даних для створення |
| `username` | string | - | Мастер-користувач БД |
| `password` | string (sensitive) | - | Пароль мастер-користувача (встановити у rds-secrets.tfvars!) |
| `vpc_id` | string | - | ID VPC для розміщення БД |
| `subnet_private_ids` | list(string) | - | IDs приватних підмереж |
| `subnet_public_ids` | list(string) | - | IDs публічних підмереж |
| `publicly_accessible` | bool | false | Дозволити публічний доступ до БД |
| `multi_az` | bool | false | Включити Multi-AZ (high availability) |
| `backup_retention_period` | number | 7 | Період зберігання backup (дні) |
| `aurora_instance_count` | number | 2 | Кількість інстансів в Aurora кластері |
| `aurora_replica_count` | number | 1 | Кількість read-only реплік в Aurora |
| `parameters` | map(string) | {} | PostgreSQL параметри (max_connections, etc.) |
| `tags` | map(string) | {} | AWS теги для ресурсів |

## Outputs (результати)

| Output | Опис |
|--------|------|
| `rds_endpoint` | Endpoint стандартної RDS (якщо use_aurora=false) |
| `rds_address` | IP адреса RDS інстансу |
| `rds_port` | Порт для підключення (5432 для PostgreSQL) |
| `aurora_cluster_endpoint` | Endpoint Aurora для запису (writer) |
| `aurora_reader_endpoint` | Endpoint Aurora для читання (load-balanced) |
| `aurora_cluster_port` | Порт Aurora кластера (5432) |
| `db_name` | Ім'я створеної бази даних |
| `db_subnet_group_name` | Назва DB Subnet Group |
| `security_group_id` | ID Security Group для доступу до БД |

## Перемикання між RDS і Aurora

```hsl
use_aurora = false
use_aurora = true

```

## Зміна типу БД (engine)

```hsl
engine         = "postgres"
engine_version = "17.2"

```

```hsl
engine_cluster         = "aurora-postgresql"
engine_version_cluster = "15.3"

```

## Зміна класу інстансу (потужності)

```hsl
instance_class = "db.t3.medium"
```


## Screenshots
![](../images/django-web.png)
![](../images/jenkins.png)
![](../images/argo-cd.png)