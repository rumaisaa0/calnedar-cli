require "./calendar"
require_relative "utils/user_io"
require "date"

def edit_menu(calendar)
  return "no events to edit" if calendar.events.empty?

  calendar.list_events
  e_id = get_user_input_id("enter event id of event to edit")
  return "invalid id no such event exists" if calendar.find_event_by_id(e_id).nil?

  title = get_user_input("enter new event title else enter to skip ", calendar.find_event_by_id(e_id).title)
  date = get_user_input_date("enter new event date else enter to skip ", calendar.find_event_by_id(e_id).date)
  start_time = get_user_input_time("enter new event start time else enter to skip ", date,
                                   calendar.find_event_by_id(e_id).start_time)
  end_time = get_user_input_time("enter new event end time else enter to skip ", date,
                                 calendar.find_event_by_id(e_id).end_time)
  return unless valid_dur?(start_time, end_time) && !calendar.clash?(date, start_time, end_time, e_id)

  description = get_user_input("enter new event description else enter to skip ",
                               calendar.find_event_by_id(e_id).description)
  calendar.edit_event(e_id, title, date, start_time, end_time, description)
  "event updated successfully"
end

def valid_choice
  loop do
    choice = gets.chomp.to_i
    return choice if choice > 0 && choice < 9

    puts "choose valid option: "
  end
end

def user_menu(calendar)
  puts "1. Add Event"
  puts "2. Remove Event"
  puts "3. List Events"
  puts "4. Edit Event"
  puts "5. Find Event by Date"
  puts "6. View Date Details"
  puts "7. View Monthly Events"
  puts "8. Exit"
  print "Choose an option: "
  user_choice = valid_choice
  case user_choice
  when 1
    start_time = end_time = 0
    title = get_user_input("enter event title")
    date = get_user_input_date("enter event date")
    date = get_user_input_date("enter valid future event date") while date < Date.today
    loop do
      start_time = get_user_input_time("enter event  start time", date)
      end_time = get_user_input_time("enter event  end time", date)
      puts " End time must be after start time. Please try again." unless valid_dur?(start_time, end_time)
      break if valid_dur?(start_time, end_time)
    end
    description = get_user_input("enter event description")
    calendar.add_event(title, date, start_time, end_time, description)
  when 2
    return puts "no events to remove" if calendar.events.empty?

    puts "current events:"
    calendar.list_events
    id = -1
    loop do
      id = get_user_input_id("enter event id to remove or -1 to exit")
      break if calendar.valid_id?(id) || id == -1

      puts "[alert]: invalid event id "
    end
    puts calendar.remove_event(id) if id != -1
  when 3
    calendar.list_events
  when 4
    msg = edit_menu(calendar)
    puts "#{msg}"
  when 5
    date = get_user_input_date("enter date to view events")
    events = calendar.find_event_by_date(date) unless date.nil?
    if events.empty?
      puts "no events found on #{date}"
    else
      puts events
    end
  when 6
    date = get_user_input_date("enter date to view details")
    calendar.date_details(date) unless date.nil?
  when 7
    month, year = get_user_input_month
    calendar.month_view(month, year)
  when 8
    puts "Exiting..."
    $temp = false
    exit
  else
    puts "Invalid option. Please try again."
    user_menu
  end
end
$temp = true
calendar = Calendar.new
puts "calendar created #{calendar}"
user_menu(calendar) while $temp == true
