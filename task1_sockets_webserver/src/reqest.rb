class Request

  def initialize(socket)
    @socket = socket
    @ip = socket.remote_address.ip_address
    @port = socket.remote_address.ip_port
  end

  def to_s
    "Client #{@ip}:{@port} with socket-state: #{socket.ready?}"
  end
end