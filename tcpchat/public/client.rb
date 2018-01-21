
require 'socket'
require 'thread'
server = Socket.new Socket::AF_INET, Socket::SOCK_STREAM
server.connect Socket.pack_sockaddr_in(ARGV[0] || 9876,ARGV[1] || 'localhost')
connected = true;
p "connected to : #{server}"

# init_message = ARGV[2] || 'Anon'
# server.puts(init_message)

write = Thread.new(server) do |client|
    while(connected)
        msg = $stdin.gets.chomp              
        client.puts(msg)  
    end
end

read = Thread.new(server) do |client|
    while(connected)
        msg = client.gets.chomp;
        puts msg
    end
end

read.join
write.join

p "good bye"