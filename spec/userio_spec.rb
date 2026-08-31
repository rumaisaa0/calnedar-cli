# frozen_string_literal: true

require_relative 'c_spec'
require_relative '../utils/user_io'

RSpec.describe 'valid_dur?' do
  let(:date) { Date.new(2026, 8, 15) }

  it 'is true when the end time is after the start time' do
    start_time = time_on(date, 9, 0)
    end_time = time_on(date, 10, 0)

    expect(valid_dur?(start_time, end_time)).to be true
  end

  it 'is false when the end time is before the start time' do
    start_time = time_on(date, 10, 0)
    end_time = time_on(date, 9, 0)

    expect(valid_dur?(start_time, end_time)).to be false
  end

  it 'is false when the start and end time are the same' do
    time = time_on(date, 9, 0)

    expect(valid_dur?(time, time)).to be false
  end
end
