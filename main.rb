# frozen_string_literal: true

require './calendar'
require_relative 'utils/user_io'
require 'date'

def edit_menu(calendar)
  event = edit_approval(calendar)
  return if event.nil?

  details = edit_details(calendar, event)
  return if details.nil?

  title, date, start_time, end_time, description = details

  calendar.edit_event(event.id, title: title, date: date, start_time: start_time, end_time: end_time,
                                description: description)

  puts 'Event updated successfully.'
end

def find_event_for_edit(calendar)
  e_id = get_user_input_id('enter event id of event to edit')
  puts 'invalid id no such event exists' if calendar.find_event_by_id(e_id).nil?
  calendar.find_event_by_id(e_id)
end

def edit_approval(calendar)
  return puts 'no events to edit' if calendar.events.empty?

  calendar.list_events
  find_event_for_edit(calendar)
end

def edit_details(calendar, event)
  title = get_user_input('enter new event title else enter to skip ', event.title)
  date = get_user_input_date('enter new event date else enter to skip ', event.date)
  start_time = get_user_input_time('enter new event start time else enter to skip ', date,
                                   event.start_time)
  end_time = get_user_input_time('enter new event end time else enter to skip ', date,
                                 event.end_time)
  return unless valid_edit_times?(calendar, event, date, start_time, end_time)

  description = get_user_input('enter new event description else enter to skip ',
                               event.description)
  [title, date, start_time, end_time, description]
end

def valid_edit_times?(calendar, event, date, start_time, end_time)
  unless valid_duration?(start_time, end_time)
    puts 'Invalid event time: the end time must be after the start time.'
    return false
  end

  if calendar.clash?(date, start_time, end_time, current_id: event.id)
    puts 'Unable to update event: the selected time overlaps with another event.'
    return false
  end

  true
end

def valid_choice
  loop do
    choice = gets.chomp.to_i
    return choice if choice.positive? && choice < 9

    puts 'choose valid option: '
  end
end

def find_event_by_date_helper(calendar)
  date = get_user_input_date('enter date to view events')
  events = calendar.find_event_by_date(date) unless date.nil?
  if events.empty?
    puts "no events found on #{date}"
  else
    puts events
  end
end

def date_details_helper(calendar)
  date = get_user_input_date('enter date to view details')
  calendar.date_details(date) unless date.nil?
end

def month_view_helper(calendar)
  month, year = get_user_input_month
  calendar.month_view(month, year)
end

def print_menu
  puts '1. Add Event'
  puts '2. Remove Event'
  puts '3. List Events'
  puts '4. Edit Event'
  puts '5. Find Event by Date'
  puts '6. View Date Details'
  puts '7. View Monthly Events'
  puts '8. Exit'
  print 'Choose an option: '
end

def menu_choice(user_choice, calendar)
  case user_choice
  when 1 then add_event_helper(calendar)
  when 2 then remove_event_helper(calendar)
  when 4 then edit_menu(calendar)
  when 5 then find_event_by_date_helper(calendar)
  when 6 then date_details_helper(calendar)
  when 7 then month_view_helper(calendar)
  end
end

def exit_helper
  puts 'Exiting...'
  exit
end

def add_event_helper(calendar)
  title = get_user_input('enter event title')
  description = get_user_input('enter event description')
  date = valid_date
  start_time, end_time = valid_time(date)
  calendar.add_event(date, start_time, end_time, { title: title, description: description })
end

def valid_date
  date = get_user_input_date('enter event date')
  date = get_user_input_date('enter valid future event date') while date < Date.today
  date
end

def valid_time(date)
  start_time = end_time = 0
  loop do
    start_time = get_user_input_time('enter event  start time', date)
    end_time = get_user_input_time('enter event  end time', date)
    puts ' End time must be after start time. Please try again.' unless valid_duration?(start_time, end_time)
    break if valid_duration?(start_time, end_time)
  end
  [start_time, end_time]
end

def remove_event_helper(calendar)
  return puts 'no events to remove' if calendar.events.empty?

  puts 'current events:'
  calendar.list_events
  id = -1
  loop do
    id = get_user_input_id('enter event id to remove or -1 to exit')
    break if calendar.valid_id?(id) || id == -1

    puts '[alert]: invalid event id '
  end
  puts calendar.remove_event(id) if id != -1
end

def user_menu(calendar)
  print_menu
  user_choice = valid_choice
  if user_choice < 1 || user_choice > 8
    puts 'Invalid option. Please try again.'
  elsif user_choice == 3 then calendar.list_events
  elsif user_choice == 8 then exit_helper
  else
    menu_choice(user_choice, calendar)
  end
end
calendar = Calendar.new
puts "calendar created #{calendar}"
loop do
  user_menu(calendar)
end
