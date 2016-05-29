require 'thread'
require 'socket'
require 'logger'
require 'singleton'


class Server
  include Singleton

  attr_reader :server_mutex

  # Instead initialize, because of the ruby Singlton implementation limit
  # this is fake constructor
  def init(ip_addr, ip_port, workers_amount)
    @logger = Logger.new(STDOUT)

    @ip_addr = ip_addr
    @ip_port = ip_port
    @is_need_stop = true
    @workers_amount = workers_amount
    @server = TCPServer.new(@ip_addr, @ip_port)
    @requests_pool = []
    @workers_pool = []
    @lock = Mutex.new
  end

  def start
    @is_need_stop = false

    @logger.debug "#{self}: Starting ##{@workers_amount} workers"
    1.upto @workers_amount do
      w = Worker.new
      w.start
      @workers_pool << w
    end

    @logger.info "#{self}: Listning incoming connections at #{@ip_addr}:#{@ip_port}"
    until @is_need_stop
      socket = @server.accept
      request = Request.new socket
      @logger.info "#{self}: Got new request: #{request}"
      @requests_pool << request
      @logger.debug "#{self}: Sent the request to the pool: #{request}"
    end
  end

  def stop
    @logger.debug "#{self}: set flag to stop"

    @is_need_stop = true

    # Remove and clear all workers
    @workers_pool.each do |w|
      @logger.debug "#{self}: sending signal to stop the worker #{w}"
      w.stop
    end
    @workers_pool.clear
  end

  # Give request to worker. If there are no any request - give nil
  # This is non-thread safe operation, using mutex
  def get_request
    @lock.synchronize do
      @requests_pool.shift
    end
  end

  def to_s
    '[Server]'
  end
end