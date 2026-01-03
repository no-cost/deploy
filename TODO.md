# To-do

- [ ] make codebase files read-only for tenants (skeleton files and hardlinked libs, so they can't modify them)
- [ ] fix mediawiki file uploads <https://mediawiki_skeleton.no-cost.wiki/index.php?title=File:Snehuliak.jpeg>
- [ ] run alembic migrations on backend deployment
- [ ] Make working backend
  - [ ] deploy (with .envrc, load via dotenv?)
  - [ ] deploy only playbooks needed for managing the instances (skeletons will still be deployed via `deploy` repo, but concrete tenants will be created through playbooks in `backend`)
  - [ ] add backend tests (unit + integration), run after deploy to ensure we can provision sample instances and remove them etc.
- [ ] Frontend deploy
- [ ] cloudflare_token, turnstile_key etc. in `.envrc`
