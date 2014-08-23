class AddPointsAboveReplacementToSeasonStats < ActiveRecord::Migration
  def change
    add_column :season_stats, :par32, :integer
    add_column :season_stats, :par10, :integer
  end
end
