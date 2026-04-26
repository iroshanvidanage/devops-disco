#!/bin/ruby

system "clear"

range = 1..100

# given solution

range.each do | num |
  if num % 3 == 0 && num % 5 == 0
    puts "#{ num } - FIZZBUZZ!."
  elsif num % 3 == 0
    puts "#{ num } - FIZZ!."
  elsif num % 5 == 0
    puts "#{ num } - BUZZ!."
  else
    puts "#{ num }."
  end
end

############################################

for num in range
  label = ""
  if num % 3 == 0
    label += "FIZZ"
  end
  if num % 5 == 0
    label += "BUZZ"
  end
  puts "#{ num } #{ label }"
end

############################################

rules = {
  3 => "FIZZ",
  5 => "BUZZ"
}

range.each do | num |
  label = rules.select { |divisor, _| num % divisor == 0}.values.join
  results = label.empty? ? num : label
  puts "#{ num } - #{ results }."
end