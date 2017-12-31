#!/usr/bin/env ruby

require 'socket'
require 'thread'
include Socket::Constants
ESCAPE_CHAR = 'q'
User = Struct.new(:client, :name, :address)

class Server 
    def initialize(port, host)
        @users = []
        @threads = []
        @socket = Socket.new(AF_INET, SOCK_STREAM, 0)
        sockaddress = Socket.pack_sockaddr_in(port,host)
        @socket.bind(sockaddress)
        start()
    end

    def start
        @socket.listen(5)
        p 'socket bound and listening'
        while(true) do
            thr = Thread.start(@socket.accept) do |connection| 
                p "server accepted :#{connection}"
                begin
                    user = handshake(connection)         
                    read(user)
                rescue
                    Thread.Kill self
                end
            end
            @threads.push(thr)
        end
    end

    def handshake(connection)
        release = false
        client = connection[0]
        client.puts "welcome to Tchat"
        while (!release)
            client.puts "please enter a username. to see who is on enter 's'"
            msg = client.gets.chomp
            p "client handshake: #{msg}"
            if (msg == 's')
                client.puts "users : #{@users}"
            else
                release = true
                user = User.new(client,msg,connection[1])
                p "new user: #{user}"
            end     
        end
        @users.push(user)
        user[:client].puts "currently connected to #{@users.map{|user| user[:name]}}"
        return user
    end

    def read(user)
        loop {
            msg = user[:client].gets.chomp
            puts "#{user[:name]}: #{msg}"
            write_all(msg, user)
        }
    end

    def write_all(msg, originator)
        @users.each{|user| user[:client].puts("#{user[:name]} : #{msg}") unless user == originator}  
    end

end


server = Server.new(ARGV[0] || 9876,ARGV[1] || 'localhost')

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