#!/bin/ruby

system "clear"

print "Enter a number between 1 - 10: "
num = gets.to_i

if 0 >= num  || num > 10
  puts "Hey the number should be 1 - 10"
elsif num > 5
  puts "#{ num } is greater than 5"
elsif num == 5
  puts "#{ num } is equal to 5"
else
  puts "#{ num } is less than 5"
end

print "Enter your name: "
name = gets.chomp

if name == "Iro"
  puts "Hello #{ name }"
else
  puts "I don't know #{ name }"
end

print "Enter your age: "
age = gets.to_i

unless age < 18
  puts "You can watch a movie"
end

is_child = age > 18 ? true : false
puts "You are a(n) #{ "adult" if is_child }"

case name
when "Iro"
  puts "Hi #{ name }"
when "Son"
  puts "Hi #{ name }"
else
  puts "Hi #{ name } the stranger"
end


puts "Eligible" if age >= 18
puts "Not allowed" unless is_child
