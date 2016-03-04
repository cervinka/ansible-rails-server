# Prepare server for ansible management

Copy ssh key to servers: `ssh-copy-id root@SERVER_IP`.

Install needed packages on servers:

```
apt-get update
apt-get install sudo
apt-get install python
```

# Set locales on debian jessie

E.g. for czech locales:

* uncomment `cs_CZ....` in `/etc/locale.gen`
* set `LC_ALL="cs_CZ.utf8"` in `/etc/environment`
* generate locale: `locale-gen`



