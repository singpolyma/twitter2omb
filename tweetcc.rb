#!/usr/bin/ruby

require 'open-uri'

def tweetcc(user)

	text = open('http://tweetcc.com/results/?username=' + user).read.scan(/<blockquote[^\f]+?<\/blockquote>/)[0]
	attribution = text =~ /Attribution/i
	sharealike = text =~ /ShareAlike/i
	noncommercial = text =~ /NonCommercial/i
	noderivs = text =~ /NoDerivs/i
	pd = text =~ /Public Domain/i

	# ONE CLAUSE

	if pd && (!attribution && !sharealike && !noncommercial && !noderivs)
		return 'http://creativecommons.org/licenses/publicdomain/'
		exit
	end

	if attribution && (!pd && !sharealike && !noncommercial && !noderivs)
		return 'http://creativecommons.org/licenses/by/3.0/'
		exit
	end

	# TWO CLAUSE

	if attribution && sharealike && (!pd && !noncommercial && !noderivs)
		return 'http://creativecommons.org/licenses/by-sa/3.0/'
		exit
	end

	if attribution && noncommercial && (!pd && !sharealike && !noderivs)
		return 'http://creativecommons.org/licenses/by-nc/3.0/'
		exit
	end

	if attribution && noderivs && (!pd && !sharealike && !noncommercial)
		return 'http://creativecommons.org/licenses/by-nc/3.0/'
		exit
	end

	# THREE CLAUSE
	if attribution && noncommercial && sharealike && (!pd && !noncommercial)
		return 'http://creativecommons.org/licenses/by-nc-nd/3.0/'
		exit
	end

	if attribution && noncommercial && noderivs && (!pd && !sharealike)
		return 'http://creativecommons.org/licenses/by-nc-nd/3.0/'
		exit
	end

	return 'http://twitter.com/tos'

end
