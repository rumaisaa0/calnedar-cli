require "date"
require "json"

class Event
  attr_reader :id
  attr_accessor :title, :description, :date, :starttime, :endtime

  def initialize(id, title, date, starttime, endtime, description)
    @id = id
    @title = title
    @description = description
    @date = date
    @starttime = starttime
    @endtime = endtime
  end

  def to_s
    "Event ID: #{id}, Title: #{@title}, Description: #{@description},
    Date: #{@date}, Start Time: #{@starttime}, End Time: #{@endtime}\n\n"
  end

  def edit(new_title, new_date, new_starttime, new_endtime, new_description)
    @title = new_title
    @description = new_description
    @date = new_date
    @starttime = new_starttime
    @endtime = new_endtime
  end
end
