# TrainTote Demo

This repository contains the PHP application used by the TrainTote demo site.

## Local setup

1. Use PHP 8.1 or newer with PDO MySQL enabled, and create a MySQL or MariaDB database.
2. Import `database/schema.sql`, then `database/demo_seed_data.sql`. The schema contains table structure only. The seed file creates an inactive placeholder owner and an empty seed railroad; it contains no production account or user data.
3. Copy the needed `config/*.example.php` files to the matching names without `.example` and set the environment variables shown in those files. Keep the resulting config files out of Git.
4. Make `uploads/` and `uploads/temp/` writable by PHP. These folders hold runtime files and are ignored by Git.
5. Configure a scheduled task to run `php scripts/cleanup_demo_users.php` hourly. Demo accounts expire four hours after they are created.

AI scanning requires `OPENAI_API_KEY`. Background removal is optional and requires `REMOVEBG_API_KEY`. `TT_AUTH_SECRET` is only needed for the shared TrainTote sign-in cookie.

## Deployment notes

- Never commit production config, API keys, database exports containing rows, logs, or uploaded photos.
- The repository includes `config/.htaccess` as an extra safeguard for Apache deployments. Keep the config directory outside the public web root when the hosting setup allows it.
- `database/schema.sql` was produced from the current demo database structure with all row data removed. Add future schema changes as reviewed migrations under `database/migrations/`.
- Demo cleanup removes expired temporary accounts and the application records attached to their railroads. The cleanup script is command-line only and does not run when visitors load the site.
