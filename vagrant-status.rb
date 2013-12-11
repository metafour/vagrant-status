#!/usr/bin/env ruby

require 'optparse'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: vagrant-status.rb [options] directory/"

  opts.on("-c", "--color", "colorize output") { |color| options[:colorize] = color }
end.parse!

# box length is limited to 30 characters

puts "box\t\t\t\tstatus\t\t\tprovider\t\tstate"
puts "---\t\t\t\t------\t\t\t--------\t\t-----"

spacer = "                               "
count = 0

Dir.foreach(".") do |dir|
  if Dir.exists? dir
    if dir != '.' && dir != '..'
      Dir.chdir dir
      i = 0
      IO.popen(["vagrant", "status"]).each do |line|
        if i == 2
          words = line.split(' ')
          spaces = 31 - dir.length
          if spaces <= 0
            count += 1
            if options[:colorize]
              printf "\033[0;35m" if count % 2 == 0
            end
            puts dir[0..30] + "…" + words[1] + spacer[0..(23 - words[1].length)] + words[2][1..-2] + spacer[0..(23 - words[2][1..-2].length)] + words[0]
            printf "\033[0m"
            if !options[:colorize]
              90.times { print "-" }
              puts
            end
          else
            count += 1
            if options[:colorize]
              printf "\033[0;35m" if count % 2 == 0
            end
            puts dir + spacer[0..(31 - dir.length)] + words[1] + spacer[0..(23 - words[1].length)] + words[2][1..-2] + spacer[0..(23 - words[2][1..-2].length)] + words[0]
            printf "\033[0m"
            if !options[:colorize]
              90.times { print "-" }
              puts
            end
          end
        end
        i += 1
      end
      Dir.chdir ".."
    end
  end
end
