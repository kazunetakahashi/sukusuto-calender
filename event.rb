# coding: utf-8

# 0：新コスイベント、1：特訓イベント、2：レイドオブリ協力戦、
# 3：スクスト人気投票、4：生徒会アンケート、5：ダメージコンテスト
event_type = 4

# 開始日
start_day = 10

# 以下、なかったら nil を入力
# 第#{event_number}回〜〜
event_number = 8

# サブタイトル
subtitle = "コスチュームについてのアンケート"

# 「#{collaboration}」とのコラボ
collaboration = nil

# 以下実行

require './SukusutoEvent.rb'

x = SukusutoEvent.new(event_type, start_day, event_number,
                      subtitle, collaboration)
x.insert()

