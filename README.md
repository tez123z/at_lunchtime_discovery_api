# AllTrails-LunchtimeDiscoveryAPI

Rails 6.1 application making it easy for the AllTrails team to find a great place to eat lunch.

This API wraps the Google Places API to return places to eat for lunch that may be used by other applications for presentation.

## Features

- Authentication via [Devise](https://github.com/heartcombo/devise) and [Devise::JWT](https://github.com/waiting-for-dev/devise-jwt) : using JWT tokens for user authentication
- Google Place API Text Search [Google Place API](https://developers.google.com/maps/documentation/places/web-service/search-text)

## Multi container architecture

This stack is divided into two different containers:

- **app:** Main part. It contains the Rails code to handle web requests (by using the [Puma](https://github.com/puma/puma) gem). See the [Dockerfile](/Dockerfile) for details.
- **worker:** Background processing.
- **postgresql:** PostgreSQL database.
- **redis:** In-memory key/value store (used by Sidekiq, ActionCable and for caching)

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

Tests included via rspec and ThunderClient:

```bash
  docker-compose run app bundle exec rspec
```

VS Code Extension [ThunderClient](https://www.thunderclient.io/) collection/environment can be found here [/thunder_client](https://github.com/tez123z/at_lunchtime_discovery_api/blob/main/thunder_client).

- download collection.json and environment.json
- install Thunder Client
- import collection under "Collections" tab and Enviroment under " of ThunderClient.
- run requests using "Run All"

\*PS. you can create your own environment too. Environment required to store and pass variables between requests.

[View Video Walkthrough HERE](https://share.getcloudapp.com/6quYn0Dl)
