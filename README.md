# Deploy

Contains Ansible playbooks for deploying a production no-cost.site server.

## Prerequisites

- Ubuntu 22.04+ server
- 16 GB RAM minimum
- 160 GB main disk + 100GB backup disk
- Root access (or sudo)
- Domains configured with Cloudflare
- Install required Ansible modules on local machine: `ansible-galaxy install -r requirements.yml`
- Define `nocost` and `nocost-dev` hosts in your `~/.ssh/config`

## Basic Info

A "(site) tag" is an unique identifier for a site. It's used to identify a tenant (site) in the filesystem and the database (database prefix: `site_`).

The [`backend`](https://github.com/no-cost/backend) repository is cloned into `/srv/nocost/backend`. The `/srv/nocost/backend/bin` directory contains management (Python) scripts. The basic management commands are:

- `backup [tag]` – backup all sites, or a specific site;
- `create <tag> <service> <admin e-mail>` – create a new site with given tag, service type (`flarum`/`wordpress`/`mediawiki`, etc.), and admin e-mail. There can only be 1 site per e-mail, multiple sites per account aren't supported (1 account = 1 site);
- `info <tag/hostname/admin e-mail>` – get detailed information about a specific site;
- `sync_vendor [tag]` – sync the `vendor/` directory from skeleton (`/srv/skeleton/<service>`) to specific site, or all sites by default;

### Structure

```plaintext
/srv/
├── nocost/  # frontend + backend
├── host/  # tenant chroots
│   ├── site1/
│   │   ├── app/
│   │   │   ├── index.php
│   │   │   ├── ...
│   │   │   └── vendor/  # hard-linked from /srv/skeleton/.../vendor
│   │   ├── etc/
│   │   │   └── config.json
│   │   ├── lib/  # hard-links from /srv/skeleton/...
│   │   ├── logs/
│   │   │   ├── ...
│   │   │   └── flarum/
│   │   ├── tmp/
│   │   ├── usr/
│   │   ├── public/  # symlink to app/public
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
│   │   ├── public/  # symlink to app/public
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

/backup/  # backups
├── host/  # active hosts
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
├── attic/  # archived/inactive hosts
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
# base system only
./prod --tags base,system

# security hardening and packages
./prod --tags security

# web services (Nginx + PHP)
./prod --tags nginx,php-fpm

# main site deployment
./prod --tags mainsite
```
