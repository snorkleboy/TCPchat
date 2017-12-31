
require 'socket'
require 'thread'

server = TCPSocket.new('localhost', 12343)
p server
server.puts("HELLO FROM CLIENT")

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
        end
        client.puts(a)
    }
end
write.join
read.join
server.close
