#!/usr/bin/ruby

ENV['GEM_PATH'] = '/home/singpolyma/.gems:/usr/lib/ruby/gems/1.8'

require 'rubygems'
require 'yadis'
require  'oauth/consumer'
require 'uri'
require 'cgi'
require 'twitter_profile'
require 'tweetcc'

def oauth_xrd(xrds)
	oauth = xrds[nil]['http://oauth.net/discovery/1.0'][0][:uri][0]
	if oauth[0] == '#'[0]
		return xrds[oauth.sub(/^#/,'')]
	end
	parse_xrds( xrds_for(oauth) )[nil]
end

def omb_xrd(xrds)
	omb = xrds[nil]['http://openmicroblogging.org/protocol/0.1'][0][:uri][0]
	if omb[0] == '#'[0]
		return xrds[omb.sub(/^#/,'')]
	end
	parse_xrds( xrds_for(omb) )[nil]
end

uri = URI::parse(ARGV[0]).normalize

xrds = parse_xrds( xrds_for(uri.to_s) )
oauth = oauth_xrd(xrds)
omb = omb_xrd(xrds)

request_token_uri = URI::parse(oauth['http://oauth.net/core/1.0/endpoint/request'][0][:uri][0])
access_token_uri = URI::parse(oauth['http://oauth.net/core/1.0/endpoint/access'][0][:uri][0])
authorize_uri = URI::parse(oauth['http://oauth.net/core/1.0/endpoint/authorize'][0][:uri][0])

@consumer = OAuth::Consumer.new( 'http://tw2omb.singpolyma.net/', '', {
	:site => "http://#{uri.host}",
	:scheme => :query_string,
	:http_method => :get,
	:request_token_path => "#{request_token_uri.path}?#{request_token_uri.query}&omb_version=http://openmicroblogging.org/protocol/0.1&omb_listener=#{CGI::escape(oauth['http://oauth.net/core/1.0/endpoint/request'][0][:localid])}",
	:access_token_path => "#{access_token_uri.path}?#{access_token_uri.query}",
	:authorize_url => oauth['http://oauth.net/core/1.0/endpoint/authorize'][0][:uri][0]
})

if ARGV[2]

	request_token = OAuth::RequestToken.new(@consumer, ARGV[2], ARGV[3])
	access_token = request_token.get_access_token
	
	puts access_token.token
	puts access_token.secret
	puts omb['http://openmicroblogging.org/protocol/0.1/postNotice'][0][:uri][0]
	puts "http://tw2omb.singpolyma.net/profile.php?user=#{ARGV[1]}"

else

	request_token = @consumer.get_request_token

	profile = twitter_profile(ARGV[1])

	auth = "#{oauth['http://oauth.net/core/1.0/endpoint/authorize'][0][:uri][0]}&omb_version=http%3A%2F%2Fopenmicroblogging.org%2Fprotocol%2F0.1" +
		"&omb_listener=#{CGI::escape(oauth['http://oauth.net/core/1.0/endpoint/request'][0][:localid])}" +
		"&omb_listenee=http%3A%2F%2Ftw2omb.singpolyma.net%2Fprofile.php%3Fuser%3D#{ARGV[1]}" +
		"&omb_listenee_profile=http%3A%2F%2Ftwitter.com%2F#{ARGV[1]}" +
		"&omb_listenee_nickname=#{ARGV[1].gsub(/[^0-9a-z]/i,'')}" +
		"&omb_listenee_license=#{CGI::escape(tweetcc(ARGV[1]))}" +
		"&omb_listenee_fullname=#{CGI::escape(profile['name'])}" +
		"&omb_listenee_bio=#{CGI::escape(profile['description'])}" +
		"&omb_listenee_location=#{CGI::escape(profile['location'])}" +
		"&oauth_callback=http%3A%2F%2Ftw2omb.singpolyma.net%2Ffinish.php"
	auth += "&omb_listenee_homepage=#{CGI::escape(profile['url'])}" if profile['url']
	#	"&omb_listenee_avatar=#{CGI::escape(profile['profile_image_url'])}" image must be 96x96, twitter is smaller

	a = @consumer.create_signed_request(:get, auth, request_token)

	puts request_token.token
	puts request_token.secret
	puts a.path
	
end
