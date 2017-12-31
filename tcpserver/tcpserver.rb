#!/usr/bin/env ruby

require 'socket'
require 'thread'
include Socket::Constants

socket = Socket.new(AF_INET, SOCK_STREAM, 0)
sockaddress = Socket.pack_sockaddr_in(9876, 'localhost')
socket.bind(sockaddress)
listen = socket.listen(5)

p 'socket bound and listening'
p listen

while(true) do
    p "server free"

    connectionThread = Thread.start(socket.accept) do |connection| 
        client = connection[0]
        p "server accepted :#{connection}"
        client.write "HELLO FROM SERVER"

        read = Thread.new do 
            while (client)
                msg = client.gets.chomp;
                puts msg
            end
        end

        write = Thread.new do
            while (client)
                a = gets
                client.write(a)
            end
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