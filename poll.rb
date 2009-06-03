#!/usr/bin/ruby

ENV['GEM_PATH'] = '/home/singpolyma/.gems:/usr/lib/ruby/gems/1.8'

require 'rubygems'
require 'json'
require 'open-uri'
require 'cgi'
require 'ombpost'

users = {}
queries = []

`ls tokens/`.split(/\n/).each do |token|
	data = open('tokens/' + token).read.split(/\n/)
	user = data[3].split(/=/)[1]
	users[user] = {:data => data, :token => token}
	queries << "from:#{user}"
end

0.step(queries.length - 1, 5) do |i|

	query = queries[i, 5]
	
	statuses = JSON::parse(open("http://search.twitter.com/search.json?since_id=#{open('last_id').read.to_i}&rpp=100&q=#{CGI::escape(query.join(' OR '))}").read)['results']

	statuses.reverse_each do |el|
		next unless el
		config = users[el['from_user']]
		next unless config
		config = config[:data]
		unless omb_post(config[2], config[3], config[0], config[1], el['id'], CGI::unescapeHTML(el['text']), el['from_user'])
			`rm -f tokens/#{users[el['from_user']][:token]}`
		end
	end

	File.new('last_id', 'w').write(statuses.shift['id']) if statuses.length > 0
	
end
