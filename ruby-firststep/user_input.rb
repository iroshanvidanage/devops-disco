#!/bin/ruby

system "clear"

print "Enter Your First Name: "
first_name = gets
print "Enter Your Last Name: "
last_name = gets.chomp

p first_name, last_name
puts last_name, first_name
print first_name, last_name

puts "Hello #{ first_name }, how are you doing?"
print "Hello #{ last_name }, how are you doing?\n"

# Enter Your First Name: iroshan
# Enter Your Last Name: vidanage
# "iroshan\n"
# "vidanage"
# vidanage
# iroshan
# iroshan
# vidanageHello iroshan
# , how are you doing?
# Hello vidanage, how are you doing?