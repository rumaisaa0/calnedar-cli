require_relative "utils/event"
require_relative "utils/user_io"

class Calendar
  attr_accessor :events

  def initialize
    @events = []
    # read from file and load in array
  end

  def add_event(title, date, start_time, end_time, description)
    if !clash?(date, start_time, end_time)
      last_id = @events.map(&:id).max || 0
      event = Event.new(last_id + 1, title, date, start_time, end_time, description)
      @events << event
      puts "event added successfully"
    else
      puts "clash detected"
    end
  end

  def remove_event(id)
    event = find_event_by_id(id)
    return if event.nil?

    @events.delete(event)
    "event remove successful!"
  end

  def list_events
    puts " no events to display" if @events.empty?
    @events.each do |event|
      puts event
    end
  end

  def edit_event(id, new_title, new_date, new_start_time, new_end_time, new_description)
    event = find_event_by_id(id)
    return if event.nil?

    event.edit(new_title, new_date, new_start_time, new_end_time, new_description)
    print "in edit calendar successful"
  end

  def find_event_by_date(date)
    @events.select { |event| event.date == date } || []
  end

  def valid_id?(tid)
    !!find_event_by_id(tid)
  end

  def find_event_by_id(id)
    @events.find { |event| event.id == id }
  end

  def clash?(date, start_time, end_time, curr_id = nil)
    @events.each do |curr_event|
      if curr_event.id != curr_id && curr_event.date == date &&
         curr_event.start_time < end_time && start_time < curr_event.end_time
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

  def event_count_by_day(month, year)
    counts = Hash.new(0)
    find_event_by_month(month, year).each do |event|
      counts[event.date.day] += 1
    end
    counts
  end

  def month_view(month, year, col = 16)
    first_day = Date.new(year, month, 1)
    last_day = Date.new(year, month, -1)
    counts = event_count_by_day(month, year)

    puts "#{Date::MONTHNAMES[month]} #{year}".center(col * 7)
    puts %w[Sun Mon Tue Wed Thu Fri Sat].map { |day| day.ljust(col) }.join
    print " " * col * first_day.wday
    (first_day..last_day).each do |date|
      cell = date.day.to_s
      cell += "(#{counts[date.day]})" if counts[date.day].positive?
      print cell.ljust(col)
      puts "" if date.wday == 6
    end
    puts "" unless last_day.wday == 6
  end
end
