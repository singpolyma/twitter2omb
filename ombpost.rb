#!/usr/bin/ruby

ENV['GEM_PATH'] = '/home/singpolyma/.gems:/usr/lib/ruby/gems/1.8'

require 'rubygems'
require  'oauth/consumer'
require 'uri'
require 'cgi'

def omb_post(endpoint, listenee, token, secret, id, text, twitterusername=nil)

	uri = URI::parse(endpoint)

	@consumer = OAuth::Consumer.new( 'http://tw2omb.singpolyma.net/', '', {
		:site => "http://#{uri.host}:#{uri.port}",
		:scheme => :body,
		:http_method => :post
	})

	access_token = OAuth::AccessToken.new(@consumer, token, secret)
	data = {
		:action => 'postnotice', #HACK
		:omb_version => 'http://openmicroblogging.org/protocol/0.1',
		:omb_listenee => listenee,
		:omb_notice => 'http://tw2omb.singpolyma.net/notice.php?id=' + CGI::escape(id.to_s),
		:omb_notice_content => text
	}
	data[:omb_notice_url] = "http://twitter.com/#{twitterusername}/status/#{id.to_s}" if twitterusername
	r = access_token.post(uri.path, data)

	if r.code != '200'
		warn r.body
	end

end
