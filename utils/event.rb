require "date"
require "json"

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

  def month_view
    details = []
    details << @id
    details << @title.to_s if @title
    details << @description.to_s if @date
    details << @start_time.strftime("%H:%M")
    details << @end_time.strftime("%H:%M")

    puts details.join(", ")
  end

  def edit(new_title, new_date, new_start_time, new_end_time, new_description)
    @title = new_title
    @description = new_description
    @date = new_date
    @start_time = new_start_time
    @end_time = new_end_time
  end
end
