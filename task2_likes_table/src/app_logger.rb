class AppLogger
  def info(msg)
    log msg, 'INFO'
  end

  def debug(msg)
    #log msg, 'DEBUG'
  end

  def warn(msg)
    log msg, 'WARN'
  end

  def error(msg)
    log msg, 'ERROR'
  end

  private
    def log(msg, level)
      puts "[#{Time.now}][#{Time.now.to_f.to_s}][#{level}]\t#{msg}"
    end
end