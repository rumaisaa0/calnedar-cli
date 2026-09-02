# frozen_string_literal: true

require_relative '../utils/event'
require_relative '../calendar'
require 'date'
require 'time'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed
end
def time_on(date, hour, minute)
  Time.new(date.year, date.month, date.day, hour, minute)
end
