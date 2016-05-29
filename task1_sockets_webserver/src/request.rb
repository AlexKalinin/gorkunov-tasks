class Request
  def initialize(socket)
    @socket = socket
    @ip = socket.remote_address.ip_address
    @port = socket.remote_address.ip_port
    @logger = Logger.new(STDOUT)
    @request_body = @socket.gets
    @request_id = SecureRandom.uuid
  end

  # Process this query
  def handle
    @logger.debug "#{self}: Handling request with body: #{@request_body}."

    @logger.debug 'Waiting 10 seconds...'
    sleep(10)

    response = "Hello World!\n"
    @socket.print "HTTP/1.1 200 OK\r\n" +
                     "Content-Type: text/plain\r\n" +
                     "Content-Length: #{response.bytesize}\r\n" +
                     "Connection: close\r\n"
    @socket.print "\r\n"
    @socket.print response
    @socket.close

    @logger.debug "#{self}: Done request handling."
  end

  def to_s
    "[Request #{@ip}:#{@port}@#{@request_id}]"
  end
end