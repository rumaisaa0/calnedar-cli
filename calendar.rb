require_relative "utils/event"
require_relative "utils/userio"

class Calendar
  attr_accessor :events

  def initialize
    @events = []
    # read from file an dload in array
  end

  def add_event(title, date, starttime, endtime, description)
    if !clash?(date, starttime, endtime)
      lastid = @events.map(&:id).max || 0
      event = Event.new(lastid + 1, title, date, starttime, endtime, description)
      @events << event
      puts "event added successfully"
    else
      puts "clash detected"
    end
  end

  def remove_event(id)
    event = find_event_by_id(id)
    @events.delete(event)
    "event remove successful!"
  end

  def list_events
    puts " no events to display" if @events.empty?
    @events.each do |event|
      puts event
    end
  end

  def edit_event(id, new_title, new_date, new_starttime, new_endtime, new_description)
    event = find_event_by_id(id)
    event.edit(new_title, new_date, new_starttime, new_endtime, new_description)
    print "in edit calendar successful"
  end

  def find_event_by_date(date)
    @events.select { |event| event.date == date } || []
  end

  def find_event_by_title(title)
    @events.select { |event| event.title == title } || []
  end

  def validid?(tid)
    !!find_event_by_id(tid)
  end

  def find_event_by_id(id)
    @events.find { |event| event.id == id }
  end

  def clash?(date, starttime, endtime, curr_id = nil)
    @events.each do |currevent|
      if currevent.id != curr_id && currevent.date == date && currevent.starttime < endtime && starttime < currevent.endtime
        return true
      end
    end
    false
  end

  def date_details(date)
    events_on_date = find_event_by_date(date)
    if events_on_date.empty?
      puts "No events found on #{date}."
    else
      puts "Events on #{date}:"
      events_on_date.each do |event|
        puts event
      end
    end
  end

  def find_event_by_month(month, year)
    events_in_month = @events.select do |event|
      event.date.month == month && event.date.year == year
    end
  end

  def monthly_events(month, year)
    events_in_month = find_event_by_month(month, year)

    if events_in_month.empty?
      puts "No events found in #{Date::MONTHNAMES[month]} #{year}."
    else
      puts "Events in #{Date::MONTHNAMES[month]} #{year}:"
      events_in_month.each do |event|
        puts event
        puts "-" * 20
      end
    end
  end
end
