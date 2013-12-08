# coding: utf-8
require 'pit'
require 'bundler/setup'
require 'weather_jp'
require 'twitter'
 
pit = Pit.get('twitter')
client = Twitter::REST::Client.new do |c|
  c.consumer_key        = pit['consumer_key']
  c.consumer_secret     = pit['consumer_secret']
  c.access_token        = pit['access_token']
  c.access_token_secret = pit['access_token_secret']
end

WeatherJp.customize_to_s do
  word = "【#{day}の天気】#{forecast} "
  word << "#{min_temp}℃〜#{max_temp}℃ " if min_temp and max_temp
  word << "降水確率#{rain}%" if rain
  word << ' ' * (Date.today.day % 2)
  word
end

tweet = WeatherJp.get(:tokyo, :tomorrow).to_s
client.update(tweet)
