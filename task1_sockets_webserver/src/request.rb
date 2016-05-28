class Request
  def initialize(socket)
    @socket = socket
    @ip = socket.remote_address.ip_address
    @port = socket.remote_address.ip_port
    @logger = Logger.new(STDOUT)
    @request_body = @socket.gets
  end

  # Process this query
  def handle
    @logger.debug "Handling request #{self.to_s}"

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

    @logger.debug "Done request handling for #{@ip}:#{@port}"
  end

  def to_s
    "Request #{@ip}:#{@port}; body: #{@request_body}"
  end
end