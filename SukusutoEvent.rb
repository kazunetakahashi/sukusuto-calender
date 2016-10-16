# coding: utf-8
class SukusutoEvent
  require './GCal.rb'
  require 'active_support/all'

  attr_accessor :event_type, :start_day, :event_number,
                :subtitle, :collaboration

  def initialize(event_type, start_day, event_number, subtitle, collaboration)
    @event_type = event_type
    @start_day = start_day
    @event_number = event_number
    @subtitle = subtitle
    @collaboration = collaboration
  end

  TABLE = [
    # 名称、日数、開始時刻、終了日警告、第…回なんとか、サブタイトルが普通あるか
    ["新コスイベント", 7, 11, 1, nil, true],
    ["特訓イベント", 7, 11, -1, "グループ対抗戦", false],
    ["レイドオブリ協力戦", 7, 11, 1, nil, false],
    ["スクスト人気投票", 7, 11, nil, nil, "スクスト人気投票", false],
    ["生徒会アンケート", 3, 0, -1, "生徒会アンケート", true],
    ["ダメージコンテスト", 2, 0, nil, "ダメージコンテスト", true],
  ]

  def insert()    
    summary = SukusutoEvent::TABLE[event_type][0]
    nissu = SukusutoEvent::TABLE[event_type][1]
    start_h = SukusutoEvent::TABLE[event_type][2]
    warning_day = SukusutoEvent::TABLE[event_type][3]
    numbering = SukusutoEvent::TABLE[event_type][4]
    subtitle_exists = SukusutoEvent::TABLE[event_type][5]

    now = Time.now    
    starttime = Time.new(now.year, now.month, start_day, start_h, 00)
    endtime = Time.new(now.year, now.month, start_day, 23, 59) + (nissu-1).days

    if now.day > 25 && start_day < 5
      starttime += 1.month
      endtime += 1.month
    end

    desc_ary = []

    if !numbering.nil? && !event_number.nil?
      desc_ary << "第#{event_number}回#{numbering}"
    end
    if subtitle_exists && subtitle.nil?
      puts "「#{summary}」なのにサブタイトルがありません。"
      if !SukusutoEvent.puts_warning("よろしいですか？")
        puts "終了します。"
        exit
      end
    end
    if !subtitle.nil?
      desc_ary << subtitle
    end
    if !collaboration.nil?
      desc_ary << "「#{collaboration}」とのコラボ"
    end

    description = desc_ary.join("\n")

    if !warning_day.nil?
      puts "終了日：#{SukusutoEvent.sukusuto_time(endtime)}"
      suggest_endtime = endtime + warning_day.days
      puts "終了日は間違いありませんか？ (可能性：#{suggest_endtime.day}日)"
      if SukusutoEvent.puts_warning("#{endtime.day}日の終了でよろしいですか？")
      # nothing
      else
        endtime = suggest_endtime
      end
    end

    puts "『#{summary}』"
    puts "【開催期間】#{SukusutoEvent.sukusuto_time(starttime)}〜#{SukusutoEvent.sukusuto_time(endtime)}"
    puts description

    if SukusutoEvent.puts_warning("以上を、スクストカレンダーに登録してよろしいですか？")
      x = GCal.new(summary, starttime, endtime, description, nil, false)
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
