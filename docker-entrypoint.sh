#!/bin/bash
set -e

if [ "$1" = 'web' ]; then
  rm -rf tmp/pids/*

  bundle exec rake db:migrate db:seed
  bundle exec rails server -p 3000 --binding 0.0.0.0
fi

if [ "$1" = 'worker' ]; then
  rm -rf tmp/pids/*

  bundle exec rake db:migrate

  export SCHEDULER_CONFIGURE=true
  export QUEUES=default,high_priority,low_priority 
  bundle exec rake jobs:work
fi

exec "$@"
