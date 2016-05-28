require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'byebug'
require 'pry'
require 'logger'

require './src/server'

# load configuration
$APP_CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), 'config/application.yml'))


logger = Logger.new(STDOUT)
listen_address = $APP_CONFIG['listen_address']
listen_port = $APP_CONFIG['listen_port']
workers_amount = $APP_CONFIG['workers_amount']

logger.info 'Starting program, hello!'
logger.debug "The configuration is: #{$APP_CONFIG.to_s}"

s = Server.new listen_address, listen_port, workers_amount
s.start

# logger.info "Starting webserver at #{listen_address}:#{listen_port}"
# server = TCPServer.new(listen_address, listen_port)
# loop do
#   Thread.fork(server.accept) do |socket|
#     logger.debug "Got new connection from client: #{client_addrinfo.marshal_dump.to_s}."
#     request = socket.gets
#     # sleep(10)
#     logger.debug "Got request: #{request}"
#     response = "Hello World!\n"
#     socket.print "HTTP/1.1 200 OK\r\n" +
#                      "Content-Type: text/plain\r\n" +
#                      "Content-Length: #{response.bytesize}\r\n" +
#                      "Connection: close\r\n"
#     socket.print "\r\n"
#     socket.print response
#
#     socket.close
#     logger.debug 'Client disconnected.'
#   end
# end
#
# server = TCPServer.new('0.0.0.0', 3000)
#
# loop do
#
#   socket = server.accept
#   request = socket.gets
#   STDERR.puts request # for debug
#   response = "Hello World!\n"
#   socket.print "HTTP/1.1 200 OK\r\n" +
#                    "Content-Type: text/plain\r\n" +
#                    "Content-Length: #{response.bytesize}\r\n" +
#                    "Connection: close\r\n"
#   socket.print "\r\n"
#   socket.print response
#
#   socket.close
# end
#
