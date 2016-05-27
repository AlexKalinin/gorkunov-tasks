class Town < ApplicationRecord

  # Get current local time in the town
  def get_local_time
    Time.now.getlocal(time_zone)
  end

  # Find towns by clear query
  # query format:
  #   Moscow, New York, Bishkek
  # WARNING: result is cached!
  def self.find_towns_by_query(query)
    Rails.cache.fetch("towns/find_towns_by_query/#{query}", expires_in: 1.day) do
      self.where({name: query.split(',')})
    end
  end

end
