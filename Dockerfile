FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install -y git python3.6 libmysqlclient-dev python3-dev gcc virtualenv python3-pip curl

RUN cd /usr/src && git clone https://github.com/viv1/myblog.git
# The effect of the cd only lasts for the current RUN command. The next RUN will start from the current WORKDIR

WORKDIR /usr/src/myblog

# Copy local_settings.py for your environment (dev/prod from the private github repo)
ARG GITHUB_AUTH_TOKEN
ARG GITHUB_LOCAL_SETTINGS_FILE_NAME
RUN curl -u "viv1:$GITHUB_AUTH_TOKEN" -L -H 'Accept: application/vnd.github.v3.raw' "https://api.github.com/repos/viv1/myblog_localsettings/contents/$GITHUB_LOCAL_SETTINGS_FILE_NAME" > myblog/local_settings.py

SHELL ["/bin/bash", "-c"]
RUN virtualenv venv --python=python3
RUN source venv/bin/activate

RUN python3 -m pip install -r requirements.txt

EXPOSE 8000
# https://stackoverflow.com/questions/22111060/what-is-the-difference-between-expose-and-publish-in-docker
