#!/bin/sh

mkdir -p /usr/local/etc/consul.d
sysrc nomad_user="root"
sysrc nomad_env="PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/sbin:/bin"
sysrc nomad_args="-config=/usr/local/etc/nomad/server.hcl"
sysrc consul_enable="NO"
sysrc nomad_enable="NO"

mkdir -p /var/log/consul
mkdir -p /var/log/nomad
touch /var/log/consul/consul.log
touch /var/log/nomad/nomad.log
