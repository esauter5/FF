class DraftDashboardController < ApplicationController
  def index

  end

  def players
    @players = Player.includes(:position).includes(:season_stats).includes(:projection).includes(:espn_ranking).where('projections.projected_points IS NOT NULL').order('projections.projected_points DESC').limit(200)
    full_players = JSON.parse(@players.to_json(include: [:position, :season_stats, :projection, :espn_ranking]))
    dt_array = []
    full_players.each do |p|
      puts p["name"]

      ranking = p["espn_ranking"].nil? ? 999 : p["espn_ranking"]["ranking"].to_i
      position_ranking = p["espn_ranking"].nil? ? 999 : p["espn_ranking"]["position_ranking"].to_i

      season_stats = p["season_stats"].empty? ? -999 : p["season_stats"][0]["total_points"].to_i
      season_par10 = p["season_stats"].empty? ? -999 : p["season_stats"][0]["par10"].to_i
      season_par32 = p["season_stats"].empty? ? -999 : p["season_stats"][0]["par32"].to_i
      projected_points = p["projection"].empty? ? -999 : p["projection"]["projected_points"].to_i
      projected_par10 = p["projection"].empty? ? -999 : p["projection"]["par10"].to_i
      projected_par32 = p["projection"].empty? ? -999 : p["projection"]["par32"].to_i
      dt_array << [ranking.to_i, p["name"].titleize, "N/A", p["position"]["position"].upcase,
                   position_ranking, p["bye_week"].to_i, p["avg_draft_position"].to_i || "N/A", season_stats,
                   season_par10, season_par32, projected_points, projected_par10, projected_par32, ""]
    end


    render json: {"data" => dt_array} and return
  end
end
