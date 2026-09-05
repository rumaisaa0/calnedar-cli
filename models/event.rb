# frozen_string_literal: true

require 'date'
require 'json'
# event class objects have composition in calendar
class Event
  attr_reader :id
  attr_accessor :title, :description, :date, :start_time, :end_time

  def initialize(id, date, start_time, end_time, attributes = {})
    @id = id
    @title = attributes[:title]
    @description = attributes[:description]
    @date = date
    @start_time = start_time
    @end_time = end_time
  end

  def to_s
    "Event ID: #{id}, Title: #{@title}, Description: #{@description},
    Date: #{@date}, Start Time: #{@start_time}, End Time: #{@end_time}\n\n"
  end

  def edit(attributes)
    @title = attributes[:title] if attributes.key?(:title)
    @description = attributes[:description] if attributes.key?(:description)
    @date = attributes[:date] if attributes.key?(:date)
    @start_time = attributes[:start_time] if attributes.key?(:start_time)
    @end_time = attributes[:end_time] if attributes.key?(:end_time)
  end
end
