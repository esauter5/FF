class AddByeWeekToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :bye_week, :integer
  end
end
