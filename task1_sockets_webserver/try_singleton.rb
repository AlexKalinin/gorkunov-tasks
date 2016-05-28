require 'singleton'

class TheSinglton
  include Singleton

  attr_accessor :a, :b
  def print
    puts "a: #{@a}, b: #{@b}"
  end
end


o1 = TheSinglton.instance
o1.a = 5
o1.print


o2 = TheSinglton.instance
o2.a = 2
o2.b = 10

o2.print

o1.print

