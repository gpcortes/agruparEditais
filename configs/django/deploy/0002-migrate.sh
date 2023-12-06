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

echo -e "\033[1;34m\t●\033[0m Executando migrações"

temp_log=$(mktemp)

django-admin migrate --pythonpath=src &> "$temp_log"
check_command_status "Ocorreram erros durante as migrações:" "Migrações executadas"

rm "$temp_log"
