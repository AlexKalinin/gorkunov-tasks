class Request
  @request_body = ''

  def initialize(socket)
    @socket = socket
    @ip = socket.remote_address.ip_address
    @port = socket.remote_address.ip_port
  end

  def to_s
    "Request #{@ip}:#{@port} with socket-state: #{socket.ready?} and with request budy: #{@request_body}"
  end
end