require 'time'
require "popular_stream/version"

# Most of this was taken from:
# http://qwerjk.com/posts/surfacing-interesting-content
class PopularStream
  attr_reader :name, :epoch, :max_items

  # 2.5 * half_life (in days) years from now. Make this far in the future!
  DEFAULT_EPOC = Date.new(2017, 5, 29).to_time.to_i
  DAY = 60 * 60 * 24
  HALF_LIFE = 1 * DAY

  class << self
    attr_accessor :redis

    def redis
      @redis ||= Redis.new(url: ENV['REDIS_URL'])
    end
  end

  def initialize(name, **options)
    @name      = name
    @epoch     = options.fetch(:epoch)     { DEFAULT_EPOC }
    @max_items = options.fetch(:max_items) { 10_000 }
  end

  def vote(field:, time: Time.now.to_i, weight: 1)
    time = time.to_i if time.respond_to?(:to_i)

    delta = 2 ** ((time - epoch).to_f / HALF_LIFE)
    redis.zincrby(name, weight * delta.to_f, field)
    trim
  end

  def get(limit: 20, offset: 0, **options)
    redis.zrevrange(name, offset, offset + limit - 1, options)
  end

  def clear!
    redis.del(name)
  end

  def count
    redis.zcard(name)
  end

  def trim
    redis.zremrangebyrank(name, 0, -max_items)
  end

  private

  def redis
    self.class.redis
  end
end
