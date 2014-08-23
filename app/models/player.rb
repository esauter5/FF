class Player < ActiveRecord::Base
  attr_accessible :name, :position_id, :bye_week
  belongs_to :position
  has_one :projection
  has_one :espn_ranking
  has_many :season_stats

  validates :name, uniqueness: true
end
