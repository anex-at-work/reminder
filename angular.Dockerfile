FROM node:10.1
MAINTAINER anex.work@gmail.com

RUN apt-get update && apt-get install supervisor -y && mkdir -p /var/log/supervisor && mkdir /home/frontend

COPY ./frontend /home/frontend

RUN cd /home/frontend && npm install && chmod +x /home/frontend/run.sh && chmod +x /home/frontend/run.sh

ADD ./assets/supervisor.conf /etc/supervisor.conf
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
WORKDIR /home/frontend
