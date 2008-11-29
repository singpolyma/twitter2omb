#!/usrbin/ruby

require 'open-uri'
require 'json'

def twitter_profile(user)
	begin
		JSON::parse(open("http://twitter.com/users/show/#{user}.json").read)
	rescue Exception
		warn 'That twitter user is protected. Cannot read profile.'
	end
end
