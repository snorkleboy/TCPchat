#!/usr/bin/env ruby

require 'socket'
include Socket::Constants

socket = Socket.new(AF_INET, SOCK_STREAM, 0)
sockaddress = Socket.pack_sockaddr_in(8888, 'localhost')
socket.bind(sockaddress)
listen = socket.listen(5)
p 'socket bound and listening'
p listen

while(true) do
    p "server free"
    connection = socket.accept
    client = connection[0]
    p "server accepted :#{client}"
    client.puts  "HELLO FROM SERVER"
    
end


# server = TCPServer.new 8888

# while(true) do
#     p "waiting for connection"
#     client = server.accept
#     p client
#     client.puts "in the server"
#     client.puts "time: #{Time.now}"
#     client.close
# end