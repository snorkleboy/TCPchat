
require 'socket'
require 'thread'

server = TCPSocket.new('localhost', 9876)
p server
server.write("HELLO FROM CLIENT")

read = Thread.new(server) do |client|
    while (client)
        msg = client.gets.chomp;
        puts msg
    end
end

write = Thread.new(server) do |client|
    while (client)
        a = gets.chomp
        client.write(a)
    end
end
write.join

read.join
server.close
