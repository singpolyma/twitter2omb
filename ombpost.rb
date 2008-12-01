#!/usr/bin/ruby

ENV['GEM_PATH'] = '/home/singpolyma/.gems:/usr/lib/ruby/gems/1.8'

require 'rubygems'
require  'oauth/consumer'
require 'uri'
require 'cgi'

def omb_post(endpoint, listenee, token, secret, id, text)

	uri = URI::parse(endpoint)

	@consumer = OAuth::Consumer.new( 'http://tw2omb.singpolyma.net/', '', {
		:site => "http://#{uri.host}:#{uri.port}",
		:scheme => :body,
		:http_method => :post
	})


	access_token = OAuth::AccessToken.new(@consumer, token, secret)
	r = access_token.post(uri.path, {
		:action => 'postnotice', #HACK
		:omb_version => 'http://openmicroblogging.org/protocol/0.1',
		:omb_listenee => listenee,
		:omb_notice => 'http://tw2omb.singpolyma.net/notice.php?id=' + CGI::escape(id.to_s),
#		:omb_notice_url => "http://twitter.com/#{listenee}/status/#{id}", # This doesn't work right
		:omb_notice_content => text
	})

	if r.code != '200'
		warn r.body
	end

end
