require 'rubygems'
require 'activerecord'
require 'ar-extensions'

require File.join(File.dirname(__FILE__)) + "/database_classes.rb"

puts "inserted test data"
puts "preparing dummy data"

gs = Game.find :all
dummy_games = gs.find_all {|game| game.formations.empty? }

dummy_value = FormationType.find_by_name "dummy"
dummy_id = dummy_value[:id]
formation_info = [:formation_type_id, :team_id, :game_id, :tick]
formation_data = []
dummy_games.each do |game|
  team1 = game[:team1_id]
  team2 = game[:team2_id]
  teams = []
  teams << team1
  teams << team2


  teams.each do |team_id|
    0.upto(6000) do |n|
      formation_data << [dummy_id, team_id, game[:id], n]
    end
  end
end

Formation.import formation_info, formation_data
puts "done"
