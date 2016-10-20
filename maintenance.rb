# coding: utf-8

require 'active_support/all'

after_days = 0
time_h = 15
time_m = 0
hour = 2

# 以下実行

require './SukusutoMaintenance.rb'

now = Time.now

start_time = Time.new(now.year, now.month, now.day, time_h, time_m) + after_days.days
end_time = start_time + hour.hours

x = SukusutoMaintenance.new(start_time, end_time)
x.insert()

