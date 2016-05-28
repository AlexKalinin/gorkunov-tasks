require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'byebug'
require 'pry'
require 'logger'

# load configuration
APP_CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), 'config/application.yml'))


logger = Logger.new(STDOUT)
listen_address = APP_CONFIG['listen_address']
listen_port = APP_CONFIG['listen_port']


def handle_connection(socket, client_addrinfo, thread_id)
  logger = Logger.new(STDOUT)
  logger.debug "Thread ##{thread_id}: Begining handle the client: #{client_addrinfo.marshal_dump.to_s}."
  logger.debug "Thread ##{thread_id}: Let's sleep awhile..."
  1.upto 1000000 do
    1.upto 10 do
      a = Random.rand * 10000
      a += a
    end
  end

  request = socket.gets
  logger.debug "Thread ##{thread_id}: Got request: #{request}"
  response = "Hello World!\n"
  socket.print "HTTP/1.1 200 OK\r\n" +
                   "Content-Type: text/plain\r\n" +
                   "Content-Length: #{response.bytesize}\r\n" +
                   "Connection: close\r\n"
  socket.print "\r\n"
  socket.print response


  socket.close
  logger.debug "Thread ##{thread_id}: Client disconnected."
end


threads = []
current_th_id = 1
Socket.tcp_server_loop(listen_address, listen_port){ |socket, client_addrinfo|
  logger.debug "Got new connection from client: #{client_addrinfo.marshal_dump.to_s}."
  th = Thread.new { handle_connection(socket, client_addrinfo, current_th_id) }
  threads << {thread: th, id: current_th_id, client: client_addrinfo}
  #th.join
  logger.debug "Delegated to handle client: #{client_addrinfo.marshal_dump.to_s} to thread with id: #{current_th_id}"
  current_th_id += 1
}
