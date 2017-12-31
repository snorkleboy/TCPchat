#!/usr/bin/env ruby

require 'socket'
require 'thread'
include Socket::Constants

socket = Socket.new(AF_INET, SOCK_STREAM, 0)
sockaddress = Socket.pack_sockaddr_in(6543, 'localhost')
socket.bind(sockaddress)
listen = socket.listen(5)

p 'socket bound and listening'
p listen

while(true) do
p 'waiting for connection'
    connectionThread = Thread.start(socket.accept) do |connection| 
        p "server accepted :#{connection}"
        client = connection[0]

        client.puts "HELLO FROM SERVER"
        read = Thread.new do 
            loop {
                msg = client.gets.chomp
                puts msg
            }
        end

        write = Thread.new do
            loop {
                msg = gets
                client.puts(msg)
            }
        end
        read.join
        write.join
        p '#{client} disconnected'
    end


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