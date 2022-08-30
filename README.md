# Dependencies
- ruby 3.1.2
- rack
- webrick
- rspec

# Setup

### Install bundler
```
gem install bundler:2.3.12
```

### Install dependencies
```
bundle install
```

### Configuration

There are 2 configurable envs:
- `HTTP_OPEN_TIMEOUT`: timeout to open connection to source url. default is 10s
- `HTTP_READ_TIMEOUT`: timeout to read from source url. default is 10s

### Start sever
```
rackup
```

Default port is `9292`

### Run Test
```
rspec
```

# Usage

There is only one endpoint to fetch hotels: http://localhost:9292/hotels

This endpoint accepts following parameters:
- `hotels`: ids of hotel want to fetch
- `destination`: destination id we want to fetch the hotels from

## To filter by hotel ids

Example: fetch hotel with `ids = [iJhz, SjyX]`

Ex: http://localhost:9292/hotels?hotels[]=iJhz&hotels[]=SjyX

## To filter by hotel destination id:

Example: fetch all hotels belong to `destination id = 1122`

Ex: http://localhost:9292/hotels?destination=1122

# Demo

## Heroku

Checkout the demo version at: https://toan-exercise.herokuapp.com/hotels
