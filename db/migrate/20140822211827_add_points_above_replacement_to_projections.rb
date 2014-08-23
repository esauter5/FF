class AddPointsAboveReplacementToProjections < ActiveRecord::Migration
  def change
    add_column :projections, :par32, :integer
    add_column :projections, :par10, :integer
  end
end
