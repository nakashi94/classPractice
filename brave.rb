require './character'

class Brave < Character
    # 必殺攻撃の計算に使う定数
    SPECIAL_ATTACK_CONSTANT = 1.5
  
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