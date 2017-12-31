require 'socket'

s = TCPSocket.new 'localhost', 8888

while line = s.gets # Read lines from socket
  puts line         # and print them
end

s.close  