class TimeController < ApplicationController
  include TimeHelper

  layout 'empty'

  def index
    qs = URI.decode(request.query_string)
    t = Time.now.utc
    @result = 'UTC: ' + format_time(t.utc) + "\n"
  end
end
