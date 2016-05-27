module TimeHelper

  # filter query:
  #  use only English characters and spaces
  def filter_query(query)
    query ||= ''

    # filter all, but English letters, spaces, commas
    query = query.gsub(/[^A-Za-z, ]+/, '')

    # cutting whitespaces from begining and the end
    query.strip
  end

  # will format time to 2015-04-11 10:30:50
  # %Y-%m-%d %H-%M-%S
  def format_time(t)
    t.strftime('%Y-%m-%d %H-%M-%S')
  end
end
