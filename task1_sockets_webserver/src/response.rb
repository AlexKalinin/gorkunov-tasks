class Response
  # 400 Bad Request
  # see https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
  #
  # The request could not be understood by the server due to malformed syntax.
  # The client SHOULD NOT repeat the request without modifications.
  def self.gen_400(msg = '')
    msg = 'Error 400: Bad Request!' if msg.empty?
    rsp_body = msg + "\n"
    rsp = "HTTP/1.1 400 Bad Request\r\n" +
        "Content-Type: text/plain\r\n" +
        "Content-Length: #{rsp_body.bytesize}\r\n" +
        "Connection: close\r\n" +
        "\r\n" +
        rsp_body
    rsp
  end

  # Generates Not Found response
  # 404 Not Found
  # see https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
  #
  # The server has not found anything matching the Request-URI.
  # No indication is given of whether the condition is temporary or permanent.
  def self.gen_404(msg = '')
    msg = 'Error 404: Page not found!' if msg.empty?
    rsp_body = msg + "\n"
    # rsp = "HTTP/1.1 400 Bad Request\r\n" +
    rsp = "HTTP/1.1 404 Not Found\r\n" +
          "Content-Type: text/plain\r\n" +
          "Content-Length: #{rsp_body.bytesize}\r\n" +
          "Connection: close\r\n" +
          "\r\n" +
          rsp_body
    rsp
  end

  # Generates root html response
  # 200 - OK
  # Generates root_url -- the hello page, with description about this task
  # see task1_rails5/app/views/welcome/index.html.haml for example
  def self.gen_root
    file = File.open(File.join($APP_ROOT, 'public/root.html'), 'r')
    rsp_body = file.read + "\n"
    file.close
    rsp = "HTTP/1.1 200 OK\r\n" +
        "Content-Type: text/html\r\n" +
        "Content-Length: #{rsp_body.bytesize}\r\n" +
        "Connection: close\r\n" +
        "\r\n" +
        rsp_body
    rsp
  end

  # Generates time text response
  # +towns_arr+ - the array, I should get to render time in this towns.
  def self.gen_time(towns_arr)

  end
end