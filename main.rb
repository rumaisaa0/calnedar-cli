require "./calendar"
require_relative "utils/userio"
require "date"

def editmenu(calendar)
  return "no events to edit" if calendar.events.empty?

  calendar.list_events
  e_id = getuserinputid("enter event id of event to edit")
  return "invalid id no such event exists" if calendar.find_event_by_id(e_id).nil?

  title = getuserinput("enter new event title else enter to skip ", calendar.find_event_by_id(e_id).title)
  date = getuserinputdate("enter new event date else enter to skip ", calendar.find_event_by_id(e_id).date)
  starttime = getuserinputtime("enter new event start time else enter to skip ", date,
                               calendar.find_event_by_id(e_id).starttime)
  endtime = getuserinputtime("enter new event end time else enter to skip ", date,
                             calendar.find_event_by_id(e_id).endtime)
  return unless validduaration?(starttime, endtime) && !calendar.clash?(date, starttime, endtime, e_id)

  description = getuserinput("enter new event description else enter to skip ",
                             calendar.find_event_by_id(e_id).description)
  calendar.edit_event(e_id, title, date, starttime, endtime, description)
  "event updated successfully"
end

def validchoice
  loop do
    choice = gets.chomp.to_i
    return choice if choice > 0 && choice < 9

    puts "choose valid option: "
  end
end

def usermenu(calendar)
  puts "1. Add Event"
  puts "2. Remove Event"
  puts "3. List Events"
  puts "4. Edit Event"
  puts "5. Find Event by Date"
  puts "6. View Date Details"
  puts "7. View Monthly Events"
  puts "8. Exit"
  print "Choose an option: "
  userchoice = validchoice
  case userchoice
  when 1
    starttime = endtime = 0
    title = getuserinput("enter event title")
    date = getuserinputdate("enter event date")
    date = getuserinputdate("enter valid future event date") while date < Date.today
    loop do
      starttime = getuserinputtime("enter event  start time", date)
      endtime = getuserinputtime("enter event  end time", date)
      puts " End time must be after start time. Please try again." unless validduaration?(starttime, endtime)
      break if validduaration?(starttime, endtime)
    end
    description = getuserinput("enter event description")
    calendar.add_event(title, date, starttime, endtime, description)
  when 2
    return puts "no events to remove" if calendar.events.empty?

    puts "current events:"
    calendar.list_events
    id = -1
    loop do
      id = getuserinputid("enter event id to remove or -1 to exit")
      break if calendar.validid?(id) || id == -1

      puts "[alert]: invalid event id "
    end
    puts calendar.remove_event(id) if id != -1
  when 3
    calendar.list_events
  when 4
    mssg = editmenu(calendar)
    puts "#{mssg}"
  when 5
    date = getuserinputdate("enter date to view events")
    events = calendar.find_event_by_date(date) unless date.nil?
    if events.empty?
      puts "no events found on #{date}"
    else
      puts events
    end
  when 6
    date = getuserinputdate("enter date to view details")
    calendar.date_details(date) unless date.nil?
  when 7
    month, year = getuserinputmonth
    calendar.monthly_events(month, year)
  when 8
    puts "Exiting..."
    $temp = false
    exit
  else
    puts "Invalid option. Please try again."
    usermenu
  end
end
$temp = true
calendar = Calendar.new
puts "calendar created #{calendar}"
usermenu(calendar) while $temp == true
