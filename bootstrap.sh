#!/bin/sh

mkdir -p /usr/local/etc/consul.d
sysrc nomad_user="root"
sysrc nomad_env="PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/sbin:/bin"
sysrc nomad_args="-config=/usr/local/etc/nomad/server.hcl"
sysrc consul_enable="YES"
sysrc nomad_enable="YES"
sysrc traefik_enable="YES"

mkdir -p /var/log/consul
mkdir -p /var/log/nomad
touch /var/log/consul/consul.log
touch /var/log/nomad/nomad.log
touch /var/log/traefik.log
touch /var/log/traefik-access.log
chown traefik:traefik /var/log/traefik.log
chown traefik:traefik /var/log/traefik-access.log
