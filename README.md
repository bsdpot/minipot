# minipot

This project is a collection of configuration files that allows to emulate a nomad cluster in one server/VM
It's like minikube, but it' for FreeBSD, and based on pot and nomad.

## A service mesh based on FreeBSD

minipot will install everything you need to run a single-node service mesh.
This **NOT** meant to be use for production, but to easily have all the service already configured on one node and to play with it.

### The components

minipot is based on pot and nomad:
* pot is a jail framework, that allows you to create and import jail images.
* nomad is a container orchestrator
Additionally, there are other applications:
* consul: a service discovery application, it's needed to work with nomad. In consul, you can see all the services running in your mesh, where they are running and their health status
* traefik: the http proxy/loadbalancer. traefik read the service catalag provided by consul and make all the services avaialable.

## How to install minipot

The easiest way is to install the package:
```console
pkg install minipot
```
The package will install all the needed software and the configuration files.
`pot` has to be configured, before to run the minipot initialization. To be more precise, its configuration file (`/usr/local/etc/pot/pot.conf`) needs your attention. If you have trouble to configure it, please refer to the [`pot` installation guide](https://github.com/pizzamig/pot/blob/master/share/doc/pot/Installation.md)

If you are already using nomad, traefik or consul, their configuration files will be copied using the suffix `.bkp`.

Once you are ready, the init script will conclude the installation process:
```console
minipot-init
```
This script will modify your `/etc/rc.conf` to add the last pieces of configuration

**NOTE** If your machine has 2 routable IP addresses, then you have to specify which address should be used to make your services available, for instance:
```console
minipot-init -i 192.168.0.1
```

In order to show resource usage to nomad, `pot` needs to activate the resource limits framework, via a loader tunable. You can check if it's active via the command:
```console
sysctl kern.racct.enable
```
If the output is `0`, then you need to modify the `/boot/loader.conf` file and reboot.
If the output is `1`, you are ready to go.

## How to start minipot
If you had to reboot your system, you can skip to the next section.
If you didn't reboot your system, you can use an additional script, to start everything you need:
```console
minipot-start
```

This script will:
* restart syslogd (to manage the new log files)
* restart crond (to manage new cron entries)
* start consul
* start nomad
* start traefik

**NOTE** If you have issue with consul, try to invoke it as
```
consul agent
```
and read the output. If the deamon fails to start, no output will be written to the log.
## Run the example
In the minipot examples folder (`/usr/local/share/examples/minipot`), you can find a simple example you can use to deploy a nginx instance on your minipot.

```console
cd /usr/local/share/examples/minipot
nomad run nginx.job
```

## A bit of diagnostic

At port 8500, you can reach the consul web user interface.
At port 4646, you can reach the nomad web user interface.
At port 9002, you can reach the traefik web use interface.

In consul or in nomad you can see at which address/port your nginx instance is running.
The service is named `hello-web`.
The nomad job is called `nginx-minipot`.

`traefik` is listening on port 8080 to route http traffic to service registered in consul, depending on the host header.
You can use the following command line to reach your nginx instance via traefik:
``` console
curl -H 'host: hello-web.minipot' 127.0.0.1:8080
```

### Log files

Every component has its own log file:
* `/var/log/consul/consul.log` is the consul log file (uses syslogd)
* `/var/log/nomad/nomad.log` is the nomad log file (uses syslogd)
* `/var/log/traefik.log` is the traefik error log file
* `/var/log/traefik-access.log` is the traefik access log file

minipot is already configured to do a log file rotation.

## Troubleshooting

If you shutdown the machine without stopping the nomad jobs, it can happen that nomad will have some difficulties restarting.
If nomad won't restart, you can delete its temporary database removing the folder `/var/tmp/nomad`

