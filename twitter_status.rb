#!/usr/bin/ruby

ENV['GEM_PATH'] = '/home/singpolyma/.gems:/usr/lib/ruby/gems/1.8'

require 'rubygems'
require 'json'
require 'open-uri'

user = JSON::parse(open("http://twitter.com/statuses/show/#{ARGV[0]}.json").read)['user']['screen_name']
puts "http://twitter.com/#{user}/status/#{ARGV[0]}"
