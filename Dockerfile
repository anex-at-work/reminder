FROM debian:stable
LABEL maintainer="anex.work@gmail.com"
SHELL ["/bin/bash", "-c"]

RUN apt update && \
  apt install -y gnupg supervisor libpq-dev tar curl procps && \
  mkdir -p /var/log/supervisor
RUN (gpg --batch --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB || true) && \
   (gpg --batch --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB || true)
RUN curl -sSL https://get.rvm.io | /bin/bash -s stable
RUN source /etc/profile.d/rvm.sh && mkdir /home/backend && \
  rvm install ruby-2.5.3 && \
  rvm use ruby-2.5.3@reminder --create

COPY ./backend /home/backend

RUN cd /home/backend/ && source /etc/profile.d/rvm.sh && rvm use ruby-2.5.3@reminder && gem install bundle && \
  bundle install

# && bundle exec rake db:setup && bundle exec rake db:migrate

ADD ./assets/supervisor.conf /etc/supervisor.conf
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
WORKDIR /home/backend