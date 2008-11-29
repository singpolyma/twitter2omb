#!/usr/bin/ruby

def xrds_for(url)

	require 'net/http'
	require 'uri'

	uri = URI::parse(url)

	Net::HTTP.start(uri.host, uri.port) { |http|
		response = http.request( Net::HTTP::Get.new("#{uri.path}?#{uri.query}") )
		if response.header['Content-Type'] =~ /^application\/xrds\+xml/
			return response.body
		elsif response.header['Location']
			return xrds_for(response.header['Location'])
		elsif response.header['X-XRDS-Location']
			return xrds_for(response.header['X-XRDS-Location'])
		elsif response.header['X-YADIS-Location']
			return xrds_for(response.header['X-YADIS-Location'])
		else
			# We need hpricot to do HTML parsing
			require 'rubygems'
			require 'hpricot'
			Hpricot.parse(response.body).search('meta') do |el|
				if el.attributes['http-equiv'] =~ /^X\-(XRDS)|(YADIS)\-Location$/i
					return xrds_for(el.attributes['content'])
				end
			end
		end
	}

	return nil

end

def parse_xrds(xml)
	require 'rexml/document'
	xrds = {}
	REXML::Document.new(xml).each_element('//XRD') do |xrd|
		xrds[xrd.attributes['xml:id']] = {}
		xrd.each_element('Service') do |service|
			type = service.get_text('Type').to_s
			xrds[xrd.attributes['xml:id']][type] = [] unless xrds[xrd.attributes['xml:id']][type]
			xrds[xrd.attributes['xml:id']][type][service.attributes['Priority'].to_i] = { :uri => [], :localid => service.get_text('LocalID').to_s }
			service.each_element('URI') do |uriel|
				xrds[xrd.attributes['xml:id']][type][service.attributes['Priority'].to_i][:uri][uriel.attributes['Priority'].to_i] = uriel.text
			end
			xrds[xrd.attributes['xml:id']][type][service.attributes['Priority'].to_i][:uri].compact!
			xrds[xrd.attributes['xml:id']][type].compact!
		end
	end

	xrds
end
