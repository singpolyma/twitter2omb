#!/usr/bin/ruby

ENV['GEM_PATH'] = '/home/singpolyma/.gems:/usr/lib/ruby/gems/1.8'

require 'rubygems'
require 'open-uri'
require 'json'
require 'digest/sha1'
require 'ombpost'

config_path = 'tokens/' + Digest::SHA1.new("http://tw2omb.singpolyma.net/profile.php?user=#{ARGV[0]}").to_s
config = open(config_path).read.split(/\n/)

statuses = if config[4]
	JSON::parse(open("http://search.twitter.com/search.json?q=from%3A#{ARGV[0]}&since_id=#{config[4]}").read)['results']
else
	JSON::parse(open("http://search.twitter.com/search.json?q=from%3A#{ARGV[0]}").read)['results']
end

statuses.reverse_each do |el|
	omb_post(config[2], config[3], config[0], config[1], el['id'], el['text'])
end

if statuses.length > 0
	config[4] = statuses.shift['id']
	#File.new(config_path, 'w').write(config.join("\n"))
end
