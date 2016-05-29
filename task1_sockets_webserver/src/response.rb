require 'tzinfo'

# HTTP-responses generator
class Response

  # Low level response generation
  # * +resp_code+ - integer, HTTP response code, for example 200, 400, 404, 500..
  #                 Please, checkout RFC: https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html for details.
  # * +resp_msg+ - string, HTTP response message, for example "Bad Request", "OK", "Not Found"
  #                 Please, checkout RFC: https://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html
  # * +content_type+ - string, responce content type, for example: "text/plain", "text/html"
  #                 Please, checkout RFC: https://www.ietf.org/rfc/rfc2045.txt
  # * +resp_body+ - string, our responce body, for example some text data or some html content.
  def self.gen_responce(resp_code, resp_msg, content_type, resp_body)
    resp_body = resp_body + "\n"
    rsp = "HTTP/1.1 #{resp_code} #{resp_msg}\r\n" +
        "Content-Type: #{content_type}\r\n" +
        "Content-Length: #{resp_body.bytesize}\r\n" +
        "Connection: close\r\n" +
        "\r\n" +
        resp_body
    rsp
  end

  # 400 Bad Request
  # see https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
  #
  # The request could not be understood by the server due to malformed syntax.
  # The client SHOULD NOT repeat the request without modifications.
  def self.gen_400(msg = '')
    msg = 'Error 400: Bad Request!' if msg.empty?
    Response.gen_responce(400, 'Bad Request', 'text/plain', msg)
  end

  # Generates Not Found response
  # 404 Not Found
  # see https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
  #
  # The server has not found anything matching the Request-URI.
  # No indication is given of whether the condition is temporary or permanent.
  def self.gen_404(msg = '')
    msg = 'Error 404: Page not found!' if msg.empty?
    Response.gen_responce(404, 'Not Found', 'text/plain', msg)
  end

  # Generates root html response
  # 200 - OK
  # Generates root_url -- the hello page, with description about this task
  # see task1_rails5/app/views/welcome/index.html.haml for example
  def self.gen_root
    file = File.open(File.join($APP_ROOT, 'public/root.html'), 'r')
    rsp_body = file.read + "\n"
    file.close
    Response.gen_responce(200, 'OK', 'text/html', rsp_body)
  end

  # Generates time text response
  # +towns_arr+ - the array, I should get to render time in this towns.
  def self.gen_time(towns_arr)
    result = 'UTC: ' + Response.format_time(Time.now.utc) + "\n"

    towns_arr ||= []
    towns_arr.each do |town|
      t_town = Response.tokenize_timezone(town)
      next if t_town.empty?
      TZInfo::Timezone.all.each do |tz|
        if Response.tokenize_timezone(tz.name).include?(t_town)
          result << town + ': ' + Response.format_time(tz.utc_to_local(Time.now.utc)) + "\n"
          break
        end
      end
    end

    Response.gen_responce(200, 'OK', 'text/plain', result)
  end


  # Format time with
  # YYYY-MM-DD hh-mm-ss
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