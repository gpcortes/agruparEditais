#!/bin/bash

function check_command_status() {
  if [ $? -ne 0 ]; then
    echo -e "\033[1;31m\t\t✗\033[0m $1"
    cat "$temp_log"
    exit 1
  else
    echo -e "\033[1;32m\t\t✓\033[0m $2"
  fi
}

cd ~/"$APP_NAME"

echo -e "\033[1;34m\t●\033[0m Instalando ambiente para deploy"

temp_log=$(mktemp)

apt update &> "$temp_log"
apt install -y build-essential libpq-dev libodbc1&> "$temp_log"
check_command_status "Ocorreram erros durante a instalação das bibliotecas de desenvolvimento:" "Bibliotecas de desenvolvimento instaladas"

pip install -U pip --root-user-action=ignore &> "$temp_log"
pip install -U pipenv --root-user-action=ignore &> "$temp_log"
check_command_status "Ocorreram erros durante a instalação do pipenv:" "Pipenv instalado"

cd ~/"$APP_NAME"

if [ ! -f Pipfile.lock ] || [ ! -s Pipfile.lock ]; then
  pipenv lock &> "$temp_log"
  chown "$APP_UID":"$APP_GID" Pipfile.lock
  check_command_status "Ocorreram erros durante a atualização do Pipfile.lock:" "Pipfile.lock atualizado"
fi

pipenv install --system &> "$temp_log"
check_command_status "Ocorreram erros durante a instalação do python system environment:" "Ambiente para deploy instalado"

rm "$temp_log"
