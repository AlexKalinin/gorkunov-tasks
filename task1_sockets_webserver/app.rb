require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'byebug'


require 'socket'

server = TCPServer.new('0.0.0.0', 3000)

loop do

  socket = server.accept
  request = socket.gets
  STDERR.puts request # for debug
  response = "Hello World!\n"
  socket.print "HTTP/1.1 200 OK\r\n" +
                   "Content-Type: text/plain\r\n" +
                   "Content-Length: #{response.bytesize}\r\n" +
                   "Connection: close\r\n"
  socket.print "\r\n"
  socket.print response

  socket.close
end




