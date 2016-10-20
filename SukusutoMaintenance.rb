# coding: utf-8
class SukusutoMaintenance
  require './GCal.rb'
  require 'active_support/all'

  attr_accessor :start_time, :end_time

  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time = end_time
  end

  def insert()

    now = Time.now

    if now > @start_time && !SukusutoMaintenance.puts_warning("過去の出来事ですがよろしいですか？")
      puts "終了します。"
      exit      
    end
    
    puts "『メンテナンス』"
    today = Time.new(now.year, now.month, now.day)
    thisday = Time.new(@start_time.year, @start_time.month, @start_time.day)
    sa_day = ((thisday - today + 1)/60/60/24).to_i
    if sa_day == 0
      puts "【今日】"
    else
      puts "【#{sa_day}日後】"
    end
    puts "#{SukusutoMaintenance.sukusuto_time(@start_time)}〜#{SukusutoMaintenance.sukusuto_time(@end_time)}"
    if SukusutoMaintenance.puts_warning("以上を、スクストカレンダーに登録してよろしいですか？")
      x = GCal.new("メンテナンス", @start_time, @end_time, nil, nil, false)
      x.insert()
      puts "完了しました。"
    else
      puts "終了します。"
      exit
    end
  end

  def self.sukusuto_time(time)
    return time.strftime("%Y年%m月%d日(#{%w(日 月 火 水 木 金 土)[time.wday]})%H:%M")
  end

  def self.puts_warning(str)
    puts "#{str} (Yes/No)"
    while true
      ans = gets.chomp.to_s
      if ans == "Yes"
        return true
      elsif ans == "No"
        return false
      else
        puts "Yes か No でお答えください。#{str} (Yes/No)"
      end
    end
  end  
end
