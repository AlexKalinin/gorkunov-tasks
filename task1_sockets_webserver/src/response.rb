require 'tzinfo'

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
    result = 'UTC: ' + Response.format_time(Time.now.utc) + "\n"

    towns_arr ||= []
    towns_arr.each do |town|
      next if town.empty?
      TZInfo::Timezone.all.each do |tz|
        if Response.tokenize_timezone(tz.name).include?(Response.tokenize_timezone(town))
          result << town + ': ' + Response.format_time(Time.now) + "\n"
          break
        end
      end
    end

    result
  end



  def self.format_time(t)
    t.strftime('%Y-%m-%d %H-%M-%S')
  end


  # Get toket from timezone name
  # For example
  #   New York --> newyork
  #   New_York --> newyork
  #   neW_york --> newyork
  def self.tokenize_timezone(tz)
    tz ||= ''
    tz = tz.gsub(/[^A-Za-z]+/, '')
    tz.downcase
  end
end