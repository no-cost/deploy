# Deploy

Contains Ansible playbooks for deploying a production [no-cost.site](https://no-cost.site) server.

## Prerequisites

For production (max. approx. 3000 sites of varying sizes and types):

- Ubuntu 22.04+ server
- 16 GB RAM VPS minimum
- 160 GB main disk + 100GB backup disk
- Root access (or sudo)
- Domains configured with Cloudflare
- Install required Ansible modules on local machine: `ansible-galaxy install -r requirements.yml`
- Define `nocost` and `nocost-dev` hosts in your `~/.ssh/config`

For dev, 4 GB RAM VPS is sufficient.

## Basic Info

A "(site) tag" is an unique identifier for a site. It's used to identify a tenant (site) in the filesystem and the database (database prefix: `tenant_`).

The [`backend`](https://github.com/no-cost/backend) repository is cloned into `/srv/nocost/backend`. The `/srv/nocost/backend/bin` directory contains management (Python) scripts. The basic management commands are:

- `backup [tag]` – backup all sites, or a specific site;
- `create <tag> <service> <admin e-mail>` – create a new site with given tag, service type (`flarum`/`wordpress`/`mediawiki`, etc.), and admin e-mail. There can only be 1 site per e-mail, multiple sites per account aren't supported (1 account = 1 site);
- `info <tag/hostname/admin e-mail>` – get detailed information about a specific site;
- `sync_vendor [tag]` – sync the `vendor/` directory from skeleton (`/srv/skeleton/<service>`) to specific site, or all sites by default;
- `renew_certificates [--dry-run]` – renew the Let's Encrypt certificates of custom domains (nightly cron); a domain whose renewal fails is unlinked and its owner gets an e-mail with the cause, certbot's output goes to Sentry;
- `provision_ssl_certificate <tag> --off` – no Let's Encrypt for the site's custom domain (linking and renewal), e.g. for the owner's own certificate installed by hand in `/etc/letsencrypt/live/<domain>/` (`fullchain.pem`, `privkey.pem`); without `--off` turns it on again;

### Structure

```plaintext
/srv/
├── nocost/ # frontend + backend
├── host/ # tenant chroots
│   ├── site1/
│   │   ├── app/
│   │   │   ├── index.php
│   │   │   ├── ...
│   │   │   └── vendor/ # ro bind mount
│   │   ├── etc/
│   │   │   └── config.json
│   │   ├── lib/ # hard-links from /srv/skeleton/...
│   │   ├── logs/
│   │   │   ├── ...
│   │   │   └── flarum/
│   │   ├── tmp/
│   │   ├── usr/
│   │   ├── public/ # symlink to app/public
│   └── site2/
├── skeleton/
│   ├── flarum/
│   │   ├── app/
│   │   │   ├── index.php
│   │   │   ├── ...
│   │   │   └── vendor/
│   │   ├── etc/
│   │   │   └── config.json
│   │   ├── lib/ # hard-links from system
│   │   ├── logs/
│   │   │   ├── ...
│   │   │   └── flarum/
│   │   ├── tmp/
│   │   ├── usr/
│   │   ├── public/ # symlink to app/public
│   └── wordpress/
│   │   ├── app/
│   │   │   ├── index.php
│   │   │   └── ...
│   │   ├── etc/
│   │   │   └── config.json
│   │   ├── lib/
│   │   ├── tmp/
│   │   ├── usr/
│   │   └── var/

/backup/ # backups
├── host/ # active hosts
│   ├── forum1/
│   │   ├── 2025-01-01/
│   │   │   ├── files.tar.xz  # contains only media files, no vendor etc.
│   │   │   ├── files.tar.xz.sha256
│   │   │   ├── database.sql.xz
│   │   │   └── database.sql.xz.sha256
│   │   ├── 2025-01-02/
│   │   │   ├── files.tar.xz
│   │   │   ├── files.tar.xz.sha256
│   │   │   ├── database.sql.xz
│   │   │   └── database.sql.xz.sha256
│   └── forum2/
├── attic/ # archived/inactive hosts
│   ├── forum1/
│   │   ├── files.tar.xz
│   │   ├── files.tar.xz.sha256
│   │   ├── database.sql.xz
│   │   └── database.sql.xz.sha256
│   ├── forum2/
│   │   ├── files.tar.xz
│   │   ├── files.tar.xz.sha256
│   │   ├── database.sql.xz
│   │   └── database.sql.xz.sha256
```

### Variables & Secrets

The [`secret_vars.prod.yml`](./secret_vars.prod.yml) file should be present in the root directory of the repository. It contains variables that are encrypted with Ansible Vault, and they should not be `.gitignore`d.

Public variables are stored in the [`public_vars.prod.yml`](./public_vars.prod.yml) file. They are not encrypted, as they do not contain sensitive information.

The development equivalents are [`secret_vars.dev.yml`](./secret_vars.dev.yml) and [`public_vars.dev.yml`](./public_vars.dev.yml). They are used for testing and deployment to a separate development server.

**Warning:** dictionaries are not merged, but overwritten, e. g. if two files specify:

```yaml
var:
    foo: "baz"
    bar: "baz"

# ---

var:
    some: "thing"
```

...then the file included later will take precedence and overwrite the dictionary `var`, therefore there will not be `var.foo` and `var.bar`, just `var.some`. Keep this in mind when editing multiple variable files and relying on the hierarchy of their inclusion!

#### Editing secrets

Secrets can be edited by running `ansible-vault edit secret_vars.prod.yml`.

You can set the `EDITOR` environment variable to control which editor is used for the vault.
For example, on MacOS: `export EDITOR="open -Wn -a TextEdit"` to edit via the TextEdit app (to save, press Ctrl + S and then right-click on TextEdit in the dock and quit it entirely, Ctrl + C in the CLI will interrupt the editor without saving).

## Deployment

### `ansible.cfg`

The configuration file contains common configuration settings for deployment to all environments.

Ensure that the password to decrypt `secret_vars.yml` is present in the `~/.ssh/nocost_vault_password` file.

### Commands

Ensure that Ansible is [installed](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html).

Use [`./prod`](./prod) to deploy to the production server, and [`./dev`](./dev) to deploy to the development server. For example, to deploy everything to the production server:

```bash
./prod
```

NB you must connect on the server at least one (to add its key to the `~/.ssh/known_hosts` file, so Ansible can connect)

### Deploy Specific Components

```bash
# update only backend + tenant skeletons
./prod --tags backend,skeleton

# just nginx + php-fpm
./prod --tags nginx,php-fpm

# main site deployment
./prod --tags frontend,backend
```

The backend deploy reloads the API gracefully: new workers serve the new code at once, the old ones finish their background jobs first (site installs, removals, exports; at most 15 minutes, see `--graceful-timeout` in [`nocost.service`](./playbooks/files/etc/systemd/system/nocost.service)). A changed service unit or `.env` restarts it instead, which also waits for those jobs.

### Changing the PHP version

`php_version` in [`public_vars.prod.yml`](./public_vars.prod.yml) names the packages, the `php<version>-fpm` service and the configuration directory (`/etc/php/fpm` is a symlink to `/etc/php/<version>/fpm`). The playbook can't switch a running server by itself: the tenant pools in `pool.d` are written by the backend, and two PHP-FPM masters can't run at once (same pid file and pool sockets). Switch by hand, e.g. from 8.5 to 8.6 (FreeFlarum, the same setup, on 19 Nov 2026: ~13 s of 502s with 3363 pools):

```bash
# 1. install the new version without starting it (the policy-rc.d keeps the packages from starting or restarting
#    PHP-FPM); `php` (the sites' CLI) is the new version from here on
printf '#!/bin/sh\nexit 101\n' > /usr/sbin/policy-rc.d && chmod 755 /usr/sbin/policy-rc.d
NEEDRESTART_SUSPEND=1 apt-get install -o Dpkg::Options::=--force-confold php8.6-fpm php8.6-cli ...  # the list in 05-php.yml
rm /usr/sbin/policy-rc.d /etc/php/8.6/fpm/pool.d/www.conf
sed -i 's/^error_reporting\s*=.*/error_reporting = E_ALL \& ~E_DEPRECATED/' /etc/php/8.6/cli/php.ini

# 2. the running version's configuration and systemd drop-ins, then test them
cp -p /etc/php/8.5/fpm/{php.ini,php-fpm.conf,base-pool.conf} /etc/php/8.6/fpm/
mkdir -p /etc/systemd/system/php8.6-fpm.service.d
cp -p /etc/systemd/system/php8.5-fpm.service.d/*.conf /etc/systemd/system/php8.6-fpm.service.d/
systemctl daemon-reload
rsync -a --delete /etc/php/8.5/fpm/pool.d/ /etc/php/8.6/fpm/pool.d/
php-fpm8.6 -t --fpm-config /etc/php/8.6/fpm/php-fpm.conf

# 3. switch (Monit would start the old service while it's down); pools added or removed since step 2 are synced again
monit unmonitor php-fpm
systemctl stop php8.5-fpm && rsync -a --delete /etc/php/8.5/fpm/pool.d/ /etc/php/8.6/fpm/pool.d/ \
  && ln -sfn /etc/php/8.6/fpm /etc/php/fpm && systemctl start php8.6-fpm
systemctl disable php8.5-fpm

# 4. set php_version and deploy: PHP_VERSION in the backend's .env (it reloads php<version>-fpm for new sites) and
#    Monit's start/stop programs
./prod --tags php-fpm,backend,monitoring
monit monitor php-fpm

# 5. remove the old version
apt-get purge 'php8.5-*' && rm -rf /etc/php/8.5 /etc/systemd/system/php8.5-fpm.service.d && systemctl daemon-reload
```

Before a switch, test the skeletons (Flarum, MediaWiki, WordPress) on the new version locally: an install of each with its extensions, plugins and skins enabled, then the same requests against the old and the new version.
