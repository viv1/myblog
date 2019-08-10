# MyBlog

This is the source code for my blog.

# Setup instructions for DB:

1. Install mysql version 8.x
2. Login to mysql shell, and create database for blog
`create database <db_name>;`
3. Update `DATABASE` property in `myblog/settings`(or adding it to `myblog/local_settings.py`) by updating as follows:
    1. "ENGINE": "django.db.backends.mysql"
    2. "NAME": <db_name>
    3. "USER": <db_username>
    4. "PASSWORD": <db_password>
    5. "HOST": <host_ip> ....host_ip will be localhost during local development, and your hosted DB location in production. 

# Setup instructions:

1. Install docker desktop for mac using official instructions.
2. Create a docker account on hub.docker.com

Versions used:
```docker -v
> Docker version 19.03.1, build 74b1e89
docker-compose --version
> docker-compose version 1.24.1, build 4667896b
docker-machine --version
> docker-machine version 0.16.1, build cce350d7
```

3. If using Dockerfile, simply run:


```
docker build --build-arg GITHUB_AUTH_TOKEN=<token_id> --build-arg GITHUB_LOCAL_SETTINGS_FILE_NAME=local_settings_dev.py -t dev_app -f Dockerfile .

// NOTE: if production, use local_settings_prod.py

// NOTE: the local_settings.py is stored separately and hidden, only accessible by the owner, since it contains sensitive information.

docker run -p 8000:8000 -itd dev_app:latest

// get <container_id>
docker ps

//log in to the container
docker exec -it <container_id> /bin/bash

//If doing for first time, run migrations
python3 manage.py createdb --nodata      ( --noinput for default username: admin and password: password)

// start server and make it accessible from host
python3 manage.py runserver 0.0.0.0:8000
// refer: https://stackoverflow.com/questions/26423984/unable-to-connect-to-flask-app-on-docker-from-host
// and https://stackoverflow.com/questions/23639085/django-change-default-runserver-port

```

4. If not using Dockerfile directly, can follow the steps inside it as follows: 



```
//start a docker container with ubuntu base image, and log into it:
docker run -p 8000:8000 -itd ubuntu:18.04
// seems like "-it" is required, o/w container stops right away
// https://stackoverflow.com/questions/41916435/practically-what-is-the-difference-between-docker-run-dit-itd-vs-docker-run

// get container id
docker ps 
docker exec -it <container_id> /bin/bash

docker logs <container_id> 
// for checking logs, in case of error
```

Inside the docker container, 

```
// get code
cd usr/src
git clone https://github.com/viv1/myblog.git

// install platform utilities
apt-get install vim  // useful for viewing/editing files
apt-get install virtualenv
apt-get install python3

apt-get install libmysqlclient-dev // required for installing mysqlclient
apt-get install python3-dev gcc // required for installing mysqlclient


// activate virtual env, and install required python packages
virtualenv venv --python=python3
source venv/bin/activate
pip install -r requirements.txt
// or individually as below:
# pip install Django==1.11.22
# pip install Mezzanine==4.3.1
# pip install mysqlclient==1.4.2.post1

// run migrations, if doing set up for the first time
python3 manage.py createdb --nodata       ( --noinput for default username: admin and password: password)

// start server and make it accessible from host
python3 manage.py runserver 0.0.0.0:8000
// refer: https://stackoverflow.com/questions/26423984/unable-to-connect-to-flask-app-on-docker-from-host
// and https://stackoverflow.com/questions/23639085/django-change-default-runserver-port
```

5. You should then be able to browse to `<app_location>/admin/` and log in using the default account (`username: admin, password: default`). If you’d like to specify a different username and password during set up, simply exclude the --noinput option included above when running createdb.


-----------------

# TROUBLESHOOTING:

1. `pip install mysqlclient==1.4.2.post1` gives `mysql_config not found`.

    Follow all 3:

    1. [Solution A](https://stackoverflow.com/questions/7475223/mysql-config-not-found-when-installing-mysqldb-python-interface)

    2. [Solution B](https://stackoverflow.com/questions/22571848/debugging-the-error-gcc-error-x86-64-linux-gnu-gcc-no-such-file-or-directory)

    3. [Solution C](https://stackoverflow.com/questions/21530577/fatal-error-python-h-no-such-file-or-directory)

2. `source not found` when activating virtualenv: `source venv/bin/activate`

    [Solution](https://stackoverflow.com/questions/20635472/using-the-run-instruction-in-a-dockerfile-with-source-does-not-work)
