# coding: utf-8

require 'pit'
require 'bundler/setup'
require 'twitter'

class Time
  def within_a_week?
    (Time.now - self).divmod(24 * 60 * 60)[0].to_i < 7
  end
end

pit = Pit.get('twitter')

client = Twitter::REST::Client.new do |c|
  c.consumer_key        = pit['consumer_key']
  c.consumer_secret     = pit['consumer_secret']
  c.access_token        = pit['access_token']
  c.access_token_secret = pit['access_token_secret']
end

client.user_timeline
  .reject { |tweet| tweet.created_at.within_a_week? }
  .each   { |tweet| client.destroy_status(tweet.id) }
