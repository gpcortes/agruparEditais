FROM mcr.microsoft.com/vscode/devcontainers/python:3.8-bullseye

ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

ARG USER_NAME
ARG UID
ARG GID
ARG APPNAME


#Set the locale
RUN apt update && apt dist-upgrade -y
RUN apt install -y locales libc-bin locales-all
RUN apt-get install -y build-essential libssl-dev libffi-dev python-dev
RUN apt-get install -y default-mysql-client libmariadb-dev-compat libmariadb-dev 

RUN sed -i '/pt_BR.UTF-8/s/^#//g' /etc/locale.gen \
    && locale-gen en_US en_US.UTF-8 pt_BR pt_BR.UTF-8 \
    && dpkg-reconfigure locales \
    && update-locale LANG=pt_BR.UTF-8 LANGUAGE=pt_BR.UTF-8 LC_ALL=pt_BR.UTF-8
ENV LANG pt_BR.UTF-8  
ENV LANGUAGE pt_BR:pt  
ENV LC_ALL pt_BR.UTF-8
ENV LC_CTYPE pt_BR.UTF-8
ENV LC_TIME pt_BR.UTF-8

# RUN dpkg-reconfigure locales

# pip Update
RUN /usr/local/bin/python -m pip install --upgrade pip

ENV PIPENV_VENV_IN_PROJECT=True
ENV PIPENV_SITE_PACKAGES=True
ENV PATH="/home/$USERNAME/$APPNAME/.venv/bin:$PATH"

RUN pip install pipenv

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u $UID --disabled-password --gecos "" $USER_NAME && chown -R $USER_NAME /home/$USER_NAME

WORKDIR /home/$USER_NAME
# COPY ./app /home/$USER_NAME

USER $USER_NAME
# RUN chown -R $USER_NAME:$USER_NAME /home/$USER_NAME

CMD [ "tail", "-f", "/dev/null" ]