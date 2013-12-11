# coding: utf-8

require 'pit'
require 'bundler/setup'
require 'twitter'
require 'admob-api'

pit_twitter = Pit.get('twitter')
twitter = Twitter::REST::Client.new do |c|
  c.consumer_key        = pit_twitter['consumer_key']
  c.consumer_secret     = pit_twitter['consumer_secret']
  c.access_token        = pit_twitter['access_token']
  c.access_token_secret = pit_twitter['access_token_secret']
end

pit_admob = Pit.get('admob')
admob = AdMobApi.new do |c|
  c.client_key = pit_admob['client_key']
  c.email      = pit_admob['email']
  c.password   = pit_admob['password']
end

# AdMob
ids   = admob.sites.map(&:id)
stats = admob.stats(ids, :yesterday)
admob.logout

# Tweet
yesterday = (Time.now - 24 * 60 * 60).strftime('%m月%d日')
revenue   = sprintf("%.2f", stats.revenue)
twitter.update("#{yesterday}のAdmobの収益は $#{revenue} でした！" )
