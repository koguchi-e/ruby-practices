#!/usr/bin/env ruby

require "optparse"
require "date"

options = {}

OptionParser.new do |opts|
  opts.on("-y YEAR", "年を指定") do |y|
    options[:year] = y
  end

  opts.on("-m MONTH", "月を指定") do |m|
    options[:month] = m
  end
end.parse!

options[:year] ||= Date.today.year
options[:month] ||= Date.today.month

first_day = Date.new(options[:year].to_i, options[:month].to_i, 1)
last_day = Date.new(first_day.year, first_day.month, -1)
all_days = (first_day..last_day).to_a

puts "#{options[:month]}月 #{options[:year]}".center(20)
puts "日 月 火 水 木 金 土 "

first_space = first_day.wday
first_space.times { all_days.unshift(nil) }

all_days.each_slice(7) do |calender_dates|
  puts calender_dates.map { |d| d ? d.strftime("%-d").rjust(2) : "  " }.join(" ")
end
