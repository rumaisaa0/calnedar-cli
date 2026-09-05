# frozen_string_literal: true

def print_month_header(month, year, col)
  puts "#{Date::MONTHNAMES[month]} #{year}".center(col * 7)
  puts %w[Sun Mon Tue Wed Thu Fri Sat].map { |day| day.ljust(col) }.join
end

def print_calendar_days(first_day, last_day, counts, col)
  print ' ' * col * first_day.wday
  (first_day..last_day).each do |date|
    print calendar_cell(date, counts, col)
    puts '' if date.wday == 6
  end
  puts '' unless last_day.wday == 6
end

def calendar_cell(date, counts, col)
  cell = date.day.to_s
  cell += "(#{counts[date.day]})" if counts[date.day].positive?
  cell.ljust(col)
end
