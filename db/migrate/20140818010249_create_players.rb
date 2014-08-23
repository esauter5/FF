class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.integer :position_id
      t.decimal :avg_draft_position, default: 0
    end

    add_index :players, :position_id
    add_index :players, :name, unique: true
  end
end
