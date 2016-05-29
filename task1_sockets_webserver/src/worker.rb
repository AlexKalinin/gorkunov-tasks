require 'securerandom'
require 'thread'

class Worker
  @is_need_stop = false
  @thread = nil

  def initialize
    @worker_id = SecureRandom.uuid
    @logger = Logger.new(STDOUT)
    @server = Server.instance
  end

  def start
    @logger.debug "#{self}: Starting ..."
    @is_need_stop = false
    if @thread.nil?
      @thread = Thread.new {do_work}
    else
      @logger.error "#{self}: start: cannot start, because this worker allready started!"
    end
    # @thread.join
  end

  def stop
    @logger.debug "#{self}: Stoping ..."
    @is_need_stop = true
    until @thread.nil?
      @logger.debug "#{self}: Waiting to stop thread..."
      sleep 1
    end
  end

  def to_s
    "[Worker #{@worker_id}]"
  end


  private
    # take and execute next request from the work pool
    def do_work
      until @is_need_stop
        # @mutex.synchronize do
          r = @server.get_request
          if !r.nil?
            @logger.debug "#{self}: Handling request: #{r}"
            r.handle
            @logger.debug "#{self}: Done handling request: #{r}, "
            r.mem_free
          else
            sleep($APP_CONFIG['worker_loop_timeout'])
          end
        # end
      end
      @thread = nil #free the link to the thread, because the thread will finish here
    end
end