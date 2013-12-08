# coding: utf-8

require 'pit'
require 'bundler/setup'
require 'twitter'
require 'google-play'
 
pit = Pit.get('twitter')
client = Twitter::REST::Client.new do |c|
  c.consumer_key        = pit['consumer_key']
  c.consumer_secret     = pit['consumer_secret']
  c.access_token        = pit['access_token']
  c.access_token_secret = pit['access_token_secret']
end

gp     = GooglePlay.new
config = YAML.load_file(File.dirname(__FILE__) + '/config.yml')
config['apps'].each do |id|
  app     = gp.app(id)
  reviews = gp.reviews(id) { |r| (Date.today - r.date) < 1 }
  reviews.each do |r|
    star  = '★' * r.rating + '☆'* (5 - r.rating)
    tweet = "【新着レビュー: #{app.name}】#{r.user}「#{r.title}」#{star}　#{r.text}"[0...140]
    client.update(tweet)
  end
end
