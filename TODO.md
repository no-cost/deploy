# To-do

- [ ] split tenant access logs by site_id
- [ ] deny direct HTTP access via IP (firewall?)
- [ ] add backend tests (unit + integration), run after deploy to ensure we can provision sample instances and remove them etc.
- [ ] add tags to update skeletons and sync all tenant sites, e. g. after updating skeleton code (installing modules etc.)

- [ ] cloudflare_token, turnstile_key etc. in `.envrc`

- [ ] logrotate on api logs (and friends)