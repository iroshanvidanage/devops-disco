#!/bin/ruby

system "clear"

=begin
  ==
  !=
  >
  <
  >=
  <=
=end

puts 2 == 2
puts 2 == 2.0
puts 0.3 == 0.1 + 0.1 + 0.1
puts 2 === 2
puts 2 === 2.0
puts 2 != 2
puts 2 != 3
puts 2 < 3
puts 2 > 3
puts 2 <= 3
puts 2 >= 3

puts "=============================="

puts "john" == "john"
puts "john" == "John"
puts "john" === "John"
puts "john" != "John"
puts "john" > "John"
puts "john" < "John"

=begin

true
true
false
true
true
false
true
true
false
true
false
==============================
true
false
false
true
true
false

=end
puts ""
puts "Special Operators"

a = "hello"
b = "hello"

puts 5 <=> 10
puts 10 <=> 5
puts 10 <=> "John"
puts a == b
puts a.eql?(b)
puts a.equal?(b)
puts a.equal?(a)