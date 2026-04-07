# Pet Boarding — Rails app

This directory is the **Rails application**. Setup and documentation for the whole project live in the **[repository root README](../README.md)**.

## Quick commands

```bash
# From this directory (pet_boarding/)
bin/setup                    # gems, yarn, db:prepare
bundle exec rails server     # http://localhost:3000
bundle exec rails test
bundle exec rails webpacker:compile   # if JS packs are missing
```

The app root route is the **dashboard**; bookings are under `/bookings`.
