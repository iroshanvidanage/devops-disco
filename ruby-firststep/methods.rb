#!/bin/ruby

system "clear"



def hello(name, time="09:00")
  puts "Hello #{greet(time)} #{name}"
end

def greet(time)
  return "Morning, It's #{time} now,"
end

hello("Iroshan", "10:00")

print "Enter your name: "
hello(gets)