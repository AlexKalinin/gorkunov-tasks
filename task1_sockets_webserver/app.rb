require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'byebug'
require 'pry'
require 'logger'

require 'socket'

# load configuration
APP_CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), 'config/application.yml'))


logger = Logger.new(STDOUT)
listen_address = APP_CONFIG['listen_address']
listen_port = APP_CONFIG['listen_port']

logger.info "Starting webserver at #{listen_address}:#{listen_port}"
Socket.tcp_server_loop(listen_address, listen_port){ |socket, client_addrinfo|
  logger.debug "Got new connection from client: #{client_addrinfo.marshal_dump.to_s}."

  request = socket.gets
  logger.debug "Got request: #{request}"
  response = "Hello World!\n"
  socket.print "HTTP/1.1 200 OK\r\n" +
                   "Content-Type: text/plain\r\n" +
                   "Content-Length: #{response.bytesize}\r\n" +
                   "Connection: close\r\n"
  socket.print "\r\n"
  socket.print response

  socket.close
  logger.debug 'Client disconnected.'
}