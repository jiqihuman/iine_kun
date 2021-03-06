#coding:utf-8
require 'open-uri'
require 'rubygems'
require 'json'
require 'clockwork'
require 'redis'
include Clockwork

uri = URI.parse(ENV["REDISTOGO_URL"])
@redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

handler do |job|
  count=@redis.get("like")
  #res = open("https://graph.facebook.com/http://web.sfc.keio.ac.jp/~t10064ai/like_kun/index.html").read
  res = open(ENV["IINE_KUN"]).read
  res2 = JSON.parse(res)
  if res2["shares"].nil?
    like_count = 0
  else
    like_count = res2["shares"]
  end
  puts "redis get:" + count.to_s
  puts "like:" + like_count.to_s
  if count.to_i!=like_count.to_i
    @redis.set("like", like_count) 
  end
  puts "redis set:" + @redis.get("like").to_s
end

every(5.seconds, 'frequent.job')
