class Brave
  # attr_renderの記述でゲッターを省略することができる
  # attr_reader :name, :hp, :offense, :defense
  # attr_wirterでセッターを定義できる
  # attr_writer :hp
  
  # ゲッターを定義
  attr_reader :name, :offense, :defense

  # 上記2~5行目のセッター、ゲッターの定義をattr_accessorで定義できる
  attr_accessor :hp

  def initialize(**params)
    @name = params[:name]
    @hp = params[:hp]
    @offense = params[:offense]
    @defense = params[:defense]
  end

end

class Monster
  attr_reader :name, :offense, :defense
  attr_accessor :hp
  
  def initialize(**params)
    @name = params[:name]
    @hp = params[:hp]
    @offense = params[:offense]
    @defense = params[:defense]
  end

end

brave = Brave.new(name: "テリー", hp: 500, offense: 150, defense: 100)

puts <<~TEXT
"NAME:#{brave.name}"
"HP:#{brave.hp}"
"OFFENSE:#{brave.offense}"
"DEFENSE:#{brave.defense}"
TEXT

brave.hp -= 30

puts "#{brave.name}はダメージを受けた！　残りHPは#{brave.hp}だ"

monster = Monster.new(name: "スライム", hp: 250, offense: 200, defense: 100)
puts monster.offense