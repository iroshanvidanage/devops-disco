#!/bin/ruby

system "clear"

names = ["John", "Tim", "Mary", "Tina", "Kaitlin"]

pizza = {
  "John"    => "Pepperoni",
  "Tim"     => "Mushroom",
  "Mary"    => "Cheese",
  "Tina"    => "Chicken",
  "Kaitlin" => "Margherita"
}

names.each do | name |
  puts "#{ pizza[name] } Pizza for #{ name }"
end