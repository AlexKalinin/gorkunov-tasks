class Request
  def initialize(socket)
    @socket = socket
    @ip = socket.remote_address.ip_address
    @port = socket.remote_address.ip_port
    @logger = Logger.new(STDOUT)

    #todo: fix: possible memory overflow, if reqest is too big!!!
    @request_body = @socket.gets

    # our request is unique. We want to see it in the logs
    @request_id = SecureRandom.uuid
    @params = Request.parse @request_body
  end

  # Process this query
  def handle
    @logger.debug "#{self}: Handling request with body: #{@request_body}, params are: #{@params}."

    # checking the query
    check_res = Request.params_valid? @params
    unless check_res[:result]
      @logger.warn "#{self}: #{check_res[:message]}"
      @socket.print check_res[:response]
      @socket.close
      @logger.debug "#{self}: Done request handling."
      return
    end

    # parsing the query
    qs_hash = Request.parse_query_string @params[:query_string]
    case qs_hash[:action]
      when :root
        @logger.debug "#{self}: Requested root_url."
        @socket.print Response.gen_root
        @socket.close
      when :time
        @logger.debug "#{self}: Requested root_url."
        @socket.print Response.gen_time qs_hash[:params],
        @socket.close
      else
        @logger.warn "#{self}: Unknown action #{qs_hash[:action]}!"
        @socket.print Response.gen_404
        @socket.close
    end

    @logger.debug "#{self}: Done request handling."
  end



  # Dump this object to string
  def to_s
    "[Request #{@ip}:#{@port}@#{@request_id}]"
  end

  # Parse request body to hash with keys
  #  * +params[:method]+ - http-method, GET/POST/PUT...
  #  * +params[:query_string]+ - http-query string, /some?url=path
  #  * +params[:http_version]+ - http protocol version, HTTP/1.1 or HTTP/2.0 ...
  #  todo: implement request body parsing
  #  todo: cover with tests
  def self.parse(request_body)
    return nil unless request_body

    r_blocks = request_body.split ' '

    return nil if r_blocks.empty?
    return nil unless r_blocks.count >= 3

    params = {}
    params[:method] = r_blocks[0]
    params[:query_string] = r_blocks[1]
    params[:http_version] = r_blocks[2]
    # todo: parse request body if needed

    params
  end


  # Allow garbage collecter delete this object from memory
  # usefull after handling, for memory free
  def mem_free
    @logger.debug "#{self}: mem_free: Cleaning up request from memory."
    @ip = nil
    @port = nil
    @request_body = nil
    @request_id = nil
    @params = nil

    # socket is speacial
    unless @socket.closed?
      @logger.warn "#{self}: mem_free: The socket is opened until now! Developer's mistake!"
      @socket.close
    end
    @socket = nil
    @logger = nil
  end


  private

    # Validate parsed requst params
    # +params+ - request params from Request#parse(request_body)
    # todo: cover with tests!
    def self.params_valid?(params)
      if params.nil?
        return {
            result: false,
            response: Response.gen_400,
            message: 'Got empty request, closing with status 400...'
        }
      end

      # only GET queries!
      if params[:method] != 'GET'
        return {
            result: false,
            response: Response.gen_400,
            message: "Got request with wrong http-method. Expected GET, got #{params[:method]} closing with status 400..."
        }
      end

      valid_http = %w(HTTP/0.9 HTTP/1.0 HTTP/1.1 HTTP/1.2 HTTP/2.0)
      unless valid_http.include? params[:http_version]
        return {
            result: false,
            response: Response.gen_400,
            message: "Got request with wrong http-version. Expected HTTP/1.1 or HTTP/2.0, got #{params[:method]} closing with status 400..."
        }
      end

      # request is good!
      {result: true, response: '', message: 'ok'}
    end

    # Will parse query_string.
    # Will return hash:
    # qs_hash[:action] - posible values:
    #   * :unknown - if unknown action
    #   * :root - if need to show root page
    #   * :time - if need to show time page
    # qs_hash[:params] - posible values:
    #   * [] - empty array, if in the GET query there were no any params
    #   * ['Moscow', 'New York'] - array with town names, if town names specified, with comma separation
    def self.parse_query_string(query_string)
      qarr = query_string.split('?')
      path = qarr.shift

      params = []
      unless (p = qarr.shift).nil?
        p = URI.decode(p)
        params = p.split ','
      end
      # params_string = URI.decode(qarr.shift)
      # params = params_string.split ','
      case path
        when '/'
          return {action: :root, params: params}
        when '/time'
          return {action: :time, params: params}
        else
          return {action: :unknown, params: params}
      end

    end

end