# AllTrails - LunchtimeDiscoveryAPI

Rails 6.1 application making it easy for the AllTrails team to find a great place to eat lunch.

This API wraps the Google Places API to return places to eat for lunch that may be used by other applications for presentation.

## Features

- Authentication via [Devise](https://github.com/heartcombo/devise) and [Devise::JWT](https://github.com/waiting-for-dev/devise-jwt) using JWT for user authentication
- Search via Google Place API Text Search [Google Place API](https://developers.google.com/maps/documentation/places/web-service/search-text)
- FavoritePlace model and endpoints available for tagging favorite places.

### Authentication

_[Devise::JWT](https://github.com/waiting-for-dev/devise-jwt) dispatches and accepts token via Authorization header_

```bash
 "Authorization":"Bearer {token}"
```

Endpoints for authentication and token management:

- **POST /login** with existing user to retrieve token
- **POST /signup** to create new user
- **DELETE /logout and DELETE /signup** to revoke token and destroy user respectively
- **email and password** required for login and signup as expected
- **test user included in seeds.rb**

### Search

- **POST /search** endpoint requires authentication and accepts parameters :query, :location, :pagetoken, :sort_by_ratings
- **:location** format is "{latitude},{longitude}" mirroring format of [Google Place API](https://developers.google.com/maps/documentation/places/web-service/search-text)
- **:pagetoken** provided in response as :next_page_token for pagination thru google place results
- **:sort_by_ratings** value can be either `asc` or `desc` for results sorted by ratings

  #### Response Data

  ```bash
  {
    "data": [PlaceObject],
    "next_page_token": "token for pagination"
  }
  ```

  #### PlaceObject

  ```bash
  {
    "place_id": "sOmEGoOgLePlacEID",  //Used when tagging favorite places
    "geometry":{
      "location":{
        "lat":34.8887163,
        "lng":-82.4060021
      }
    },
    .
    .
    .
    "name":"Restaurant Name",
    "rating":4.1,
    "price_level":1,
    "user_ratings_total":1443,
    "favorited":true,    //true when current user has favorited place
    "photos": [
      {
        ...
        photo_url:"https://somephotourl_for-resaturant"
      }
    ]
  }
  ```

### Favorite Places

- **POST /favorite_places** endpoint requires authentication and accepts :favorite_place object with :place_id from search response

  #### Request Data

  ```bash
  {
    "favorite_place":{
      "place_id":"sOmEGoOgLePlacEID"
    }
  }
  ```

- **GET /favorite_places** endpoint to get list of current user's favorite places. Accepts parameters :items and :page for pagination using [Pagy](https://ddnexus.github.io/pagy/how-to#quick-start&gsc.tab=0)

  #### Response Data

  ```bash
  {
    "data": [PlaceObject],
    "pagy": {
      "page": 1,    //Current Page
      "count": 1    //Total item count
    }
  }
  ```

- **DELETE /favorite_places/:place_id** endpoint requires authentication and accepts parameter :place_id to unfavorite place (same as place_id from google response)

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

Build prepare and run containers

```bash
$ docker-compose build
$ docker-compose run app bundle exec rake db:prepare      //only necessary after first build
$ docker-compose up
```

Enjoy!

## Tests

### Rspec

Tests included via rspec:

```bash
$ docker-compose run app bundle exec rspec
```

### ThunderClient

Testing also available using ThunderClient:

VS Code Extension [ThunderClient](https://www.thunderclient.io/) collection can be found here [/thunder_client](https://github.com/tez123z/at_lunchtime_discovery_api/blob/main/thunder_client/collection.json).

- Download collection.json
- Install Thunder Client
- Create new Environment under "Env" tab of ThunderClient.
- Import collection under "Collections" tab
- Run collection requests using "Run All"

_PS. Environment required to store and pass variables between requests._

[View Video Walkthrough HERE](https://share.getcloudapp.com/6quYn0Dl)
