
require 'socket'
require 'thread'
ESCAPE_CHAR = 'q'
server = Socket.new Socket::AF_INET, Socket::SOCK_STREAM
server.connect Socket.pack_sockaddr_in(ARGV[0] || 9876,ARGV[1] || 'localhost')
connected = true;
p "connected to : #{server}"

server.puts("HELLO FROM CLIENT")

write = Thread.new(server) do |client|
    while(connected)
        msg = gets.chomp              
        client.puts(msg)  
        if msg == ESCAPE_CHAR
            connected = false
            client.close
        end
    end
end

read = Thread.new(server) do |client|
    while(connected)
        begin 
            msg = client.gets.chomp;
            puts "#{server} : #{msg}"
            if msg == ESCAPE_CHAR
                client.close
                connected = false
            end
        rescue
            puts "disconnecting + #{client}"
        end
    end
end

read.join
write.join

p "good bye"