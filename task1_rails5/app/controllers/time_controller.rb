class TimeController < ApplicationController
  include TimeHelper

  def index
    qs = URI.decode(request.query_string)
    binding.pry
  end
end
