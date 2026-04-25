#!/bin/ruby

system "clear"

age = 39
puts age
puts age += 1
puts age /= 2
puts age **= 2
puts age %= 5

a = 10
b = 20
puts "a #{a}, b #{b}"

a, b = b, a
puts "a #{a}, b #{b}"

a, *b = 1, 2, 3, 4
puts "a #{a}, b #{b}"