module TimeHelper

  # filter query:
  #  use only English characters and spaces
  def filter_query(query)
    query ||= ''

    # replace ё -> е (ruby's regex don't know about ё and е)
    query = query.gsub(/Ё|ё/, 'е')

    ## we don't need many spaces, but only one for each city name
    # query = query.gsub(/\s+/, ' ')

    # filter all, but russian and eglish letters, spaces, commas
    query = query.gsub(/[^A-Za-zА-Яа-я,]+/, '') # query.gsub(/[^A-Za-zА-Яа-я, ]+/, '')

    # cutting whitespaces from begining and the end
    query = query.strip

    # converting all characters to downcase, including non-English chars
    query.mb_chars.downcase.to_s
  end

end
