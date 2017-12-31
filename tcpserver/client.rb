
require 'socket'
require 'thread'

server = TCPSocket.new('localhost', 6543)
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
            client.puts(a)
            if a =='q'
                server.close
                connected = false
                p server
                break
            end
        }
    end
end
server.close
