require 'rubygems'
require 'activerecord'
require 'ar-extensions'

require File.join(File.dirname(__FILE__)) + "/database_classes.rb"

def insert_data(teamid,gameid,tick1,tick2, formacaoname)
  formation = FormationType.find_by_name formacaoname
  raise 'Parametros mal passados!!!' if formacaoname.nil?

  formation_info = [:team_id,:game_id,:formation_type_id,:tick]
  formation_data = []
  
  tick1.upto(tick2) do |n|
    formation_data << [teamid,gameid,formation[:id],n]
  end
  Formation.import formation_info, formation_data
end

=begin

Dados referentes ao jogo com o codigo 200803270414

ATH - Amorisis
=end


gamen = "/Users/zemariamm/RCG/200803270414-ATH_coached_1-vs-AmoiensisNQ_0.rcg"

g = Game.find_by_fich gamen

teamname = "AmoiensisNQ"
t = Team.find_by_name teamname
teamid = t[:id]
gameid = g[:id]
insert_data(teamid,gameid,0,6000,"4-3-3")

t = Team.find_by_name "ATH"
athid = t[:id]
insert_data(athid,gameid,0,2896,"3-5-2")
insert_data(athid,gameid,2896,3000,"5-3-2")
insert_data(athid,gameid,3000,3430,"3-5-2")
insert_data(athid,gameid,3430,3570,"5-3-2")
insert_data(athid,gameid,3570,3922,"3-5-2")
insert_data(athid,gameid,3922,4031,"4-4-2")
insert_data(athid,gameid,4031,6000,"3-5-2")

=begin

Dados referentes ao jogo com o codigo 200803270842

O famoso do 13 - 0

=end
gamen = "/Users/zemariamm/RCG/200803270842-Bahia2D_0-vs-ATH_coached_13.rcg"
g = Game.find_by_fich gamen
gameid = g[:id]


bahia = Team.find_by_name "Bahia2D"
bahia_id = bahia[:id]
insert_data(bahia_id,gameid,0,6000,"4-3-3")

ath = Team.find_by_name "ATH"
ath_id = ath[:id]

insert_data(ath_id,gameid,0,220,"3-5-2")
insert_data(ath_id,gameid,220,250,"5-3-2")
insert_data(ath_id,gameid,250,873,"3-5-2")
insert_data(ath_id,gameid,873,951,"3-2-5")
insert_data(ath_id,gameid,951,1409,"3-5-2")
insert_data(ath_id,gameid,1409,1443,"3-5-2")
insert_data(ath_id,gameid,1443,1845,"3-5-2")
insert_data(ath_id,gameid,1845,1879,"5-0-5")
insert_data(ath_id,gameid,1879,3486,"3-5-2")
insert_data(ath_id,gameid,3486,3504,"3-3-4")
insert_data(ath_id,gameid,3504,3514,"3-2-5")
insert_data(ath_id,gameid,3514,3672,"3-2-5")
insert_data(ath_id,gameid,3672,3696,"3-2-5")
insert_data(ath_id,gameid,3696,3842,"3-5-2")
insert_data(ath_id,gameid,3842,3879,"3-4-3")
insert_data(ath_id,gameid,3879,4225,"3-5-2")
insert_data(ath_id,gameid,4225,4295,"3-4-3")
insert_data(ath_id,gameid,4295,4330,"2-4-4")
insert_data(ath_id,gameid,4330,4387,"3-5-2")
insert_data(ath_id,gameid,4387,4450,"3-4-3")
insert_data(ath_id,gameid,4450,4859,"3-5-2")
insert_data(ath_id,gameid,4859,4882,"5-3-2")
insert_data(ath_id,gameid,4882,4908,"3-5-2")
insert_data(ath_id,gameid,4908,4920,"3-2-5")
insert_data(ath_id,gameid,4920,5419,"3-5-2")
insert_data(ath_id,gameid,5419,5443,"3-2-5")
insert_data(ath_id,gameid,5443,5766,"3-5-2")
insert_data(ath_id,gameid,5766,5783,"3-2-5")
insert_data(ath_id,gameid,5783,5892,"3-5-2")
insert_data(ath_id,gameid,5892,5955,"3-2-5")
insert_data(ath_id,gameid,5955,6000,"3-5-2")

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
    
    
  





