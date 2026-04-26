#!/bin/ruby

system "clear"

first_name = "John"
_second_name = "Baron"
age = 30
address = "Colombo, Sri Lanka"

puts first_name, _second_name
puts first_name + _second_name
puts first_name + " " + _second_name
puts [first_name, _second_name]
puts "#{first_name} #{_second_name}"
# puts "Age: " + age this tries to add two types of data string and int
puts "Age: #{age}"
puts "Address: " + address