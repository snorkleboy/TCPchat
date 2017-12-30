#!/usr/bin/env ruby

require 'socket'

s = Socket.new Socket::PF_INET, Socket::SOCK_STREAM
s.connect Socket.pack_sockaddr_in(80, 'wel')