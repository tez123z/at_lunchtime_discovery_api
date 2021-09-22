# AllTrails-LunchtimeDiscoveryAPI

Rails 6.1 application makink it easy for the AllTrails team to find a great place to eat lunch by building a restaurant discovery API.

This API will wrap the Google Places API to return places to eat for lunch that may be used by other applications for presentation.

## Features

- Authentication via [Devise](https://github.com/heartcombo/devise) and [Devise::JWT](https://github.com/waiting-for-dev/devise-jwt) : using JWT tokens for user authentication
- Google Place API Text Search [Google Place API](https://developers.google.com/maps/documentation/places/web-service/search-text)

## Multi container architecture

This stack is divided into two different containers:

- **app:** Main part. It contains the Rails code to handle web requests (by using the [Puma](https://github.com/puma/puma) gem). See the [Dockerfile](/Dockerfile) for details.
- **worker:** Background processing. It contains the same Rails code, but only runs Sidekiq
- **postgresql:** PostgreSQL database
- **redis:** In-memory key/value store (used by Sidekiq, ActionCable and for caching)
- **backup:** Regularly backups the database as a dump via CRON to an Amazon S3 bucket

## Ok, Let's Go!

To start up the application in your local Docker environment:

```bash
git clone https://github.com/tez123z/at_lunchtime_discovery_api.git
cd at_lunchtime_discovery_api
docker-compose build
docker-compose up
```

Enjoy!

## Tests

Tests included via rspec:

```bash
  docker-compose run web bundle exec rspec
```

[ThunderClient](https://www.thunderclient.io/) VS Code collection can also be found **thunder_client/collection.json**
