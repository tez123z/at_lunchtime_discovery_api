# AllTrails - LunchtimeDiscoveryAPI

Rails 6.1 application making it easy for the AllTrails team to find a great place to eat lunch.

This API wraps the Google Places API to return places to eat for lunch that may be used by other applications for presentation.

## Features

- Authentication via [Devise](https://github.com/heartcombo/devise) and [Devise::JWT](https://github.com/waiting-for-dev/devise-jwt) : using JWT for user authentication
- Search via Google Place API Text Search [Google Place API](https://developers.google.com/maps/documentation/places/web-service/search-text)

### Authentication

_[Devise::JWT](https://github.com/waiting-for-dev/devise-jwt) dispatches and accepts token via Authorization header_

```bash
 "Authorization":"Bearer {token}"
```

Endpoints for authentication and token management:

- POST /login with existing user to retrieve token
- POST /signup to create new user
- DELETE /logout and /signup to revoke token and destroy user respectively

### Search

- POST /search endpoint requires authentication and accepts parameters :query, :location, :page_token
- :location parameter format is "{latitude},{longitude}" mirroring format of [Google Place API](https://developers.google.com/maps/documentation/places/web-service/search-text)

## Multi container architecture

This stack is divided into two different containers:

- **app:** Main part. It contains the Rails code to handle web requests (by using the [Puma](https://github.com/puma/puma) gem). See the [Dockerfile](/Dockerfile) for details.
- **worker:** Background processing.
- **postgresql:** PostgreSQL database.
- **redis:** In-memory key/value store (used by Sidekiq, ActionCable and for caching)

## Ok, Let's Go!

To start clone repo:

```bash
$ git clone https://github.com/tez123z/at_lunchtime_discovery_api.git
$ cd at_lunchtime_discovery_api
```

Add `.env` file and your environment variables:

```bash
$ touch .env
```

GOOGLE_API_KEY environment variable required. Example `.env` file:

```
GOOGLE_API_KEY=SomeGoOglApIkEy
```

Build and run containers

```bash
docker-compose build
docker-compose up
```

Enjoy!

## Tests

### Rspec

Tests included via rspec:

```bash
  docker-compose run app bundle exec rspec
```

### ThunderClient

Testing also available using ThunderClient:

VS Code Extension [ThunderClient](https://www.thunderclient.io/) collection/environment can be found here [/thunder_client](https://github.com/tez123z/at_lunchtime_discovery_api/blob/main/thunder_client).

- Download collection.json and environment.json
- Install Thunder Client
- Import collection under "Collections" tab and Environment under "Env" tab of ThunderClient.
- Run collection requests using "Run All"

_PS. You can create/use your own environment too. Environment required to store and pass variables between requests._

[View Video Walkthrough HERE](https://share.getcloudapp.com/6quYn0Dl)
