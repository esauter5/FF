class Projection < ActiveRecord::Base
  attr_accessible :pass_completions, :pass_attempts, :pass_yards,
                  :pass_touchdowns, :interceptions, :rush_attempts,
                  :rush_yards, :rush_touchdowns, :receptions, :receiving_yards,
                  :receiving_touchdowns, :targets, :two_point_conversions,
                  :fumbles, :return_tds, :updated_at, :year, :projected_points

  belongs_to :player

  validates_uniqueness_of :player_id, scope: :year
end
