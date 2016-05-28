require 'thread'
require 'socket'
require 'logger'
require 'singleton'


class Server
  include Singleton

  @is_need_stop = false
  @server = nil
  @requests_pool = []
  @workers_pool = []
  attr_reader :server_mutex

  # Instead initialize, because of the ruby Singlton implementation limit
  # this is fake constructor
  def init(ip_addr, ip_port, workers_amount)
    @ip_addr = ip_addr
    @ip_port = ip_port
    @workers_amount = workers_amount
    @logger = Logger.new(STDOUT)

    0.upto workers_amount do
      @workers_pool << Worker.new
    end

    @server_mutex = Mutex.new
  end

  def start
    @is_need_stop = false

    @logger.info "MAIN: Listning incoming connections at #{@ip_addr}:#{@ip_port}"
    @server = TCPServer.new(@ip_addr, @ip_port)

    until @is_need_stop
      socket = @server.accept
      request = Request.new socket
      @logger.info "MAIN: Got new request: #{request}"
      @requests_pool << request
      @logger.debug "MAIN: Sent the request to the pool: #{request}"
    end
  end

  def stop
    @logger.info 'MAIN: Stoping workers'

    @is_need_stop = true
  end

  # Give request to worker. If there are no any request - give nil
  def get_request
    @workers_pool.shift
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