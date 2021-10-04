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

    attack_type = decision_attack_type

    damage = calculate_damage(target: monster, attack_type: attack_type)

    # ダメージを反映させる
    cause_damage(target: monster, damage: damage)
    
    puts "#{monster.name}の残りHPは#{monster.hp}だ"
  end

  private

    def decision_attack_type
      attack_num = rand(4)
      if attack_num == 0
        puts "必殺攻撃"
        return "special_attack"
      else
        puts "通常攻撃"
        return "normal_num"
      end
    end

    # **paramsで受け取る
    def calculate_damage(**params)
      # 変数に格納することで将来ハッシュのキーに変更があった場合でも変更箇所が少なくて済む
      target = params[:target]
      attack_type = params[:attack_type]

      if attack_type == "special_attack"
        return calculate_special_attack - target.defense
      else
        return @offense - target.defense
      end
    end

    def cause_damage(**params)
      damage = params[:damage]
      target = params[:target]

      target.hp -= damage
      target.hp = 0 if target.hp < 0
      puts "#{target.name}は#{damage}のダメージを受けた"
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

    damage = cal_dmg(brave)
    cause_damage(target: brave, damage: damage)
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

    def cal_dmg(brave)
      return @offense - brave.defense
    end

    def cause_damage(**params)
      damage = params[:damage]
      target = params[:target]

      target.hp -= damage
      target.hp = 0 if target.hp < 0
      puts "#{target.name}は#{damage}を受けた"
    end

end

brave = Brave.new(name: "テリー", hp: 500, offense: 150, defense: 100)
monster = Monster.new(name: "スライム", hp: 250, offense: 200, defense: 100)

loop do
  brave.attack(monster)

  break if monster.hp <= 0

  monster.attack(brave)

  break if brave.hp <= 0

end

battle_result = brave.hp > 0

if battle_result
  exp = (monster.offense + monster.defense) * 2
  gold = (monster.offense + monster.defense) * 3
  puts "#{brave.name}は戦いに勝った"
  puts "#{exp}の経験値と#{gold}ゴールドを獲得した"
else
  puts "#{brave.name}は戦いに負けた"
  puts "目の前が真っ暗になった"
end