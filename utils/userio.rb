require "time"
require "date"

def getuserinput(prompt, default = nil)
  print "#{prompt} "
  input = gets.chomp
  input.empty? ? default : input
end

def getuserinputdate(prompt, default = nil)
  print "#{prompt} "
  input = gets.chomp
  if input.empty? && default.nil?
    puts "Date cannot be empty"
    getuserinputdate(prompt, default)
  elsif !default.nil? && input.empty?
    default
  else
    begin
      Date.parse(input)
    rescue ArgumentError
      puts "Invalid date format. Please enter a valid date (YYYY-MM-DD)."
      getuserinputdate(prompt, default)
    end
  end
end

def getuserinputtime(prompt, date = Date.today, default = nil)
  print "#{prompt} "
  input = gets.chomp
  if input.empty? && !default.nil?
    default
  elsif input.empty? && default.nil?
    puts "Time cannot be empty"
    getuserinputtime(prompt, date, default)
  else
    begin
      temp = Time.parse(input)
      Time.new(date.year, date.month, date.day, temp.hour, temp.min)
    rescue ArgumentError
      puts "Invalid time format. Please enter a valid time (HH:MM)."
      getuserinputtime(prompt, date, default)
    end
  end
end

def getuserinputmonth(prompt = "Enter month and year else press enter to view current month details: ",
                      default = [Date.today.month, Date.today.year])
  print "#{prompt} "
  input = gets.chomp
  if input.empty?
    default
  else
    begin
      parseddate = Date.parse(input)
      [parseddate.month, parseddate.year]
    rescue ArgumentError
      puts "Invalid format. Please enter a valid month and year (e.g., 'August 2026' or '08/2026')."
      getuserinputmonth(prompt, default)
    end
  end
end

def validduaration?(starttime, endtime)
  endtime - starttime > 0
end

def getuserinputid(prompt)
  print "#{prompt} "
  input = gets.chomp
  return input.to_i unless input.empty?

  getuserinputid(prompt)
end
