class CreateEspnRankings < ActiveRecord::Migration
  def change
    create_table :espn_rankings do |t|
      t.integer :ranking
      t.string :position
      t.integer :position_ranking
      t.references :player
    end

    add_index :espn_rankings, :player_id
  end
end
