#! /usr/bin/env ruby
# A ruby script to convert webpage to pdf using webkitgtk

require 'uri'
require './app.rb'

def check_argv
    if ARGV.length != 1
        puts "Usage: #{$0} URI"
        exit!
    end

    uri = ARGV.first
    if not uri  =~ URI::regexp
        puts 'Invalid URI.'
        exit!
    end
end

check_argv

app = App.new
app.add_webpage ARGV.first
#app.zoom_level = 1.3
#app.left_margin = 10
#app.right_margin = 50
#app.bottom_margin = 50
#app.top_margin = 50
app.run
