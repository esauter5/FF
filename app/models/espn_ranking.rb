class EspnRanking < ActiveRecord::Base
  attr_accessible :ranking, :position_ranking, :position, :player_id

  belongs_to :player
end
