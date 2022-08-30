# Dependencies
- ruby 3.0
- rack
- webrick
- rspec

# Setup

### install bundler
```
gem install bundler
```

### install dependencies
```
bundle install
```

### start sever
```
rackup
```

Defaul port is `9292`

# Usage

There is only one endpoint to fetch hotels: http://localhost:9292/hotels

This endpoint accepts following parameters:
- `hotels`: ids of hotel want to fetch
- `destination`: destination id we want to fetch the hotels from

## to filter by hotel ids

Example: fetch hotel with id = [iJhz, SjyX]

Ex: http://localhost:9292/hotels?hotels[]=iJhz&hotels[]=SjyX

## to filter by hotel destination id:

Example: fetch all hotels belong to destination id `1122`

Ex: http://localhost:9292/hotels?destination=1122
