# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8-slim

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

ARG APP_USER_NAME
ARG APP_UID
ARG APP_GID

#Set the locale
RUN apt update && apt dist-upgrade -y
RUN apt install -y locales libc-bin locales-all
RUN apt-get install -y build-essential libssl-dev libffi-dev python-dev
RUN apt-get install -y default-mysql-client libmariadb-dev-compat libmariadb-dev 

RUN pip install pipenv

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

# Install pip requirements
# COPY requirements.txt .
# RUN pip install wheel
# RUN python -m pip install -r requirements.txt -U
ADD Pipfile.lock ./
ADD Pipfile ./

RUN pipenv install --system

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u $UID --disabled-password --gecos "" $USER_NAME && chown -R $USER_NAME /home/$USER_NAME

WORKDIR /home/$USER_NAME
# COPY ./app /home/$USER_NAME

# RUN chown -R $USER_NAME:$USER_NAME /home/$USER_NAME
USER $USER_NAME
# RUN mkdir /home/$USER_NAME/templates
# RUN mkdir /home/$USER_NAME/outputs

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug

CMD [ "python", "main.py" ]
