
require 'socket'
require 'thread'

server = Socket.new Socket::AF_INET, Socket::SOCK_STREAM
server.connect Socket.pack_sockaddr_in(ARGV[0],ARGV[1])
connected = true;
p server
server.puts("HELLO FROM CLIENT")

while (connected)

    read = Thread.new(server) do |client|
        loop {
            msg = client.gets.chomp;
            puts msg
        }
    end

    write = Thread.new(server) do |client|
        loop {
            a = gets.chomp
            
            if a =='q'
                server.close
                connected = false
                p server
                break
            end
            client.puts(a)
        }
    end
end
