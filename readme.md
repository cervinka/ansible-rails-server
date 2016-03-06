
ansible-rails-server is suite of provisioning and deploy ansible scripts for Rails applications

Based on [andreychernih/railsbox](https://github.com/andreychernih/railsbox) but:

* nice web gui?: no
* flexible file structure of your project?: yes
* multiple apps per server?: yes
* well tested?: no (for now)
* support for upstart and systemd init system
* Railsbox does some app specific configuration in provision phase. I think that this configuration should go into
deploy phase so I moved those steps there.

# Requirements

If you want to provision/deploy to remote server, you will need [ansible][].

You will need [VirtualBox][] and [vagrant][] if you want to provision/deploy local virtual machine.

# What's included

## Operating systems

OS must be apt-based. For now, only ubuntu/trusty64 is tested. (you will probably need to tweak apt package versions for other distros)

[ansible-rails-server][] will create 2 scripts:

* `provision.sh` - which will install and configure all required software (apt packages, deploy user, ...)
* `deploy.sh` - which will deploy latest code from the GIT repo

## Ruby versions

It's possible to install Ruby either with [rvm][], [rbenv][] or using [brightbox apt repository][] (only for ubuntu).

## Application server

Supported servers are:

* [nginx][] and [unicorn][]
* [nginx][] and [puma][]
* [nginx][] and [passenger][]

## Databases

* PostgreSQL
* MySQL
* MongoDB
* redis

## Background jobs

* sidekiq
* resque
* delayed_job

## vim

[vim-sensible][] and [vim-rails][] are automatically installed.

# file structure

- **ansible**
    - **group_vars**
        - **all.yml** - main configuration file (select database, ruby version, background worker, ...)

            other configurations are loaded when actual host is in corresponding host group:

        - **development.yml** - customization for development environment
        - **production.yml** - customization for development environment
        - **staging.yml** - customization for development environment

    - **roles** - all ansible roles are defined here
        - **base**
        - **mysql**
        - **nginx**
        - **...**
        - **...**
    - **deploy.yml** - playbook for deploy (run from `<environment>/deploy.sh` script)
    - **site.yml** - playbook for provisioning (run from `<environment>/provision.sh` script)
- **development** - directory for development environment
    - **ansible.cfg** - basic ansible configuration for development environment
    - **Vagrantfile** - configuration for vagrant

        You can change distribution (must be apt based - e.g. 'ubuntu/trusty64') in `all.yml` config file.

        When you run `vagrant up` first time, the provisioning script is run automatically, afterwards you can
        run provisioning by `vagrant provision`

        Deployment is not handled by ansible script in development env. You should use Procfile (foreman) to
        start requied services. App is maped to virtualbox shared folder `/<app_name>` automatically.

- **production** -  directory for production environment
    - **ansible.cfg** - basic ansible configuration for production environment
    - **inventory** - here you can assign hosts to corresponding group
    - **provision.sh** - wrapper for provisiosioning playbook `site.yml` - (install apt packages, install ruby, create deploy user, ...)
    - **deploy.sh** - wrapper for `deploy.yml` playbook (create folder for app, install gem, create configs for webserver, ...)
- **staging** - like production above
        - ...
- **ssh_pubkeys** - all ssh public keys (*.pub) in this dir will be added to authorized_keys of deploy user


# Configuration

I recommend to clone this repo inside your folder with Rails application (but you can chose different location - paths are configurable).


Main configuration is in `ansible/group_vars/all.yml` (use `all.yml.example` as template). Other yml files in `ansible/group_vars` are for os-distribution and environment specific settings.

Host specific configuration files can be placed to `ansible/host_vars` folder.

Hosts are specified in `[development|staging|...]/inventory` files (use inventory.example as template). Define hosts at begin of file and place them to particular section, please dont forget place hosts to os-specific and environment-specific groups so apropriate vars are loaded.

There are example files (with .example extension) which can be used as template for your setting. Example values have string `demo` in them. Example hosts contain string `demo_srv`.

Also check if `ansible.cfg` files in `<ENVIRONMENT>` folders suit your needs.

TIP: To check, if all is set, you can check there is no file with `.example` extension and no file containing string `demo` (except this one).

# Usage

`cd` to selected environment folder (production|staging|...) and run:

 * `sh provision.sh` for server provisioning
 * `sh deploy.sh` for Rails application deploy.

    Note that agent-forwarding is excepted to be set to fetch git repository in deployment phase (maybe `ssh-add` will be sufficient).

There is also a helper script which shows you how is some variable set. Use it as `ansible-playbook -u root -i inventory ../ansible/test_vars.yml -e "variable=VARIABLE_NAME"`. Interesing VARIABLE_NAMEs are e.g. `local_rails_path`, `groups`, `path`

# Contributing

All kind of contributions are always welcomed.

# License

[ansible-rails-server][] is licensed under the [MIT license].

(C) 2016 Petr Červinka


[ansible-rails-server]: https://github.com/cervinka/ansible-rails-server
[railsbox]: http://railsbox.io/
[vagrant]: https://www.vagrantup.com/
[VirtualBox]: https://www.virtualbox.org/
[ansible]: http://www.ansible.com/
[rvm]: https://rvm.io/
[brightbox apt repository]: https://www.brightbox.com/docs/ruby/ubuntu/
[nginx]: http://nginx.org/
[puma]: http://puma.io/
[unicorn]: http://unicorn.bogomips.org/
[passenger]: https://www.phusionpassenger.com/
[homebrew]: http://brew.sh/
[brew cask]: https://github.com/caskroom/homebrew-cask
[vagrantcloud]: http://vagrantcloud.com
[rbenv]: https://github.com/sstephenson/rbenv
[vim-sensible]: https://github.com/tpope/vim-sensible
[vim-rails]: https://github.com/tpope/vim-rails
[MIT license]: LICENSE
