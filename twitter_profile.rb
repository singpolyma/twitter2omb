#!/usrbin/ruby

require 'open-uri'
require 'json'

def twitter_profile(user)
	JSON::parse(open("http://twitter.com/users/show/#{user}.json").read)
end
