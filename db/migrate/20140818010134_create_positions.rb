class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :position
    end
  end
end
