#!/bin/bash

execute_executables() {
  local folder="$1"
  if [ -d "$folder" ]; then
    for script in "$folder"/*; do
      if [ -x "$script" ] && [ ! -d "$script" ]; then
        contador=$((contador + 1))
        echo -e "\033[1;34m→\033[0m $contador - Executando script em: $script"
        "$script"
      fi
    done
  fi
}

folder_scripts=""
disable=false
debug=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --folder-scripts=*)
      folder_scripts="${1#*=}"
      shift
      ;;
    --disable)
      disable=true
      shift
      ;;
    --debug)
      debug=true
      shift
      ;;
    *)
      echo "Parâmetro inválido: $1"
      exit 1
      ;;
  esac
done

if [ -z "$folder_scripts" ]; then
  echo "O parâmetro --folder-scripts=<value> é obrigatório."
  exit 1
fi

if [ "$disable" = true ]; then
  echo "A execução do script foi desabilitada com o parâmetro --disable."
  exit 0
fi

cd ~/$APP_NAME/$APP_CONFIG_DIR

echo "Iniciando scripts de $folder_scripts"

find . -type d -name "$folder_scripts" | while read -r folder; do
  execute_executables "$folder"
done

if [ "$debug" = true ]; then
  echo -e "\033[1;32m✓\033[0m Modo de depuração ativado. O container permanecerá em loop."
  tail -f /dev/null
else
  echo -e "\033[1;32m✓\033[0m Fim da execução"
fi
