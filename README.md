# Dependencies
- ruby 3.1.2
- rack
- webrick
- rspec

# Setup

### Install bundler
```
gem install bundler
```

### Install dependencies
```
bundle install
```

### Start sever
```
rackup
```

Defaul port is `9292`

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
