# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe Event do # rubocop:disable Metrics/BlockLength
  let(:date) { Date.new(2026, 8, 15) }
  let(:start_time) { time_on(date, 9, 0) }
  let(:end_time) { time_on(date, 10, 0) }
  let(:event) do
    described_class.new(1, date, start_time, end_time, title: 'Team meeting', description: 'Weekly sync')
  end

  describe '#initialize' do
    it 'stores all the fields it was given' do
      expect(event.id).to eq(1)
      expect(event.title).to eq('Team meeting')
      expect(event.date).to eq(date)
      expect(event.start_time).to eq(start_time)
      expect(event.end_time).to eq(end_time)
      expect(event.description).to eq('Weekly sync')
    end
  end

  describe '#edit' do
    it 'replaces title, date, times, and description' do
      new_date = Date.new(2026, 9, 1)
      new_start = time_on(new_date, 14, 0)
      new_end = time_on(new_date, 15, 0)

      event.edit(title: 'Renamed', date: new_date, start_time: new_start, end_time: new_end,
                 description: 'New description')

      expect(event.title).to eq('Renamed')
      expect(event.date).to eq(new_date)
      expect(event.start_time).to eq(new_start)
      expect(event.end_time).to eq(new_end)
      expect(event.description).to eq('New description')
    end
  end
end
