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
        p "socket bound on #{host} #{port}"
        @users[0]=User.new(@socket, name, 'here')
        start()
    end
    def start
        @socket.listen(5)
        p 'listening' 
        start_console()
        p 'console running'
        while(true) do
            thr = Thread.start(@socket.accept) do |connection| 
                p "server accepted :#{connection}"
                begin
                    user = handshake(connection)         
                rescue
                    p 'handshake rescue: error'
                    p self
                    Thread.Kill self
                end
                if (user)
                    read(user)
                else
                    Thread.Kill self
                end
            end
            @threads.push(thr)
        end
    end
    def handshake(connection)
        release = false
        client = connection[0]
        http = false;
        while (!release)
            
            msg = client.gets.chomp
            if (msg[0..2] == 'GET')
                p 'HTTP REQUEST!!!!!!!!!'
                p msg
                p 'HTTP REQUEST!!!!!!!!!'
                
                response = "Hello World!\n"

                # We need to include the Content-Type and Content-Length headers
                # to let the client know the size and type of data
                # contained in the response. Note that HTTP is whitespace
                # sensitive, and expects each header line to end with CRLF (i.e. "\r\n")
                client.puts "HTTP/1.1 200 OK\r\n" +
                            "Content-Type: text/plain\r\n" +
                            "Content-Length: #{response.bytesize}\r\n" +
                            "Connection: close\r\n"

                # Print a blank line to separate the header from the response body,
                # as required by the protocol.
                client.puts "\r\n"

                # Print the actual response body, which is just "Hello World!\n"
                client.puts response

                client.close();
                release = true
                http = true;

            else
                client.puts "welcome to Tchat"
                client.puts "please enter a username. to see who is on enter 's'"
                p "client handshake: #{msg}"
                if (msg == 's')
                    client.puts "users : #{@users}"
                else
                    release = true
                    user = User.new(client,msg,connection[1])
                    p "new user: #{user}"
                end 
            end   
        end
        if !http
            @users.push(user)
            user[:client].puts "currently connected: #{@users.map{|user| user[:name]}}"
            return user
        else
             puts 'here'
            return false
        end
    end

    def read(user)
        loop {
            msg = user[:client].gets.chomp
            msg = "#{user[:name]}: #{msg}"
            puts msg
            begin
                write_all(msg, user)
            rescue
                p 'write error'
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
                    me = @users[0]
                    msg =  (/msg(.*)/.match(cmd))
                    msg = me.name + msg[1]
                    p msg
                    write_all(msg,me)
                elsif(cmd == 'see')
                    puts "users:"
                    puts @users
                    puts "threads:"
                    puts  @threads
                elsif(cmd == 'diss')
                    @users[1..-1].each{|user| user.client.close()}
                elsif(cmd == 'myip')
                    p local_ip
                end
            }
        end
    end

    def write_to(msg, client)
        client.puts msg
    end

    def local_ip
        orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

        UDPSocket.open do |s|
            s.connect '64.233.187.99', 1
            s.addr.last
        end
        ensure
            Socket.do_not_reverse_lookup = orig
    end

end


server = Server.new(ARGV[0] || 9876,ARGV[1] || 'localhost')
