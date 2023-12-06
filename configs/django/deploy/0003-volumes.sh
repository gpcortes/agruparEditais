#!/bin/bash

echo -e "\033[1;34m\t●\033[0m Criando diretório de Media: /${DJ_MEDIA}"
mkdir -p ~/${APP_NAME}/${DJ_MEDIA} && chown -R ${DJ_OS_UID}:${DJ_OS_GID} ~/${APP_NAME}/${DJ_MEDIA}

echo -e "\033[1;34m\t●\033[0m Criando diretório de Uploads: /${DJ_UPLOAD}"
mkdir -p ~/${APP_NAME}/${DJ_UPLOAD} && chown -R ${DJ_OS_UID}:${DJ_OS_GID} ~/${APP_NAME}/${DJ_UPLOAD}

echo -e "\033[1;34m\t●\033[0m Criando diretório de Backup: /${DJ_BACKUP}"
mkdir -p ~/${APP_NAME}/${DJ_BACKUP} && chown -R ${DJ_OS_UID}:${DJ_OS_GID} ~/${APP_NAME}/${DJ_BACKUP}

echo -e "\033[1;34m\t●\033[0m Criando diretório de logs: /${DJ_LOG}"
mkdir -p ~/${APP_NAME}/${DJ_LOG} && chown -R ${DJ_OS_UID}:${DJ_OS_GID} ~/${APP_NAME}/${DJ_LOG}

