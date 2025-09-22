# To-do

- [ ] fix postfix mail sending from Ansible: `{"changed": false, "msg": "Failed to send mail to 'xxx@gmail.com': {'xxx@gmail.com': (451, b'4.3.5 <noreply@freeflarum.dev>: Sender address rejected: Server configuration error')}", "rc": 1}`
- [ ] Make disabled functions more lenient so that Flarum can load icons(?)
- [ ] Check if tenant hardlinks are correct (if it actually saves disk space or if we redundantly copy some files)
- [ ] Custom Nginx access log format
- [ ] Make working backend, deploy (with .env)
- [ ] Frontend deploy
- [ ] inject index.php guard that correctly redirects to configured URL from app
- [ ] Investigate broken APT Python deadsnakes repo?
- [ ] cloudflare_token, turnstile_key, etc.
