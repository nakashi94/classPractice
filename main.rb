class Brave
  # attr_renderの記述でゲッターを省略することができる
  # attr_reader :name, :hp, :offense, :defense
  # attr_wirterでセッターを定義できる
  # attr_writer :hp
  
  # ゲッターを定義
  attr_reader :name, :offense, :defense

  # 上記2~5行目のセッター、ゲッターの定義をattr_accessorで定義できる
  attr_accessor :hp

  # 必殺攻撃の計算に使う定数
  SPECIAL_ATTACK_CONSTANT = 1.5

  def initialize(**params)
    @name = params[:name]
    @hp = params[:hp]
    @offense = params[:offense]
    @defense = params[:defense]
  end

  def attack(monster)
    puts "#{@name}の攻撃"

    attack_num = rand(4)

    if attack_num == 0
      puts "必殺攻撃"
      damage = calculate_special_attack - monster.defense
    else
      puts "通常攻撃"
      damage = @offense - monster.defense
    end

    monster.hp -= damage
    
    puts "#{monster.name}は#{damage}のダメージを受けた"
    puts "#{monster.name}の残りHPは#{monster.hp}だ"
  end

def calculate_special_attack
  @offense*SPECIAL_ATTACK_CONSTANT
end

end

class Monster
  attr_reader :offense, :defense
  attr_accessor :hp, :name

  POWER_UP_RATE = 1.5
  CALC_HALF_HP = 0.5
  
  def initialize(**params)
    @name = params[:name]
    @hp = params[:hp]
    @offense = params[:offense]
    @defense = params[:defense]

    # モンスターが変身したかを判定するフラグ
    @transform_flag = false

    # 変身する際の閾値(トリガー)を計算
    @trigger_of_transform = params[:hp] * CALC_HALF_HP
  end

  def attack(brave)
    # HPが半分以下、かつ、モンスター変身判定フラグがfalseの時に実行
    if @hp <= @trigger_of_transform && @transform_flag == false
      @transform_flag = true
      transform
    end
    puts "#{@name}の攻撃"
    damage = @offense - brave.defense
    brave.hp -= damage
    puts "#{brave.name}は#{damage}を受けた"
    puts "#{brave.name}のHPは残り#{brave.hp}だ"
  end

  # クラス外から呼び出せないようにする
  private

  # 変身メソッドの定義
  def transform
    # 変身後の名前
    transform_name = "ドラゴン"

    # 返信メッセージ
    puts <<~EOS
    "#{@name}は怒っている"
    "#{@name}は#{transform_name}に変身した
    EOS

    @offense *= POWER_UP_RATE
    @name = transform_name
  end

end

brave = Brave.new(name: "テリー", hp: 500, offense: 300, defense: 100)
monster = Monster.new(name: "スライム", hp: 250, offense: 200, defense: 100)
brave.attack(monster)
monster.attack(brave)