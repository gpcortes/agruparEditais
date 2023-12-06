ARG IMAGE_NAME
ARG IMAGE_TAG

FROM $IMAGE_NAME:$IMAGE_TAG

ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR.UTF-8
ENV LC_ALL pt_BR.UTF-8
ENV LC_CTYPE pt_BR.UTF-8
ENV LC_TIME pt_BR.UTF-8

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1
ENV PYTHONUNBUFFERED 1

ARG APP_USER_NAME
ARG APP_UID
ARG APP_GID
ARG APP_NAME

RUN adduser -u $APP_UID --disabled-password --gecos "" $APP_USER_NAME && chown -R $APP_USER_NAME /home/$APP_USER_NAME

RUN apt-get update && apt-get install git -y

RUN pip install pipenv

RUN apt install -y locales libc-bin locales-all
RUN sed -i '/pt_BR.UTF-8/s/^#//g' /etc/locale.gen \
    && locale-gen en_US en_US.UTF-8 pt_BR pt_BR.UTF-8 \
    && dpkg-reconfigure --frontend noninteractive locales \
    && update-locale LANG=pt_BR.UTF-8 LANGUAGE=pt_BR.UTF-8 LC_ALL=pt_BR.UTF-8

RUN /usr/local/bin/python -m pip install --upgrade pip

ADD Pipfile.lock ./
ADD Pipfile ./

RUN if [ -s Pipfile.lock ]; then pipenv install --system; else pipenv lock && pipenv install --system; fi

WORKDIR /home/$APP_USER_NAME/$APP_NAME
USER $APP_USER_NAME

CMD [ "python", "main.py" ]
