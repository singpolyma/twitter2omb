#!/usr/bin/ruby

require 'open-uri'

text = open('http://tweetcc.com/results/?username=' + ARGV[0]).read.scan(/<blockquote[^\f]+?<\/blockquote>/)[0]
attribution = text =~ /Attribution/i
sharealike = text =~ /ShareAlike/i
noncommercial = text =~ /NonCommercial/i
noderivs = text =~ /NoDerivs/i
pd = text =~ /Public Domain/i

# ONE CLAUSE

if pd && (!attribution && !sharealike && !noncommercial && !noderivs)
	puts 'http://creativecommons.org/licenses/publicdomain/'
	exit
end

if attribution && (!pd && !sharealike && !noncommercial && !noderivs)
	puts 'http://creativecommons.org/licenses/by/3.0/'
	exit
end

# TWO CLAUSE

if attribution && sharealike && (!pd && !noncommercial && !noderivs)
	puts 'http://creativecommons.org/licenses/by-sa/3.0/'
	exit
end

if attribution && noncommercial && (!pd && !sharealike && !noderivs)
	puts 'http://creativecommons.org/licenses/by-nc/3.0/'
	exit
end

if attribution && noderivs && (!pd && !sharealike && !noncommercial)
	puts 'http://creativecommons.org/licenses/by-nc/3.0/'
	exit
end

# THREE CLAUSE
if attribution && noncommercial && sharealike && (!pd && !noncommercial)
	puts 'http://creativecommons.org/licenses/by-nc-nd/3.0/'
	exit
end

if attribution && noncommercial && noderivs && (!pd && !sharealike)
	puts 'http://creativecommons.org/licenses/by-nc-nd/3.0/'
	exit
end

puts 'UNKNOWN LICENSE'
