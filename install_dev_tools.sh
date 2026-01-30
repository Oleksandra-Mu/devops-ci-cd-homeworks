#!/bin/bash

set -e

echo "Початок встановлення DevOps-інструментів"

# -----------------------------
# Docker
# -----------------------------

if command -v docker >/dev/null 2>&1; then
    echo "Docker вже встановлений"
else
    echo "Встановлення Docker..."
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg lsb-release

    curl -fsSL https://get.docker.com | sudo sh
    sudo usermod -aG docker $USER

    echo "Docker встановлено"
fi

# -----------------------------
# Docker Compose
# -----------------------------

if command -v docker-compose >/dev/null 2>&1; then
    echo "Docker Compose вже встановлений"
else
    echo "Встановлення Docker Compose..."
    sudo apt install -y docker-compose
    echo "Docker Compose встановлено"
fi

# -----------------------------
# Python 3.9+ і pip
# -----------------------------
if command -v python3 >/dev/null 2>&1; then
    PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
    echo "Знайдено Python версії $PYTHON_VERSION"
else
    PYTHON_VERSION="0"
fi

REQUIRED_VERSION="3.9"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
    echo "Python $PYTHON_VERSION відповідає вимогам"
else
    echo "Встановлення Python та pip..."
    sudo apt update
    sudo apt install -y python3 python3-pip
fi

# pip
if ! command -v pip3 >/dev/null 2>&1; then
    echo "Встановлення pip..."
    sudo apt install -y python3-pip
else
    echo "pip вже встановлений"
fi


# -----------------------------
# Virtualenv + Django
# -----------------------------

VENV_DIR="$HOME/django_venv"

if [ -d "$VENV_DIR" ]; then
    echo "Virtualenv вже існує: $VENV_DIR"
else
    echo "Створення virtualenv..."
    sudo apt install -y python3-venv
    python3 -m venv "$VENV_DIR"
    echo "Virtualenv створено"
fi

# Активуємо venv
source "$VENV_DIR/bin/activate"

if python -m django --version >/dev/null 2>&1; then
    DJANGO_VERSION=$(python -m django --version)
    echo "Django вже встановлений (версія $DJANGO_VERSION)"
else
    echo "Встановлення Django в virtualenv..."
    pip install django
    echo "Django встановлено"
fi

deactivate

echo "Всі інструменти встановлені!"

