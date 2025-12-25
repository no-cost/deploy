# nginx configuration

Holds configuration for the nginx web server:

- [`maps/sites.conf`](./maps/sites.conf) - default file for mapping site IDs to hostnames. Each site has 1 (canonical) hostname. It also maps site IDs to service types. These 2 maps are requires, so when user visits `https://mysite.no-cost.site`, we can:
  - figure out if this is the correct canonical hostname: `mysite.no-cost.forum` etc. would return 404
  - figure out which service the site is running, so we can route it to different nginx configs. For example, if site was provisioned as a MediaWiki instance, we don't want to use config for WordPress.
- [`service-rules/*.conf`](./service-rules/) - contains configuration files for `location @<service_type>` rules. When we figure out which `service_type` a site has, we can route it dynamically to the correct `location` block (correct config for that service).
- [`sites-enabled/`](./sites-enabled/) - contains configs for all sites/domains:
  - [`sites-enabled/dynamic.conf`](./sites-enabled/dynamic.conf) - handles routing for provisioned tenant instances;
  - [`sites-enabled/main-site.conf`](./sites-enabled/main-site.conf) - handles routes for the main site, e. g. `no-cost.site`. Other root domains redirect to this site. It is the user frontend for all tenant management tasks;
- [`snippets/`](./snippets/) - contains useful snippets and common nginx configuration rules that are included in other configs via `include`, for readability.
- [`nginx.conf`](./nginx.conf) - the main entry point for all configs

See <https://nginx.org/en/docs/> for more information.
