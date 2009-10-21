require File.join(File.dirname(__FILE__)) + "/soccer_event.rb"

class Outside < SoccerEvent
  attr_accessor :iscene,:gamestate, :player, :team
  # @@walked = []
  def initialize(gamestate)
    @gamestate = gamestate
  end
  
  def start_condition(scene1,scene2)
    ball1 = scene1.getBall
    ball2 = scene2.getBall
    if inside_field?(ball1) && outside_field?(ball2)
      self.player = who_kicked?(self.gamestate,scene1.getTime - 1)
      self.iscene = scene1
      self.team = player.getTeam
      return true
    else
      return false
    end

  end
  def constrain(scene1,scene2)
    ball2 = scene2.getBall
    return false if inside_field?(ball2)
    return true
  end
  
  def final_condition(scene1,scene2)
    ball1 = scene1.getBall
    ball2 = scene2.getBall
    outsideplace = outside_field?(ball1)
    if outsideplace && inside_field?(ball2)
      puts "No Sitio: " + outsideplace.to_s
      self.team = invert_team(self.team)
      puts "Bola Fora, Bola dentro at:" + scene1.getTime.to_s + " inicial: " + self.iscene.getTime.to_s + " Chutada pelo mano: " + self.player.getNumber.to_s
      return "Outside by " + self.player.getNumber.to_s + " from team: " + self.player.getTeam.to_s + " Ball belongs to " + self.team.to_s
      #return true
    else
      return false
    end
  end

  def invert_team(team)
    return (team * -1)
  end

end
