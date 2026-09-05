# frozen_string_literal: true

require_relative 'models/event'
require_relative 'utils/user_io'
require_relative 'utils/calendar_view'

# Manages calendar events, including adding, updating, and removing events.
class Calendar
  attr_accessor :events

  def initialize
    @events = {}
  end

  def add_event(date, start_time, end_time, attributes = {})
    if clash?(date, start_time, end_time)
      puts 'Event could not be added because it clashes with an existing event.'
      nil
    else
      event = Event.new(next_event_id, date, start_time, end_time, attributes)

      @events[event.id] = event

      puts "Event '#{event.title}' added successfully."
    end
  end

  def remove_event(id)
    event = find_event_by_id(id)
    return if event.nil?

    @events.delete(id)
    'event deleted successful!'
  end

  def list_events
    return puts ' no events to display' if @events.empty?

    display(@events.values)
  end

  def edit_event(id, attributes)
    event = find_event_by_id(id)
    return if event.nil?

    event.edit(attributes)
    # print 'in edit calendar successful'
  end

  def find_event_by_date(date)
    @events.values.select { |event| event.date == date }
  end

  def valid_id?(id)
    @events.key?(id)
  end

  def find_event_by_id(id)
    @events[id]
  end

  def clash?(date, start_time, end_time, options = {})
    current_id = options[:current_id]

    @events.values.any? do |curr_event|
      curr_event.id != current_id && curr_event.date == date &&
        curr_event.start_time < end_time && start_time < curr_event.end_time
    end
  end

  def date_details(date)
    events_on_date = find_event_by_date(date)
    if events_on_date.empty?
      puts "No events found on #{date}."
    else
      puts "Events on #{date}:"
      display(events_on_date)
    end
  end

  def find_event_by_month(month, year)
    @events.values.select do |event|
      event.date.month == month && event.date.year == year
    end
  end

  def monthly_events(month, year)
    events_in_month = find_event_by_month(month, year)

    if events_in_month.empty?
      puts "No events found in #{Date::MONTHNAMES[month]} #{year}."
    else
      puts "Events in #{Date::MONTHNAMES[month]} #{year}:"
      display(events_in_month)
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
    first_day, last_day = first_last_day_of_month(month, year)
    counts = event_count_by_day(month, year)

    print_month_header(month, year, col)
    print_calendar_days(first_day, last_day, counts, col)
  end

  def first_last_day_of_month(month, year)
    first_day = Date.new(year, month, 1)
    last_day = Date.new(year, month, -1)
    [first_day, last_day]
  end

  private

  def next_event_id
    (@events.keys.max || 0) + 1
  end

  def display(events)
    events.each do |event|
      puts event
      puts '-' * 20
    end
  end
end
