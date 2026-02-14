#!/bin/bash
# https://community.letsencrypt.org/t/recommended-permissions-on-files-distributed-by-lets-encrypt/104266/3
# ensure nginx (www-data) can read Let's Encrypt certificates:
# normally, if the certs would load at boot time, nginx could read them as the master process is often root
# however, in our setup, the cert path is dynamic and read by workers, which are www-data
# so, we need to fix the certs to ensure www-data can read the certs
chmod 0750 /etc/letsencrypt/{live,archive}
chgrp www-data /etc/letsencrypt/{live,archive}

archive_dir="/etc/letsencrypt/archive/$(basename "$RENEWED_LINEAGE")"
chgrp -R www-data "$archive_dir"
chmod 0750 "$archive_dir"
chmod 0640 "$archive_dir"/privkey*.pem
chmod 0644 "$archive_dir"/cert*.pem "$archive_dir"/chain*.pem "$archive_dir"/fullchain*.pem
