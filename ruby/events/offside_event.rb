require File.join(File.dirname(__FILE__)) + "/soccer_event.rb"
require File.join(File.dirname(__FILE__)) + "/pass_events.rb"
require 'rubygems'
require 'activesupport'

module OffsideUtils
  def is_offside?(iscene,dest_player, orig_player)
    dest_player1scene = iscene.getPlayers.detect do |player|
      if (player.getNumber == dest_player.getNumber && player.getTeam == dest_player.getTeam)
        true
      else
        false
      end
    end
    other_team_ps = iscene.getPlayers.find_all do |player|
      if (player.getTeam != dest_player.getTeam)
        true
      else
        false
      end
    end
    # -1 == Team Right
    # 1 == Left TEAm
    #puts "TEAM: " + dest_player.getTeam.to_s
    func = :>
    if (dest_player.getTeam == -1) # Right team
      func = :<
    end
    # caso em que o jogador q faz o passe esta mais a frente que o jogador que a recebe
    f = func.to_proc
    is_edge_case = (not f.call(dest_player1scene.getPosition.getX,orig_player.getPosition.getX))
    if (is_edge_case)
      return false
    end

    val = is_unvalid_position?(dest_player1scene,other_team_ps, func)
    return val
  end

  def in_field?(scene,dest_player)
    desp = iscene.getPlayers.detect do |player|
      if (player.getNumber == dest_player.getNumber && player.getTeam == dest_player.getTeam)
        true
      else
        false
      end
    end
    return in_my_middle_field?(desp)
  end

  def is_unvalid_position?(dest_p,oteam,func)
    f = func.to_proc
    after_player = oteam.find_all do |p|
      f.call(p.getPosition.getX,dest_p.getPosition.getX)
    end
    return after_player.size < 2
  end
end
class Offside < Pass
  include OffsideUtils
  attr_accessor :team, :player
  def initialize(gamestate)
    @gamestate = gamestate
  end



  def final_condition(scene1,scene2)
    result = super
    if result
      fstate = @gamestate.get_event_for self.fscene
      dest_player = fstate[:destination]
      istate = self.gamestate.get_event_for self.iscene
      orig_player = istate[:from]
      return false if ( outside_field?(dest_player) || outside_field?(orig_player) )
      raise 'dest player is nil!!!!' if dest_player.nil?
      offside = is_offside?(self.iscene,dest_player,orig_player)
      self.team = orig_player.getTeam
      self.player = dest_player
      if offside
        return false if in_field?(self.iscene,dest_player)
        #puts "O jogador " + dest_player.getNumber.to_s + " esta em offside no momento: " + self.iscene.getTime.to_s
        return "Player " + dest_player.getNumber.to_s + " is offside"
        #true
      end
      false
    end
      return false
  end

end

class OffsideIntercept < PassMiss
  include OffsideUtils
  attr_accessor :team, :player

  def initialize(gamestate)
    @gamestate = gamestate
  end

  def final_condition(scene1,scene2)
    istate = self.gamestate.get_event_for self.iscene
    fstate = self.gamestate.get_event_for scene1
    if fstate[:kick]
      orig_player = istate[:from]
      # como fstate e o momento em que o jogador da equipa adversario fica com a bola
      # o que nos queremos e o primeiro momento em que a bola lhe pertence!
      gamestate_sliced = gamestate.slice_by_scenes(self.iscene, scene1)
      dest_player = fstate[:from]
      return false if ( outside_field?(dest_player) || outside_field?(orig_player) )
      if diff_teams_players(orig_player, dest_player)
        first_m_event = get_first_momment_wball(gamestate_sliced,dest_player)
        p = preview_condition(self.gamestate, self.iscene, first_m_event[:scene],get_player_for(first_m_event))
        if p
          self.fscene = scene1
          return false if in_field?(self.iscene,p)
          offside = is_offside?(self.iscene,p,orig_player)
          if offside
            self.player = p
            self.team = orig_player.getTeam
            return "Player " + p.getNumber.to_s + " is offside"
            #puts "O jogador " + p.getNumber.to_s + " esta em offside no momento: " + self.iscene.getTime.to_s + " offside intercept"
            #true
          end
        end
        true
      end
    end
    return false
  end
end

  


