# frozen_string_literal: true

require 'date'
require 'json'
# event class objects have composition in calendar
class Event
  attr_reader :id
  attr_accessor :title, :description, :date, :start_time, :end_time

  def initialize(id, title, date, start_time, end_time, description)
    @id = id
    @title = title
    @description = description
    @date = date
    @start_time = start_time
    @end_time = end_time
  end

  def to_s
    "Event ID: #{id}, Title: #{@title}, Description: #{@description},
    Date: #{@date}, Start Time: #{@start_time}, End Time: #{@end_time}\n\n"
  end

  # def month_view
  #   details = []
  #   details << @id
  #   details << @title.to_s if @title
  #   details << @description.to_s if @description
  #   details << @start_time.strftime('%H:%M')
  #   details << @end_time.strftime('%H:%M')

  #   puts details.join(', ')
  # end

  def edit(attributes)
    @title = attributes[:title]
    @description = attributes[:description]
    @date = attributes[:date]
    @start_time = attributes[:start_time]
    @end_time = attributes[:end_time]
  end
end
