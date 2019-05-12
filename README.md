# Whistle

[![Build Status](https://travis-ci.org/benbalter/whistle.svg?branch=master)](https://travis-ci.org/benbalter/whistle)

An unofficial Ruby client for the unofficial Whistle v3 API, unofficially

Based on the Whistle pet tracker API as documented in https://community.home-assistant.io/t/whistle-v3-api/89538.

## Usage

```ruby
require 'whistle'

client = Whistle::Client.new(
  email: 'EMAIL',
  password: 'PASSWORD',
  pet_id: 'PET_ID'
)

# If the WHISTLE_EMAIL, WHISTLE_PASSWORD, and WHISTLE_PET_ID env vars are set
client = Whistle::Client.new

client.pet
=> "#<Whistle::Pet>"

client.pet.name
=> "Fido"

client.pet.current_minutes_active
=> 45

client.pet.timeline
=> [Whistle::TimelineEntry]

client.pet.current_location
=> Whistle::TimelineEntry

client.pet.time_inside(humanize: true)
=> "five minutes"
```
