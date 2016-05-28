require 'securerandom'
require 'thread'

class Worker
  @is_need_stop = false

  def initialize()
    @worker_id = SecureRandom.uuid
    @logger = Logger.new(STDOUT)
    @server = Server.instance
    # @mutex = @server.server_mutex
  end

  def start
    @logger.debug "[Worker #{@worker_id}]: Starting ..."
    @is_need_stop = false
    th = Thread.new {do_work}
    # th.join
  end

  def stop
    @logger.debug "[Worker #{@worker_id}]: Stoping ..."
    @is_need_stop = true
  end


  private
    # take and execute next request from the work pool
    def do_work
      until @is_need_stop
        # @mutex.synchronize do
          r = @server.get_request
          if !r.nil?
            @logger.debug "[Worker #{@worker_id}]: Handling request: #{r}"
            r.handle
          else
            #@logger.debug "[Worker #{@worker_id}]: There are no any request in the pool, sleeping..."
            sleep($APP_CONFIG['worker_loop_timeout'])
          end
        # end
      end
    end
end