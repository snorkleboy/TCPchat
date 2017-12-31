#!/usr/bin/env ruby

require 'socket'
require 'thread'
include Socket::Constants
ESCAPE_CHAR = 'q'


class Server 
    def initialize(port, host)
        @clients = []
        @socket = Socket.new(AF_INET, SOCK_STREAM, 0)
        sockaddress = Socket.pack_sockaddr_in(port,host)
        @socket.bind(sockaddress)
        start()
    end

    def start
        @socket.listen(5)
        p 'socket bound and listening'
        while(true) do
            Thread.start(@socket.accept) do |connection| 
                p "server accepted :#{connection}"
                client = connection[0]

                @clients.push(client)
                p "clients : #{@clients}"

                client.puts "HELLO FROM SERVER, currently connected to #{@clients}"
                read(client)
            end
        end
    end

    def read(client)
        loop {
            msg = client.gets.chomp
            puts "#{client}: #{msg}"
            write_all(msg, client)
        }
    end

    def write_all(msg, originator)
        @clients.each{|client| client.puts("#{client} : #{msg}") unless client == originator}  
    end

end


server = Server.new(ARGV[0],ARGV[1])

# server = TCPServer.new 8888

# while(true) do
#     p "waiting for connection"
#     client = server.accept
#     p client
#     client.puts "in the server"
#     client.puts "time: #{Time.now}"
#     client.close
# end

# (ARGV[0] || 9876,ARGV[1] || 'localhost')