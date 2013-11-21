#!/usr/bin/env ruby

puts "box\t\t\t\tstatus\t\t\tprovider\t\t\tstate"
puts "---\t\t\t\t------\t\t\t--------\t\t\t-----"

Dir.foreach(".") do |dir|
  if Dir.exists? dir
    if dir != '.' && dir != '..'
      Dir.chdir dir
      i = 0
      IO.popen(["vagrant", "status"]).each do |line|
        if i == 2
          words = line.split(' ')
          box_length = dir.length
          if box_length > 9 && box_length < 17
            puts "#{dir}\t\t\t#{words[1]}\t\t#{words[2][1..-2]}\t\t\t#{words[0]}"
          elsif box_length > 17
            puts "#{dir}\t#{words[1]}\t\t#{words[2][1..-2]}\t\t\t#{words[0]}"
          else
            puts "#{dir}\t\t#{words[1]}\t\t#{words[2][1..-2]}\t\t\t#{words[0]}"
          end
        end
        i += 1
      end
      Dir.chdir ".."
    end
  end
end
