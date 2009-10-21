require 'java'
require '/Users/zemariamm/workspace/mestrado/soccer/SoccerScope2src-old/SoccerScope2/soccer.jar'
require File.join(File.dirname(__FILE__)) + '/soccer_utils.rb'
require File.join(File.dirname(__FILE__)) + '/soccer_math.rb'

class SoccerEvent

  include SoccerUtils, SoccerMath

  def start_condition(scene1,scene2)
  end

  def final_condition(scene1,scene2)
  end

  def constrain(scene1,scene2)
    true
  end

  def preview(gamestate, iscene, fscene,dest_player)
    istate = gamestate.get_event_for iscene
    orig_player = istate[:from]
    attackteam = istate[:from].getTeam
    players = gamestate[iscene.getTime + 1][:scene].getPlayers
    attackingplayers = players.find_all { |p| p.getTeam == attackteam && p.getNumber !=  orig_player.getNumber}
    load_ball(gamestate,iscene.getTime) do |ball1,ball2,ball3|
      b_traj = ball_traject(ball1.getPosition,ball2.getPosition,ball3.getPosition)
      p = closest_players(b_traj,attackingplayers)
      return p
    end
    nil
  end


  def preview_less3(gamestate,iscene,fscene,dest_player)
    istate = gamestate.get_event_for iscene
    orig_player = istate[:from]
    attackteam = istate[:from].getTeam
    players = gamestate[iscene.getTime + 1][:scene].getPlayers
    attackingplayers = players.find_all { |p| p.getTeam == attackteam && p.getNumber !=  orig_player.getNumber}
    load_2_ball(gamestate,iscene.getTime) do |ball1,ball2|
      begin
        b_traj = ball_2_traject(ball1.getPosition,ball2.getPosition)
        p = closest_players(b_traj,attackingplayers)
        return p
      rescue Exception => e
        puts e
      end
      nil
    end
  end


  def preview_condition(gamestate,iscene,fscene,dest_player)
    less3 = less_3_points?(iscene,fscene)
    if less3
      return preview_less3(gamestate,iscene,fscene,dest_player)
    else
      begin
        return preview(gamestate,iscene,fscene,dest_player)
      rescue
        return preview_less3(gamestate,iscene,fscene,dest_player)
      end
    end
  end
end
