#!/usr/bin/env ruby

require 'socket'
server = TCPServer.new 8888

while(true) do
    p "waiting for connection"
    client = server.accept
    p client
    client.puts "in the server"
    client.puts "time: #{Time.now}"
    client.close
end