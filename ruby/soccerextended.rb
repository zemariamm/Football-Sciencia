require 'java'
require '/Users/zemariamm/workspace/mestrado/soccer/SoccerScope2src-old/SoccerScope2/soccer.jar'
require 'soccerconstants.rb'
require 'math_utils.rb'
require 'soccer_additions.rb'
require 'gamestate.rb'

require 'events/soccer_event.rb'
require 'events/pass_events.rb'
require 'events/shoot_target.rb'
require 'events/balloff_event.rb'
require 'events/offside_event.rb'
require 'events/soccer_utils.rb'

SoccerConstants.force_translate(-52.5,-34.0)

class EventInfo
  attr_accessor :message, :time, :team, :klass, :player
  def initialize(args = {})
    self.message = args[:message] if args[:message]
    self.time = args[:time] if args[:time]
    self.team = args[:team] if args[:team]
    self.klass = args[:klass] if args[:klass]

    self.player = args[:player] if args[:player]
    if args[:team]
      self.message = self.team.to_s + " $ " + self.message
    end
  end

end

class Statistics
  @@scenes = []
  @@gamestate = GameState.new

  @@klasses = []
  @@objs_klass = []

  @@all_events = []

  class << self

    def inic
      @@scenes = []
      @@gamestate = GameState.new

      @@klasses = []
      @@objs_klass = []

      @@all_events = []
    end

    def get_scenes()
      @@scenes
    end
    def gamestate
      @@gamestate
    end
    
    def get_events
      @@all_events
    end


    def filter_goals
      @@all_events.sort! {|a,b| a.time <=> b.time }
      detect_impossibilities = lambda do |vector,classp,classi,result|
        vector.each_with_index do |elem, pos|
          if elem.klass.to_s == classp && pos > 1
            if vector[pos - 1].klass.to_s == classi
              result << vector[pos - 1]
            end
          end
        end
      end
      to_remove = []
      detect_impossibilities.call(@@all_events,"Goal","Outside",to_remove)
      to_remove.each { |elem| @@all_events.delete(elem) }
      to_remove = []
      detect_impossibilities.call(@@all_events,"Goal","PassMiss",to_remove)
      to_remove.each { |elem| @@all_events.delete(elem) }
    end


    def set_scenes(listScenes)
      @@scenes = listScenes
      calculate_ball_velocity
      puts "Calculating players velocity"
      # calculate_players_velocity
      puts "Finished "
      raise 'Empty Scene list!!' if listScenes.size < 2
    end
    
    def calculate_ball_velocity
      @@gamestate.add_event(@@scenes[0], {:scene => @@scenes[0], :velocity_ball => Vector2f.new(0.0,0.0) })
      action do |scene1, scene2|
        ball1  = scene1.getBall
        ball2  = scene2.getBall
        vel = MathUtils.velocity(ball1,ball2)
        @@gamestate.add_event(scene2, {:scene => scene2, :velocity_ball => vel})
      end
    end

    def calculate_players_velocity
      action do |scene1, scene2|
        pls1 = scene1.getPlayers
        pls2 = scene2.getPlayers
        pls1.each do |player|
          player_in_scene2 = pls2.detect { |p| p.getTeam == player.getTeam and p.getNumber == player.getNumber}
          player.setVelocity(MathUtils.velocity(player,player_in_scene2))
        end
      end
    end

    def action(opts = {}, &b)
      startelem = 0
      startelem = (@@scenes.indexOf(opts[:after]) + 1 ) if (opts[:after])
      care = false
      care = true if opts[:after]
      nextelem = startelem +1      
      ans = Array.new
      while nextelem < @@scenes.size
        val = b.call(@@scenes[startelem],@@scenes[nextelem])
        return if !val && care
        startelem , nextelem = nextelem, nextelem + 1
      end
    end
    
    def add_event_class(event_class)
      @@klasses << event_class
      @@objs_klass << Array.new
    end

    def process
      klasses = @@klasses
      objs_klass = @@objs_klass
      
      klasses.each_with_index do |klass, index|
        action do |scene1,scene2|
          obj = klass.new(@@gamestate)
          val = obj.start_condition(scene1,scene2)
          objs_klass[index] << obj if val
        end
      end
      
      objs_klass.each do |obj_list|
        obj_list.each do |obj|
          action :after => obj.iscene do |scene1, scene2|
            in_middle = obj.constrain(scene1,scene2)
            unless in_middle
              #obj.final_condition(scene1,scene2)
              res = obj.final_condition(scene1,scene2)
              if res
                #puts obj.class.to_s  + " " + obj.iscene.getTime.to_s
                # @@all_events << [obj.class.to_s,obj.iscene.getTime]
                if obj.respond_to? :team
                  puts "YES!!!!"
                  event_team = obj.team
                else
                  event_team = SoccerUtils.get_attack_team(obj.iscene)
                end

                if obj.respond_to? :player
                  player_num = obj.player.getNumber
                  
                else
                  player_num = SoccerUtils.get_player_for_scene(obj.iscene)
                end
                @@all_events << EventInfo.new(:message => res.to_s, :time => obj.iscene.getTime, :team => event_team, :klass => obj.class.to_s, :player => player_num)
               end
              false
            else
              true
            end
          end
        end
      end

      filter_goals
    end
   end
 end


