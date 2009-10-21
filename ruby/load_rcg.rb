require 'java'


require '/Users/zemariamm/workspace/mestrado/soccer/SoccerScope2src-old/SoccerScope2/soccer.jar'
require 'rubygems'
require 'activerecord'
require 'ar-extensions'
require 'soccerextended.rb'

require File.join(File.dirname(__FILE__)) + "/database_classes.rb"

include_class "soccerscope.file.LogFileReader"
include_class "soccerscope.model.SceneSet"
include_class "soccerscope.model.SceneSetMaker"


module BDFunctions
  def create_or_load(team_name)
    t = Team.find_by_name(team_name)
    unless t
      t = Team.new(:name => team_name) 
      t.save!
    end
    t
  end

  def exists_game?(fich)
    Game.find_by_fich(fich)
  end
  
  def create_players_for(team)
    players = (1..11).collect do |number|
      Player.new(:number => number, :team_id => team[:id])
    end
    players.collect! { |p| p.save!; p  }
    players
  end

  def load_players_for(team)
    Player.find_all_by_team_id(team[:id])
  end


  def load_events_type
    listevents = ["Pass","PassMiss","Shoot","ShootIntercepted","ShootTarget","Goal","Outside","Offside","OffsideIntercept"]
    if EventType.is_empty?
      listevents.each do |event|
        e = EventType.new(:name => event)
        e.save!
      end
    end
  end

  def load_formations_type
    listformations= ["4-4-2","4-3-3","4-2-4","3-5-2", "5-3-2", "5-0-5","3-3-4","3-4-3","2-4-2", "3-2-5","5-4-1","3-6-1","4-5-1","2-4-4", "dummy"]
    if FormationType.is_empty?
      listformations.each do |formation|
        f = FormationType.new(:name => formation)
        f.save!
      end
    end
  end


  module_function :create_or_load, :exists_game?, :create_players_for, :load_players_for, :load_events_type, :load_formations_type
end

def load_data(fich)
  f = LogFileReader.new(fich)

  sceneSet = SceneSet.new

  ssm = SceneSetMaker.new(f, sceneSet)
  ssm.start()
  ssm.join

  scenes = sceneSet.sceneList



  beg = Time.now

  # load teams from / to database
  left = scenes[300].getLeft.getTeamName
  right = scenes[300].getRight.name

  left_team = BDFunctions::create_or_load(left)
  right_team = BDFunctions::create_or_load(right)

  #create game
  g = Game.new(:fich => fich)
  g[:team1_id] = left_team[:id]
  g[:team2_id] = right_team[:id]
  g.save!

  # FIXME: falta o caso de os players ja estaram na BD
  ar_players = []
  [left_team,right_team].each do |team|
    if team.has_players?
      ar_players << BDFunctions::load_players_for(team)
    else
      ar_players << BDFunctions::create_players_for(team)
    end
  end

  ar_players.each do |players|
    def players.get_id_for_number(num)
      p = self.find {|player| player[:number] == num}
      return p[:id]
    end
  end
  left_t_players, right_t_players = ar_players

  balls_data = Array.new
  players_data = Array.new

  balls_info = [:tick,:posx,:posy, :object_id, :game_id]
  players_info = [:tick,:posx,:posy, :object_id, :game_id]


  scenes.each do |scene|
    time = scene.getTime
    ball = scene.getBall

    players = scene.getPlayers

    balls_data << [time,ball.getPosition.getX,ball.getPosition.getY, 0, g[:id]]


    players.each do |player|
      # -1 == Team Right
      if player.getTeam.to_i == -1
        pid = right_t_players.get_id_for_number(player.getNumber.to_i)
        # 1 == Left Team
      else
        pid = left_t_players.get_id_for_number(player.getNumber.to_i)
      end
      players_data << [time,player.getPosition.getX, player.getPosition.getY,pid,g[:id]]
    end
  end
  puts "Inserting Ball data"
  GlobalPosition.import balls_info, balls_data
  puts "Inserting Players data"
  GlobalPosition.import players_info, players_data
  en = Time.now
  duration = en - beg
  puts "Duracao :"
  puts duration

  ## LOAD Statistics


  BDFunctions::load_events_type
  BDFunctions::load_formations_type

  evtypes = EventType.find :all
  hashtypes = {}
  evtypes.each do |evtype|
    hashtypes[evtype.name.to_sym] = evtype[:id]
  end
  p hashtypes

  Statistics.inic
  Statistics.set_scenes(scenes)
  Statistics.add_event_class(PassMiss)
  Statistics.add_event_class(Shoot)
  Statistics.add_event_class(ShootIntercepted)
  Statistics.add_event_class(ShootTarget)
  Statistics.add_event_class(Pass)
  Statistics.add_event_class(Goal)
  Statistics.add_event_class(Outside)
  Statistics.add_event_class(Offside)
  Statistics.add_event_class(OffsideIntercept)

  Statistics.process

  events = Statistics.get_events
  events_info = [:tick1,:tick2,:player_id,:event_type_id, :game_id]
  events_data = []
  events.each do |event|
    # -1 == Team Right
    if event.team == -1
      pid = right_t_players.get_id_for_number(event.player.to_i)
      # 1 == Left Team
    else
      pid = left_t_players.get_id_for_number(event.player.to_i)
    end
    tick = event.time.to_i
    # hack hack hack
    tick2 = tick + 5
    gid = g[:id]

    etype = hashtypes[event.klass.to_sym]
    events_data << [tick,tick2,pid,etype,g[:id]]
  end
  Event.import events_info, events_data
end

raise "Must receive a file as 1st argument with a newline separate list of path to rcgs" if ARGV.length < 1

rcgs = []
File.open(ARGV[0],"r") do |f|
  ar = f.readlines
  ar.each do |line|  l = line.gsub("\n","") 
    rcgs << l if l != ""
  end

end

Statistics.add_event_class(PassMiss)
Statistics.add_event_class(Shoot)
Statistics.add_event_class(ShootIntercepted)
Statistics.add_event_class(ShootTarget)
Statistics.add_event_class(Pass)
Statistics.add_event_class(Goal)
Statistics.add_event_class(Outside)
Statistics.add_event_class(Offside)
Statistics.add_event_class(OffsideIntercept)

p rcgs
rcgs.each do |fich|

  if BDFunctions::exists_game? fich
    puts "Already loaded file: "
    puts fich
  else
    load_data(fich)
    puts "File " + fich.to_s + " processed"
  end
  puts "Done"
end
