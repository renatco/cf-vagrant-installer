#!/usr/bin/env ruby
require "nats/client"
require "json"

ALIAS_FILE = '/vagrant/avahi/aliases'

def wait_for_nats_to_start()
  Timeout::timeout(10) do
    loop do
      sleep 0.2
      break if nats_up?
    end
  end
end

def nats_up?
  NATS.start do
    NATS.stop
    return true
  end
rescue NATS::ConnectError
  nil
end

def update_aliases(uri)
  File.open(ALIAS_FILE, 'r+') do |file|
    file.each.any? do |line|
      uri.eql? line.chomp
    end or file.puts uri
  end
end


File.open(ALIAS_FILE, 'w') {}
wait_for_nats_to_start()

#TODO still have to manage the router.unregister messages
NATS.start do
  sid = NATS.subscribe('router.register') do |response|
    route = JSON.parse(response)
    uri = route["uris"].first
    update_aliases(uri)
  end
end