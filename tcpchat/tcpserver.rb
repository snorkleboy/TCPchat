#!/usr/bin/env ruby

require 'socket'
require 'thread'
include Socket::Constants
ESCAPE_CHAR = 'q'
User = Struct.new(:client, :name, :address)

class Server 
    def initialize(port, host, name = 'server')
        @users = []
        @threads = []
        @socket = Socket.new(AF_INET, SOCK_STREAM, 0)
        sockaddress = Socket.pack_sockaddr_in(port,host)
        @socket.bind(sockaddress)

        @users[0]=User.new(@socket, name, 'here')
        start()
    end

    def start
        @socket.listen(5)
        p 'socket bound and listening'
        start_console()
        p 'console running'
        while(true) do
            thr = Thread.start(@socket.accept) do |connection| 
                p "server accepted :#{connection}"
                begin
                    user = handshake(connection)         
                rescue
                    p 'thread death:'
                    p 'self'
                    Thread.Kill self
                end
                read(user)
            end
        end
        @threads.push(thr)
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
        user[:client].puts "currently connected: #{@users.map{|user| user[:name]}}"
        return user
    end

    def read(user)
        loop {
            msg = user[:client].gets.chomp
            msg = "#{user[:name]}: #{msg}"
            puts msg
            begin
                write_all(msg, user)
            rescue
                p 'write all error'
            end
        }
    end

    def write_all(msg, originator = null)
        @users[1..-1].each {|user| user.client.puts(msg) unless(user == originator)}
    end

    def start_console()
        Thread.new() do
            loop {
                cmd = $stdin.gets.chomp
                if (/msg*/.match(cmd))
                    a =@users[0].name +" " + /msg (.*)/.match(cmd)[1]
                    write_all(a,@users[0])
                elsif(cmd == 'see')
                    p @users
                    puts
                    p @threads
                    puts 
                    p @socket
                elsif(cmd == 'diss')
                    @users[1..-1].each{|user| user.client.close()}
                end
            }
        end
    end

    def write_to(msg, client)
        client.puts msg
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