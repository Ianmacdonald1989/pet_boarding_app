# Pet Boarding App

A Ruby on Rails application for managing pet boarding reservations: customers, stays, pets, and cage inventory. The dashboard shows **today’s cage usage** and **current bookings**; staff create and edit bookings with **automatic required cage size** derived from pet type and quantity rules.

## Tech stack

- **Ruby** 3.1.4 (see `pet_boarding/.ruby-version` and `pet_boarding/Gemfile`)
- **Rails** 6.1.x
- **PostgreSQL**
- **Webpacker** 5.x (JavaScript packs, Turbolinks, Rails UJS)
- **Puma** web server

## Repository layout

| Path | Purpose |
|------|---------|
| `pet_boarding/` | Rails application (run all commands from here) |
| `pet_boarding_app/` (this repo root) | Wrapper folder; the app code is under `pet_boarding/` |

## Prerequisites

- Ruby **3.1.4** (rbenv, asdf, or chruby)
- **PostgreSQL** running locally, with permission to create databases
- **Node.js** and **Yarn** (for Webpacker assets)

## Quick start

From the repository root:

```bash
cd pet_boarding
bin/setup
```

`bin/setup` installs gems (via Bundler), runs `yarn`, prepares the database (`db:prepare`), and clears logs/tmp.

Then start the server:

```bash
bundle exec rails server
```

Open [http://localhost:3000](http://localhost:3000). The root path is the **dashboard**.

### First-time asset build

If the UI loads but JavaScript packs fail or `manifest.json` is empty, compile packs once:

```bash
cd pet_boarding
bundle exec rails webpacker:compile
```

For active front-end development you can instead run the webpack dev server (in a second terminal):

```bash
bin/webpack-dev-server
```

## Manual setup (if you skip `bin/setup`)

```bash
cd pet_boarding
gem install bundler -v 1.17.2   # matches Gemfile.lock “BUNDLED WITH”
bundle _1.17.2_ install
yarn install
bundle exec rails db:create db:migrate
bundle exec rails webpacker:compile
bundle exec rails server
```

Default development database name: `pet_boarding_development` (see `config/database.yml`).

## Bundler version

`Gemfile.lock` is pinned to **Bundler 1.17.2**. If `bundle install` complains or picks a different Bundler, install that version and run:

```bash
bundle _1.17.2_ install
bundle _1.17.2_ exec rails server
```

To modernize later, you can run `bundle update --bundler` and commit an updated lockfile (team-wide agreement recommended).

## Main features

- **Dashboard** (`/`, `/dashboard`): cage availability for today, bookings overlapping today, links to create/view bookings.
- **Bookings** (`/bookings`): full CRUD with nested pet lines.
- **Cage size** is computed from pets (e.g. guinea pigs, dogs with size, cats, hamsters) and validated against **cage inventory** to reduce double-booking overlapping stays.

## Tests

```bash
cd pet_boarding
bundle exec rails test
```

System tests may require a browser driver (see `Gemfile` group `:test`).

## Git / contributing

Do **not** commit `pet_boarding/tmp/`, `pet_boarding/log/*.log`, `pet_boarding/node_modules/`, or `pet_boarding/public/packs/` — they are listed in `pet_boarding/.gitignore`. Committing cache and secrets can break `git push` (very large packs, HTTP errors) and is unsafe.

## Troubleshooting

| Issue | What to try |
|-------|-------------|
| **Port already in use** | Another Puma is bound to 3000: stop it or run `rails s -p 3001`. |
| **Missing gems** | Run `bundle install` from `pet_boarding/` with the Bundler version above. |
| **PostgreSQL connection** | Ensure Postgres is running and `database.yml` database names exist or run `db:create`. |
| **Webpacker / missing `application.js`** | Run `rails webpacker:compile` and ensure `yarn install` completed. |
| **`git push` HTTP 400 / disconnect** | Ensure `tmp/`, logs, and `node_modules` are not tracked; see **Git / contributing** above. |

## License

Add a license file if you plan to distribute the project.
