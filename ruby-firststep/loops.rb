#!/bin/ruby

system "clear"

# variables
names = ["John", "Tim", "Mary", "Tina", "Kaitlin"]
print "Enter number: "
lines = gets.to_i

# looping constructs
# while loops
num = 1
while num < 10
  puts num
  num += 1
end

num = 1
while num < lines
  puts "*" * num
  num += 1
end

# until loops
num = 1
spaces = 2 * lines - 1
until num > lines
  puts ("*" * (2 * num - 1)).center(spaces)
  num += 1
end

# for loops
for i in 1..lines
  puts "*" * i
end

for n in names
  puts "He he #{n}"
end

# loop
num = 1
loop do
  break if num > 10
  puts "Running..."
  num += 1
end

num = 1
while true # loop do
  break if num > 10
  print "Running..."
  num += 1
end
puts "\n"

# iterators
# each
(1..lines).each do | num |
  puts num
end

names.each do | name |
  puts "Hello #{name}"
end

[1, 2, 3].each { |element| puts element }

# .map
squares = [1, 2, 3].map { |n| n**2 } #=> [1, 4, 9]
print squares, "\n"

# .map!
sq_array = [1, 2, 3, 4]
print sq_array, "\n"
sq_array.map! do | item |
  item = item ** 2
end
print sq_array, "\n"

# .collect
cubes = [1, 2, 3].collect { |n| n**3 }
print cubes, "\n"

# .select
evens = (1..lines).select { | i | i.even? }
print evens, "\n"

# .times
5.times { puts "Hello" }

# step
(1..10).step(2) { |n| puts n } # 1, 3, 5, 7, 9
