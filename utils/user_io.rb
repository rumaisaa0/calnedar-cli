# frozen_string_literal: true

require 'time'
require 'date'

def get_user_input(prompt, default = nil)
  print "#{prompt} "
  input = gets.chomp
  input.empty? ? default : input
end

def get_user_input_date(prompt, default = nil)
  print "#{prompt} "
  input = gets.chomp
  if input.empty? && default.nil?
    puts 'Date cannot be empty'
    get_user_input_date(prompt, default)
  elsif !default.nil? && input.empty?
    default
  else
    begin
      Date.parse(input)
    rescue ArgumentError
      puts 'Invalid date format. Please enter a valid date (YYYY-MM-DD).'
      get_user_input_date(prompt, default)
    end
  end
end

def get_user_input_time(prompt, date = Date.today, default = nil)
  print "#{prompt} "
  input = gets.chomp
  if input.empty? && !default.nil?
    default
  elsif input.empty? && default.nil?
    puts 'Time cannot be empty'
    get_user_input_time(prompt, date, default)
  else
    begin
      temp = Time.parse(input)
      Time.new(date.year, date.month, date.day, temp.hour, temp.min)
    rescue ArgumentError
      puts 'Invalid time format. Please enter a valid time (HH:MM).'
      get_user_input_time(prompt, date, default)
    end
  end
end

def get_user_input_month(prompt = 'Enter month and year else press enter to view current month details: ',
                         default = [Date.today.month, Date.today.year])
  print "#{prompt} "
  input = gets.chomp
  if input.empty?
    default
  else
    begin
      parsed_date = Date.parse(input)
      [parsed_date.month, parsed_date.year]
    rescue ArgumentError
      puts "Invalid format. Please enter a valid month and year (e.g., 'August 2026' or '08/2026')."
      get_user_input_month(prompt, default)
    end
  end
end

def valid_dur?(starttime, endtime)
  (endtime - starttime).positive?
end

def get_user_input_id(prompt)
  print "#{prompt} "
  input = gets.chomp
  return input.to_i unless input.empty?

  get_user_input_id(prompt)
end
