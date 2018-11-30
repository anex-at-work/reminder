#!/bin/bash
bundle exec rake db:setup RAILS_ENV=production
bundle exec rake db:migrate RAILS_ENV=production
bundle exec puma -e production