# coding: utf-8
require './GCal.rb'

class String
  def integer?
    Integer(self)
    return true
  rescue ArgumentError
    return false
  end
end


dir = File.expand_path(__dir__)

year = 2016

month = 1
day = 1

birthdays = []

tmpop = File.open(File.join(dir, "data", "birthday_20161017.txt"))
tmpop.each_line {|line|
  ary = line.chomp.split(" ")
  while !ary.empty?
    t = ary.first
    if t[0].integer?
      if t[-1] == "月"
        month = t[0...-1].to_i
      elsif t[-1] == "日"
        day = t[0...-1].to_i
      end
    else
      break
    end
    ary.shift
  end
  birthdays << [month, day, ary.join(" ")]
}
tmpop.close

birthdays.each{|b|
  month = b[0]
  day = b[1]
  name = b[2]
  rec = IceCube::Rule.yearly.day_of_month(day).month_of_year(month)
  opday = Date.new(year, month, day)
  a = GCal.new("【誕生日】#{name}", opday, opday, nil, rec, true)
  a.insert()
}
