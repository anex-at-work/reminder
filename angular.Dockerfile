FROM node:10.1
MAINTAINER anex.work@gmail.com

RUN apt-get update && apt-get install supervisor -y && mkdir -p /var/log/supervisor
ADD ./assets/supervisor.conf /etc/supervisor.conf
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
WORKDIR /home/frontend
