class Projection < ActiveRecord::Migration
  def change
    create_table :projections do |t|
      t.integer :pass_completions
      t.integer :pass_attempts
      t.integer :pass_yards
      t.integer :pass_touchdowns
      t.integer :interceptions
      t.integer :rush_attempts
      t.integer :rush_yards
      t.integer :rush_touchdowns
      t.integer :receptions
      t.integer :receiving_yards
      t.integer :receiving_touchdowns
      t.integer :targets
      t.integer :two_point_conversions
      t.integer :fumbles
      t.integer :return_tds
      t.integer :projected_points
      t.integer :year
      t.references :player
      t.timestamp :updated_at
    end

    add_index :projections, :player_id
  end
end
