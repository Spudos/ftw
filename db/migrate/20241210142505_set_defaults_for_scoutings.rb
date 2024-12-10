class SetDefaultsForScoutings < ActiveRecord::Migration[7.0]
  def change
    change_column_default :scoutings, :position, from: nil, to: 'gkp'
    change_column_default :scoutings, :total_skill, from: nil, to: 0
    change_column_default :scoutings, :age, from: nil, to: 50
    change_column_default :scoutings, :skills, from: nil, to: false
    change_column_default :scoutings, :skills_value, from: nil, to: 6
    change_column_default :scoutings, :loyalty, from: nil, to: false
    change_column_default :scoutings, :potential_skill, from: nil, to: false
    change_column_default :scoutings, :potential_skill_value, from: nil, to: 9
    change_column_default :scoutings, :consistency, from: nil, to: false
    change_column_default :scoutings, :recovery, from: nil, to: false
    change_column_default :scoutings, :star, from: nil, to: false
  end
end
