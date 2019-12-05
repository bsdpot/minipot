#!/bin/sh

service syslogd restart
service cron restart

service consul start
sleep 5
service nomad start
service traefik start
