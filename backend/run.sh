#!/bin/bash
source /etc/profile.d/rvm.sh
bundle exec rake db:setup RAILS_ENV=production
bundle exec rake db:migrate RAILS_ENV=production
bundle exec puma -e production -b tcp://0.0.0.0:3000