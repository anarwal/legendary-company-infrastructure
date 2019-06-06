#!/bin/bash

ssh -A -t centos@$BASTION_IP ssh centos@GITLAB_PRIVATE_IP

sudo yum install postgresql
psql -d gitlabhq_production -h <POSTGRES_RDS_ENDPOINT> -U gitlab -W

> SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE datname = current_database() AND pid <> pg_backend_pid();

sudo gitlab-ctl stop sidekiq && sudo gitlab-ctl stop unicorn && sudo gitlab-ctl stop gitlab-monitor && sudo gitlab-ctl stop alertmanager && sudo gitlab-ctl stop gitlab-workhorse && sudo gitlab-ctl stop logrotate && sudo gitlab-ctl stop nginx && sudo gitlab-ctl stop node-exporter && sudo gitlab-ctl stop prometheus
sudo DISABLE_DATABASE_ENVIRONMENT_CHECK=1 gitlab-rake gitlab:setup --trace
sudo gitlab-ctl start sidekiq && sudo gitlab-ctl start unicorn && sudo gitlab-ctl start gitlab-monitor && sudo gitlab-ctl start alertmanager && sudo gitlab-ctl start gitlab-workhorse && sudo gitlab-ctl start logrotate && sudo gitlab-ctl start nginx && sudo gitlab-ctl start node-exporter && sudo gitlab-ctl start prometheus