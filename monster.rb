require './character'

class Monster < Character
  
  POWER_UP_RATE = 1.5
  CALC_HALF_HP = 0.5
  
  def initialize(**params)
    
    super(
      name: params[:name],
      hp: params[:hp],
      offense: params[:offense],
      defense: params[:defense]
    )

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