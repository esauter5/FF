namespace :db do
  desc "read in draft results"
  task :read_draft => :environment do
    Dir[Rails.root.join("draft_files", "*")].each do |f|
      File.open(f).readlines.each do |line|
        line.chomp!
        if matches = /\((\d+\))/.match(line)
          draft_pos = matches[1].to_i
          player_info = line.split(' - ')[1].split(' ')
          position = player_info[player_info.length - 1]
          player_name = player_info[0...player_info.length - 1].join(' ')
          puts draft_pos.to_s + "," + player_name + "," + position

          map_position = { "QB" => 1, "RB" => 2, "WR" => 3, "TE" => 4, "K" => 5, "D/ST" => 6 }

          current_player = Player.find_or_create_by_name(player_name)
          current_player.position_id = map_position[position]
          current_player.avg_draft_position = current_player.avg_draft_position * current_player.num_drafts + draft_pos
          current_player.num_drafts += 1
          current_player.avg_draft_position /= current_player.num_drafts
          current_player.avg_draft_position = current_player.avg_draft_position.round(2)
          current_player.save
        end
      end
    end
  end

  desc "read average draft positions"
  task :espn_avg_draft => :environment do
      agent = Mechanize.new
      page = agent.get "http://games.espn.go.com/ffl/livedraftresults"
      doc = page.parser
      table = doc.css('.gamesmain table')
      trs = table.css('tr')
      trs = trs[3..trs.length-2]

      map_position = { "QB" => 1, "RB" => 2, "WR" => 3, "TE" => 4, "K" => 5, "D/ST" => 6 }

      trs.each do |tr|
        name = tr.css('td a').text.downcase
        columns = tr.css('td')
        position_id = map_position[columns[2].text]
        avg_draft_position = columns[3].text.to_f
        player = Player.find_or_create_by_name(name)
        player.position_id = position_id
        player.avg_draft_position = avg_draft_position
        player.save
      end
    end

    desc "read 2013 season stats"
    task :espn_2013_stats => :environment do
      year = 2014

      if year == 2013
        model = SeasonStat
        address =  "http://games.espn.go.com/ffl/leaders?leagueId=526856"
      else
        model = Projection
        address = "http://games.espn.go.com/ffl/tools/projections?leagueId=526856"
      end

      agent = Mechanize.new
      page = agent.get address

      10.times do
        doc = page.parser
        table = doc.css('.gamesmain table')
        trs = table.css('tr')
        trs = trs[2..trs.length-1]

        map_position = { "QB" => 1, "RB" => 2, "WR" => 3, "TE" => 4, "K" => 5, "D/ST" => 6 }

        trs.each do |tr|
          columns = tr.css('td')
          columns = columns[1..columns.length-1] if year == 2014
          first_column = columns[0]
          name = first_column.css('a')[0].text.downcase

          if /D\/ST/ =~ first_column.text
            position = first_column.text.split[1].split(/[[:space:]]/)[1]
          else
            position = first_column.text.split(",")[1].split(" ")[0].split(/[[:space:]]/)[1]
          end
          position_id = map_position[position]
          att_comp = columns[year == 2013 ? 2 : 3].text.split('/')
          player = Player.find_or_create_by_name(name)
          player.position_id = position_id
          player.save
          if year == 2013
            stats = model.new(pass_completions: att_comp[0].to_i, pass_attempts: att_comp[1].to_i,
                                  pass_yards: columns[6].text.to_i, pass_touchdowns: columns[7].text.to_i,
                                  interceptions: columns[8].text.to_i, rush_attempts: columns[10].text.to_i,
                                  rush_yards: columns[11].text.to_i, rush_touchdowns: columns[12].text.to_i,
                                  receptions: columns[14].text.to_i, receiving_yards: columns[15].text.to_i,
                                  receiving_touchdowns: columns[16].text.to_i, targets: columns[17].text.to_i,
                                  two_point_conversions: columns[19].text.to_i, fumbles: columns[20].text.to_i,
                                  return_tds: columns[21].text.to_i, year: year, total_points: columns[23].text.to_i)
          else
            stats = model.new(pass_completions: att_comp[0].to_i, pass_attempts: att_comp[1].to_i,
                                  pass_yards: columns[4].text.to_i, pass_touchdowns: columns[5].text.to_i,
                                  interceptions: columns[6].text.to_i, rush_attempts: columns[7].text.to_i,
                                  rush_yards: columns[8].text.to_i, rush_touchdowns: columns[9].text.to_i,
                                  receptions: columns[10].text.to_i, receiving_yards: columns[11].text.to_i,
                                  receiving_touchdowns: columns[12].text.to_i, year: year, projected_points: columns[13].text.to_i)
          end
          stats.player_id = player.id
          stats.save
        end

        page = agent.click(/NEXT/)
      end
    end

    desc "get espn rankings"
    task :espn_rankings => :environment do
      agent = Mechanize.new
      page = agent.get "http://espn.go.com/fantasy/football/story/_/page/TMR140326/matthew-berry-2014-fantasy-football-rankings-top-200"
      doc = page.parser
      table = doc.css('table')
      trs = table.css('tr')

      map_position = { "QB" => 1, "RB" => 2, "WR" => 3, "TE" => 4, "K" => 5, "DST" => 6 }

      trs[1..200].each do |tr|
        columns = tr.css('td')
        overall_ranking = columns[0].text.gsub(/\t/, '').to_i
        if (columns[1].text =~ /,/).nil?
          split_name = columns[1].text.gsub(/\t/, '').downcase.split
          name = split_name[split_name.length-1] + " d/st"
        else
          name =  columns[1].text.gsub(/\t/, '').downcase.split(',')[0]
        end
        player = Player.find_by_name(name)

        puts player.name
        position_rank = columns[2].text.gsub(/\t/, '')
        match = /([a-z]+)(\d+)/i.match(position_rank)

        position = match[1]
        position_rank = match[2].to_i
        bye = columns[3].text.gsub(/\t/, '').to_i
        EspnRanking.create(ranking: overall_ranking, position_ranking: position_rank, position: position, player_id: player.id)

        player.bye_week = bye
        player.save
      end
    end

    desc "get scoring averages"
    task :par_sum => :environment do
      6.times do |i|
        query = "Select avg(projected_points) From (Select players.*, projections.projected_points from players inner join projections on players.id = projections.player_id where players.position_id = #{i+1} order by projections.projected_points desc limit 32) As test;"
        a = ActiveRecord::Base.connection.execute(query)
        puts a[0]["avg"]
      end
    end

    desc "update PARs"
    task :update_pars => :environment do
      par = ["par10", "par32"]
      table = ["season_stats", "projections"]
      total = ["total_points", "projected_points"]
      points = [[[311,281,310,209,157,154],[226,207,246,139,129,108]],[[299,267,292,201,153,153], [232,219,243,138,129,115]]]
      2.times do |j|
        6.times do |i|
          query = "Update #{table[0]} set #{par[j]}= #{total[0]} - #{points[0][j][i]} where player_id in (Select id from players where position_id = #{i+1})"
          query = "Update #{table[1]} set #{par[j]}= #{total[1]} - #{points[1][j][i]} where player_id in (Select id from players where position_id = #{i+1})"
          ActiveRecord::Base.connection.execute(query)
        end
      end
    end
end
