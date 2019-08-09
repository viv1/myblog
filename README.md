# MyBlog

This is the source code for my blog.


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

docker run -p 8000:8000 -itd dev_app:latest


// NOTE: if production, use local_settings_prod.py

// NOTE: the local_settings.py is stored separately and hidden, only accessible by the owner, since it contains sensitive information.
```

4. If not using Dockerfile directly, can follow the steps inside it as follows: 



```
//start a docker container with ubuntu base image, and log into it:
docker run -p 8000:8000 -itd ubuntu:18.04
// seems like "-it" is required, o/w container stops right away

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
```

-----------------

# TROUBLESHOOTING:

1. `pip install mysqlclient==1.4.2.post1` gives `mysql_config not found`.

    Follow all 3:

    1. [Solution A](https://stackoverflow.com/questions/7475223/mysql-config-not-found-when-installing-mysqldb-python-interface)

    2. [Solution B](https://stackoverflow.com/questions/22571848/debugging-the-error-gcc-error-x86-64-linux-gnu-gcc-no-such-file-or-directory)

    3. [Solution C](https://stackoverflow.com/questions/21530577/fatal-error-python-h-no-such-file-or-directory)

2. `source not found` when activating virtualenv: `source venv/bin/activate`

    [Solution](https://stackoverflow.com/questions/20635472/using-the-run-instruction-in-a-dockerfile-with-source-does-not-work)
