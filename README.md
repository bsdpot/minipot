# mini-pot

This project is a collection of configuration files that allows to emulate a nomad cluster in one server/VM
It's a FreeBSD nomad-pot version of minikube

## How to use it

* install the packages
* copy the configuration files
* run the bootstrap script
* change the IP in the nomad configuration file and add the consul client IP via sysrc
* enable and start the services

## Plan for the future

The first 3 steps should be performed by the minipot package
The IP step can maybe performed by another script

Then, the last step, can be done by another script, validating the configuration files
