#!/usr/bin/env ruby

require "nats/client"
require "json"

ALIAS_FILE = '/vagrant/avahi/avahi_aliases'

def update_aliases(uri)
	#TODO: Do not add URIs already in the file
	aliases = File.open(ALIAS_FILE, 'a') do |file|
    	file.puts uri
  	end
end


NATS.start do
  sid = NATS.subscribe('router.register') do |response|
    route = JSON.parse(response)
    uri = route["uris"].first
    
    puts 'Uri to register: ' + uri
    puts 'Adding URI to avahi_aliases to be registered if it is not already ....'
    update_aliases(uri)
    end
end