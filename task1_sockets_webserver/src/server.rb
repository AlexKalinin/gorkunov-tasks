require 'thread'
require 'socket'
require 'logger'
require './client'


class Server

  @is_need_stop = false
  @server = nil
  @clients_pool = []

  def initialize(ip_addr, ip_port, workers_amount)
    @ip_addr = ip_addr
    @ip_port = ip_port
    @workers_amount = workers_amount
    @logger = Logger.new(STDOUT)
  end

  def start
    @is_need_stop = false

    @logger.info "MAIN: Listning incoming connections at #{@ip_addr}:#{@ip_port}"
    @server = TCPServer.new(@ip_addr, @ip_port)

    until @is_need_stop
      socket = @server.accept
      request = Request.new socket
      @logger.info "MAIN: Got new request: #{request}"
      @clients_pool << request
      @logger.debug "MAIN: Sent the request to the pool: #{request}"
    end
  end

  def stop
    @is_need_stop = true
  end

  private
    def handle_connection(client)

    end

    # Start workers, that will handle the pool
    def start_workers

    end

    # Stop workers, that are handling the pool of clients
    def stop_workers

    end
end