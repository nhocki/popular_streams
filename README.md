# Popular Stream

[![Build Status](https://travis-ci.org/nhocki/popular_streams.svg?branch=master)](https://travis-ci.org/nhocki/popular_streams)

Simple popular content tracker with a Redis backend.

Mostly taken from the "Popular Stream" code found in the
[Surfacing Interesting Content](http://stdout.heyzap.com/2013/04/08/surfacing-interesting-content/)
post but bundled up as a gem.

PopularStream tracks an "event" on a group of "fields" and returns the ones that
are currently popular.

For example, if you want to track the most popular tags right now you, the event
would be "tagging" and the field would be the tag name ("rubygems" for example).

The way this works is that "old" votes will count less than newer votes, that way
a tag that was used 20 times today will be more popular than a tag used 30 times
last week.

Once again, thanks to Micah Fivecoate for his post.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'popular_stream'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install popular_stream

This gems requires **Ruby 2.1**.

## Usage

There are two main methods `vote` and `get`. `vote` adds an event to the list
and `get` gets the most popular fields on the distribution.

```ruby
stream = PopularStream.new("popular_tags")

stream.vote(field: 'rubygems')

# You can also add an optional `weight` param.
stream.vote(field: 'ruby', weight: 2)

# And you can even specify when the event happened.
# Notice that time is a number, meaning seconds since Epoc.
time = Date.yesterday.to_time
stream.vote(field: 'rubygems', time: time.to_i)

stream.get # => ['rubygems', 'ruby']

# You can pass `limit` and `offset`
stream.get(limit: 1, offset: 1) # => ['ruby']
stream.get(offset: 10) # => []

# You can ask to get the scores as well
stream.get(with_scores: true) # => [['ruby', 0.00001]]
```

## Seting up & Configuring Redis

Popular Stream uses Redis as the storage database. By default it will connect to
the redis client on `ENV['REDIS_URL']`. You can also specify what redis client to
use with `PopularStream.redis = Redis.new(host: 'example.com')`.

Notice that this is for *all* streams. This is because we don't want to create new
connections for every new stream instance we create, so the same client is used.

## TODO

* Sinatra application. I want to bundle an optional Sinatra application that
makes this gem super simple to setup as a service.

* Multiple storage databases. Right now everything's stored on Redis but it should
be simple to use more stuff. People should be able to create "adapters" and use
them as needed.

## Contributing

1. Fork it ( https://github.com/nhocki/popular_stream/fork )
2. Create your a new branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

If you're gonna open a Pull Request, please install [EditorConfig](http://editorconfig.org/),
it will keep most of the basic code styling consistent.
