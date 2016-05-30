class StatsHelper
  def self.print_stats(t_start, t_end, query, times)
    sum = 0.0
    counter = 0
    details = ''
    times.each do |t|
      sum += t[:diff]
      details << "\t##{counter}: diff: #{t[:diff] * 1000} mls\n"
      counter += 1
    end
    sum /= times.count


    str = "\n==== STATISTICS:\n" +
        "\tquery: #{query}\n" +
        details +
        "\t----------------------------------\n" +
        "\tbegin time: #{t_start}\n" +
        "\tend time: #{t_end}\n" +
        "\taverage time: #{sum * 1000}(milliseconds, for #{times.count} tries)\n"
    $logger.info(str.colorize(:light_cyan))
  end
end
