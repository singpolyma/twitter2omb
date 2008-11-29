#!/usr/bin/ruby

users = []

`ls tokens/`.split(/\n/).each do |token|
	users << open('tokens/' + token).read.split(/\n/)[3].split(/=/)[1]
end

users.each do |user|
	warn `ruby next_statuses.rb '#{user}'`
end
