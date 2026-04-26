#!/bin/ruby

system "clear"

puts 10 + 5
puts 10.0 + 5
puts 10 - 5.5
puts 10 / 5
puts 10.0 / 5
puts 10 / 3
puts 10 / 3.3
puts 10.0 / 3
puts 10 % 5
puts 10 % 3
puts 10 * 5
puts 10 ** 3.1


num_1 = 10
num_2 = 5.0

puts num_1 + num_2

print "Enter a number: "
number = gets

# puts number + 10
# arithmatic.rb:27:in `+': no implicit conversion of Integer into String (TypeError)

# puts number + 10
#               ^^
#         from arithmatic.rb:27:in `<main>'

puts number.to_i + 10 # converts to an integer
puts "#{number.to_f + 15}" # converts to a float

# 15
# 15.0
# 4.5
# 2
# 2.0
# 3
# 3.0303030303030303
# 3.3333333333333335
# 0
# 1
# 50
# 1258.9254117941675
# 15.0
# Enter a number: 3.6
# 13
# 18.6