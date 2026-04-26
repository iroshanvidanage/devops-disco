#!/bin/ruby

system "clear"

load 'classes.rb'

class Draw < Rectangle
  def initialize
    super
  end

  def draw
    puts "*" * length
  end
end

