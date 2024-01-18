class AddFitnessCoachingToTurnsheets < ActiveRecord::Migration[7.0]
  def change
    add_column :turnsheets, :fitness_coaching, :string
  end
end
