#!/bin/ruby

system "clear"

class Square

  def initialize(side_length)
    @side_length = side_length
  end

  def to_s
    return "Side Length: #{@side_length}\nPerimeter: #{perimeter}\nArea: #{area}"
  end

  # getter
  def side_length
    return @side_length
  end

  # setter
  def side_length=(side_length)
    @side_length = side_length
  end

  def area
    return @side_length ** 2
  end

  def perimeter
    return @side_length * 4
  end

end

my_square = Square.new(side_length=10)

puts my_square.inspect
puts my_square.side_length
puts my_square.perimeter
puts my_square.area
puts my_square.to_s
my_square.side_length = 20
puts my_square.side_length
puts my_square.perimeter
puts my_square.area
puts my_square.to_s


# accessor usage

class Rectangle
  attr_accessor :width, :length
  def initialize(width, length)
    @width = width
    @length = length
  end

  def to_s
    return "Wdith: #{width}\nLength: #{length}\nPerimeter: #{perimeter}\nArea: #{area}"
  end

  def area
    return width * length
  end

  def perimeter
    return 2 * (width + length)
  end
end


puts "\n"

my_rectangle = Rectangle.new(width=5, length=10)

puts my_rectangle.inspect
puts my_rectangle.width
puts my_rectangle.length
puts my_rectangle.to_s
my_rectangle.width = 10
my_rectangle.length = 20
puts my_rectangle.width
puts my_rectangle.length
puts my_rectangle.to_s


# class inheritence

class Draw < Rectangle
  def initialize(width, length)
    super(width, length)
  end

  def draw
    puts "*" * @length
    (@width - 2).times do
      print "*" + (" " * (@length - 2)) + "*\n"
    end
    puts "*" * @length
  end
end

my_draw = Draw.new(width=5, length=10)
puts "\n"
my_draw.draw