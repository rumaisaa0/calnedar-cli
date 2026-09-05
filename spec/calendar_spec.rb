# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe Calendar do # rubocop:disable Metrics/BlockLength
  subject(:calendar) { described_class.new }

  let(:date) { Date.new(2026, 8, 15) }

  def add(calendar, title, start_hour, end_hour, on_date: date)
    calendar.add_event(on_date, time_on(on_date, start_hour, 0), time_on(on_date, end_hour, 0), title: title)
  end
  let(:overlapping_event) do
    { title: 'Overlapping',
      description: 'd' }
  end

  describe '#add_event' do
    it 'adds the event when there is no time clash' do
      expect { add(calendar, 'Meeting', 9, 10) }.to change { calendar.events.size }.from(0).to(1)
    end

    it 'does not add the event when it overlaps an existing one on the same date' do
      add(calendar, 'Meeting', 9, 10)

      expect do
        calendar.add_event(date, time_on(date, 9, 30), time_on(date, 10, 30),
                           overlapping_event)
      end
        .not_to(change { calendar.events.size })
    end

    it 'prints a clash message when the times overlap' do
      add(calendar, 'Meeting', 9, 10)

      expect do
        calendar.add_event(date, time_on(date, 9, 30), time_on(date, 10, 30), overlapping_event)
      end
        .to output(/clashes with an existing event/).to_stdout
    end

    it 'allows a second event on the same date once the first one ends' do
      add(calendar, 'Morning', 9, 10)
      add(calendar, 'Later', 10, 11)

      expect(calendar.events.size).to eq(2)
    end

    it 'allows events with the same time on different dates' do
      add(calendar, 'Today', 9, 10, on_date: date)
      add(calendar, 'Tomorrow', 9, 10, on_date: date + 1)

      expect(calendar.events.size).to eq(2)
    end
  end

  describe '#remove_event' do
    it 'removes the matching event' do
      add(calendar, 'Meeting', 9, 10)
      id = calendar.events.values.first.id

      calendar.remove_event(id)

      expect(calendar.events).to be_empty
    end

    it 'nil for an id that does not exist, and changes nothing' do
      add(calendar, 'Meeting', 9, 10)

      result = calendar.remove_event(999)

      expect(result).to eq(nil)
    end
  end

  describe '#list_events' do
    it 'tells you there is nothing to display when there are no events' do
      expect { calendar.list_events }.to output(/no events to display/).to_stdout
    end

    it 'prints every event when there are some' do
      add(calendar, 'Meeting', 9, 10)

      expect { calendar.list_events }.to output(/Meeting/).to_stdout
    end
  end

  describe '#edit_event' do
    it "updates the event's fields" do
      add(calendar, 'Meeting', 9, 10)
      id = calendar.events.values.first.id
      new_date = date + 1

      calendar.edit_event(id, title: 'Renamed', date: new_date, start_time: time_on(new_date, 14, 0),
                              end_time: time_on(new_date, 15, 0), description: 'New desc')

      event = calendar.find_event_by_id(id)
      expect(event.title).to eq('Renamed')
      expect(event.date).to eq(new_date)
      expect(event.description).to eq('New desc')
    end
  end

  describe '#find_event_by_id' do
    it 'returns the matching event' do
      add(calendar, 'Meeting', 9, 10)
      id = calendar.events.values.first.id

      expect(calendar.find_event_by_id(id)).to eq(calendar.events.values.first)
    end

    it 'returns nil when there is no match' do
      expect(calendar.find_event_by_id(999)).to be_nil
    end
  end

  describe '#valid_id?' do
    it 'is true for an id that exists' do
      add(calendar, 'Meeting', 9, 10)
      id = calendar.events.values.first.id

      expect(calendar.valid_id?(id)).to be true
    end

    it 'is false for an id that does not exist' do
      expect(calendar.valid_id?(999)).to be false
    end
  end

  describe '#clash?' do
    it 'is false when there are no events yet' do
      expect(calendar.clash?(date, time_on(date, 9, 0), time_on(date, 10, 0))).to be false
    end

    it 'is true when the times overlap on the same date' do
      add(calendar, 'Meeting', 9, 10)

      expect(calendar.clash?(date, time_on(date, 9, 30), time_on(date, 10, 30))).to be true
    end

    it "is false when the times don't overlap, even on the same date" do
      add(calendar, 'Meeting', 9, 10)

      expect(calendar.clash?(date, time_on(date, 11, 0), time_on(date, 12, 0))).to be false
    end

    it 'is false for the same time on a different date' do
      add(calendar, 'Meeting', 9, 10, on_date: date)

      expect(calendar.clash?(date + 1, time_on(date + 1, 9, 0), time_on(date + 1, 10, 0))).to be false
    end

    it "ignores the event matching curr_id, so editing an event doesn't clash with itself" do
      add(calendar, 'Meeting', 9, 10)
      id = calendar.events.values.first.id

      expect(calendar.clash?(date, time_on(date, 9, 0), time_on(date, 10, 0), current_id: id)).to be false
    end
  end

  describe '#date_details' do
    it 'says there are no events when none match the date' do
      expect { calendar.date_details(date) }.to output(/No events found on/).to_stdout
    end

    it 'lists the events on that date' do
      add(calendar, 'Meeting', 9, 10)

      expect { calendar.date_details(date) }.to output(/Meeting/).to_stdout
    end
  end

  describe '#monthly_events' do
    it 'says there are no events when the month is empty' do
      expect { calendar.monthly_events(8, 2026) }.to output(/No events found in/).to_stdout
    end

    it 'lists the events in that month' do
      add(calendar, 'Meeting', 9, 10, on_date: Date.new(2026, 8, 5))

      expect { calendar.monthly_events(8, 2026) }.to output(/Meeting/).to_stdout
    end
  end
end
