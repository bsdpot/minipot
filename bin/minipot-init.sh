#!/bin/sh

print_syntax ()
{
	echo "Syntax: $0 -i IPADDRESS"
	echo "Please use the IP address of the machine where minipot is supposed to run"
}

# $1 the IP address
_inject_ip()
{
	local ip="$1"
	# configure consul
	sysrc consul_enable="-advertise $ip"
	# configure traefik
	sed -i '' -e "s/[:blank:]*address = \".*:8080\"$/    address = \"$ip:8080\"/" /usr/local/etc/traefik.toml
	sed -i '' -e "s/[:blank:]*address = \".*:9002\"$/    address = \"$ip:9002\"/" /usr/local/etc/traefik.toml
}

if [ "$#" -lt 2 ]; then
	print_syntax
	exit 1
fi

while getopts :i:h arg; do
	case $arg in
		h)
			print_syntax
			exit 0
			;;
		i)
			ip="$OPTARG"
			;;
		?)
			print_syntax
			exit 1
			;;
	esac
done

if [ -z "$ip" ]; then
	print_syntax
	exit 1
fi

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
