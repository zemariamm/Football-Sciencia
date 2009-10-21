require File.join(File.dirname(__FILE__)) + "/soccer_event.rb"

class PassJava
  attr_accessor :orig_player,:orig_team, :dest_player, :dest_team, :time, :final_time
  
  @@list = Array.new
  
  def self.add(pass)
    @@list << [pass.orig_player, pass.orig_team, pass.dest_player,pass.time, pass.final_time]
  end

  def self.get_list
    java_array = @@list.map{|arr| arr.to_java :int}.to_java
    java_array
    # @@list
  end


  def initialize(_orig_player,_orig_team,_dest_player,_dest_team,_time, _final_time)
    self.orig_player = _orig_player
    self.orig_team = _orig_team
    self.dest_player = _dest_player
    self.dest_team = _dest_team
    self.time = _time
    self.final_time = _final_time
  end

end
class Pass < SoccerEvent
  @@number_passes = 0
  @@npass = {:"1000" => [] , :"2000" => [], :"3000" => [] , :"4000" => [] , :"5000" => [],:"6000" => []}
  attr_accessor :iscene , :fscene, :gamestate, :team, :player

  def Pass.pretty_print
    @@npass.each_pair do |key,value|
      puts "antes de #{key}: " + value.size.to_s + " passes"
      value.each { |str| puts str }
    end
  end

  def Pass.total
    puts "Numero total de passes: " + @@number_passes.to_s
  end

  def initialize(gamestate)
    @gamestate = gamestate
  end

  def start_condition(scene1,scene2)
    player_kicking = is_kicking?(scene1,scene2)
    if player_kicking
      # possivelmente vamos adicionar a posicao onde o kick foi feito
      # assim consegui-mos descobrir tudo, se foi canto, free kick1, etc
      @gamestate.add_event(scene2,{:kick => true, :from => player_kicking,:region => SoccerConstants.which_region?(player_kicking) })
      self.team = player_kicking.getTeam
      self.player = player_kicking
      @iscene = scene2
      return true
    end
    false
  end

  def final_condition(scene1,scene2)
    #Ok temos um xuto, temos de ir ver a frente se e para um jogador da nossa equipa ou nao
    istate = @gamestate.get_event_for @iscene
    fstate = @gamestate.get_event_for scene1
    if fstate[:kick]
      orig_player = istate[:from]
      dest_player = fstate[:from]
      if same_team_diff_players(orig_player, dest_player)
        puts "From: " + orig_player.getNumber.to_s + " at: " + @iscene.getTime.to_s + " to " + dest_player.getNumber.to_s + " at: " + scene2.getTime.to_s 
        @fscene = scene1
        @gamestate.add_event(scene1,{:destination => dest_player})
        @@number_passes = @@number_passes + 1
        PassJava.add(PassJava.new(orig_player.getNumber,orig_player.getTeam,dest_player.getNumber,orig_player.getTeam,@iscene.getTime,@fscene.getTime))
        return "Pass From: " + orig_player.getNumber.to_s + " at: " + @iscene.getTime.to_s + " to " + dest_player.getNumber.to_s + " at: " + scene2.getTime.to_s 
        #return true
      end        
      return false
    end
    return false
  end

  def constrain(scene1,scene2)
    cstate = @gamestate.get_event_for scene1
    return cstate[:kick].nil?
  end

end


class PassMiss < Pass
  def final_condition(scene1,scene2)
     istate = self.gamestate.get_event_for self.iscene
     fstate = self.gamestate.get_event_for scene1
     if fstate[:kick]
       orig_player = istate[:from]
       # como fstate e o momento em que o jogador da equipa adversario fica com a bola
       # o que nos queremos e o primeiro momento em que a bola lhe pertence!
       gamestate_sliced = gamestate.slice_by_scenes(self.iscene, scene1)
       dest_player = fstate[:from]
       if diff_teams_players(orig_player, dest_player)
         first_m_event = get_first_momment_wball(gamestate_sliced,dest_player)
         p = preview_condition(self.gamestate, self.iscene, first_m_event[:scene],get_player_for(first_m_event))
         if p
           @gamestate.add_event(scene1,{:destination => dest_player})
           return "#{orig_player.getNumber}  was trying to pass the ball to: #{p.getNumber} at: #{istate[:scene].getTime}"
         end
         #true
       end
     end
    return false
  end
end

class PassQuant < Pass
  attr_accessor :distance
  attr_accessor :func
  def initialize(gamestate,a_distance,a_func)
    super(gamestate)
    self.gamestate = gamestate
    self.distance = a_distance
    self.func = a_func
  end

   def final_condition(scene1,scene2)
     val = super(scene1,scene2)
    # ok , val e verdadeiro , e um passe -> verificar se e longo ou nao
    if val
      raise 'Gamestate cannot be nil!!' if self.gamestate.nil?
      raise 'FSCENE cannot be nil!!' if self.fscene.nil?
      istate = self.gamestate.get_event_for(self.iscene)
      fstate = self.gamestate.get_event_for(self.fscene)
      orig_player = istate[:from]
      dest_player = fstate[:from]
      dist = orig_player.distance(dest_player)
      if dist.send(self.func,self.distance)
        puts "LONG SHOOT!!!"
        return true
      end
      return false
    end
     false
   end
  
end

class PassLong < PassQuant
  LONG_DISTANCE = 30

  def initialize(gamestate)
    super(gamestate,LONG_DISTANCE,:>)
  end
end

class PassShort < PassQuant
  SHORT_DISTANCE = 5
  def initialize(gamestate)
    super(gamestate,SHORT_DISTANCE,:<)
  end
end


  
