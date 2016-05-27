class TimeController < ApplicationController
  include TimeHelper

  def index
    @result = 'UTC: ' + format_time(Time.now.utc) + "\n"

    qs = URI.decode(request.query_string)
    qs = filter_query(qs)
    unless qs.empty?
      # Town.where({name: qs.split(',')}).each do |twn|
      Town.find_towns_by_query(qs).each do |twn|
        #binding.pry
        @result << twn.name + ': ' + format_time(twn.get_local_time) + "\n"
      end
    end

    render plain: @result
  end
end
