require File.join(File.dirname(__FILE__)) + "/soccer_event.rb"

class Shoot < SoccerEvent
  attr_accessor :iscene , :fscene, :gamestate, :team

  def initialize(gamestate)
    @gamestate = gamestate
  end

  def start_condition(scene1,scene2)
    player_kicking = is_kicking?(scene1,scene2)
    return false unless player_kicking
    puts gamestate.class
    timep = scene1.getTime - 1
    sceneaux =  self.gamestate[timep][:scene]
    ball = sceneaux.getBall

    player_kicking = ball.closer(scene1.getPlayers)
    region_shoot_vec = SoccerConstants.which_region?(player_kicking)
    return false unless region_shoot_vec
    region_shoot = region_shoot_vec[1]
    attackteam = player_kicking.getTeam
    self.team = attackteam
    # set invalid regions for kicks
    #set_regions_nvalid = [SoccerConstants::LEFT_LEFT_WING_BACK,SoccerConstants::LEFT_RIGHT_WING_BACK]
    #if attackteam == "l"
     # set_regions_nvalid = []
      #set_regions_nvalid = [SoccerConstants::RIGHT_LEFT_WING_BACK,SoccerConstants::RIGHT_RIGHT_WING_BACK]
    #end
    #region_insuccess = set_regions_nvalid.detect {|reg| reg == region_shoot }

    
    #if player_kicking && !region_insuccess
    if player_kicking 
      # possivelmente vamos adicionar a posicao onde o kick foi feito
      # assim consegui-mos descobrir tudo, se foi canto, free kick1, etc
      @gamestate.add_event(scene2,{:kick => true, :from => player_kicking,:region => SoccerConstants.which_region?(player_kicking) })
      @iscene = scene2
      return true
    end
    false
  end


  def final_condition(scene1,scene2)
    istate = @gamestate.get_event_for @iscene
    fstate = @gamestate.get_event_for scene1
    
    attackteam = istate[:from].getTeam
    last_ball = fstate[:scene].getBall
    iplayer = istate[:from]
    
    #ball2 = scene2.getBall
    
    player_kicking = last_ball.closer(scene1.getPlayers)
    return false if player_kicking == iplayer


    #region_shoot_vec = SoccerConstants.which_region?(last_ball)
    
    region_shoot_vec = SoccerConstants.which_region?(last_ball)
    return false unless region_shoot_vec
    region_ending = region_shoot_vec[1]

=begin
    puts "Region ending Name:"
    puts region_shoot_vec[0]
    puts "No tempo: "
    puts scene2.getTime
    puts "************************************"
=end
    if attackteam == 1
      right_possibilities = [SoccerConstants::RIGHT_LEFT_WING_BACK,SoccerConstants::RIGHT_RIGHT_WING_BACK]
        #[SoccerConstants::RIGHT_PENALTY_BOX_BACK_SHOOT]
        #[SoccerConstants::RIGHT_PENALTY_BOX_LEFT,
        # SoccerConstants::RIGHT_PENALTY_BOX_RIGHT,
        # SoccerConstants::RIGHT_PENALTY_BOX_BACK,
        # SoccerConstants::RIGHT_PENALTY_BOX_FRONT]
      # if region_ending == SoccerConstants::RIGHT_OUTSIDE_BACK 
      #if right_possibilities.include?(region_ending)
      if right_possibilities.include?(region_ending)
        # puts "Shoot by team :" + attackteam
        return "Shoot by team: " + attackteam.to_s
        #return true
      end
    else
      left_possibilities =  [SoccerConstants::LEFT_LEFT_WING_BACK,SoccerConstants::LEFT_RIGHT_WING_BACK]
        #[SoccerConstants::LEFT_PENALTY_BOX_BACK_SHOOT]
        # [SoccerConstants::LEFT_PENALTY_BOX_LEFT,
        #                   SoccerConstants::LEFT_PENALTY_BOX_RIGHT,
        #                    SoccerConstants::LEFT_PENALTY_BOX_BACK,
        #                     SoccerConstants::LEFT_PENALTY_BOX_FRONT]
      # if region_ending == SoccerConstants::LEFT_OUTSIDE_BACK
      if left_possibilities.include?(region_ending)
        #puts "Shoot by team :" + attackteam 
        return "Shoot by team: " + attackteam.to_s
        #return true
      end
    end
    false
  end
    
  def constrain(scene1,scene2)
     player_kicking = is_kicking?(scene1,scene2)
      return true unless player_kicking
      false
      # cstate = @gamestate.get_event_for scene1
      # return cstate[:kick].nil?
    end
  end

end


class ShootIntercepted < Shoot
  attr_accessor :player, :team

  def final_condition(scene1,scene2)
    istate = self.gamestate.get_event_for self.iscene
    fstate = self.gamestate.get_event_for scene1
    if fstate[:kick]
      orig_player = istate[:from]
      self.player = orig_player
           # como fstate e o momento em que o jogador da equipa adversario fica com a bola
      # o que nos queremos e o primeiro momento em que a bola lhe pertence!
      gamestate_sliced = gamestate.slice_by_scenes(self.iscene, scene1)
      dest_player = fstate[:from]
      if diff_teams_players(orig_player, dest_player)
        first_m_event = get_first_momment_wball(gamestate_sliced,dest_player)
        success = preview_shoot_condition(self.gamestate, self.iscene, first_m_event[:scene],get_player_for(first_m_event)) 
        if success
          puts "Player number:"
          puts self.player.getNumber
          return "Shoot by " + orig_player.getNumber.to_s + " intercepted by: " + dest_player.getNumber.to_s
          #puts "Um remate efectuado !!!!"
          #return true
        end
      end
    end
      false
  end

  def preview_shoot_condition(gamestate,iscene,fscene,dest_player)
    less3 = less_3_points?(iscene,fscene)
    if less3
      return preview_shoot_less3(gamestate,iscene,fscene,dest_player) do |b_traj,attackteam|
        region_is_area = SoccerConstants.get_area(attackteam).detect { |reg| reg == gamestate[iscene.getTime][:region][1] }
        intersect_outside_back?(b_traj,attackteam) && region_is_area
      end
    else
      return preview_shoot(gamestate,iscene,fscene,dest_player) do |b_traj,attackteam|
          intersect_outside_back?(b_traj,attackteam)
      end
    end
  end

  # apenas detecta remates q se dirigam ao OUSITE_BACK
  # e que sejam efectuados dentro de area
  def preview_shoot_less3(gametstate,iscene,fscene,dest_player,&b)
    load_2_ball(gamestate,iscene.getTime) do |ball1,ball2|
      begin
        istate = gamestate.get_event_for iscene
        attackteam = istate[:from].getTeam
        b_tracj = ball_2_traject(ball1.getPosition,ball2.getPosition)
        #region_is_area = SoccerConstants.get_area(attackteam).detect { |reg| reg == istate[:region][1] }
        #if intersect_outside_back?(b_tracj,attackteam) && region_is_area
        cond = b.call(b_tracj,attackteam)
        if cond
            puts "SHOOT W ONLY 2 POINTS!" + istate[:scene].getTime.to_s + " from: " + istate[:from].getNumber.to_s
            return true
        end
      rescue Exception => e
        p e
      end
    end


  end
  def preview_shoot(gamestate,iscene,fscene,dest_player,&b)
    middle = fscene.getTime + iscene.getTime
    middle = middle.to_i / 2
    load_ball(gamestate,middle - 1) do |ball1,ball2,ball3|
      begin
        istate = gamestate.get_event_for iscene
        attackteam = istate[:from].getTeam
        b_traj = ball_traject(ball1.getPosition,ball2.getPosition,ball3.getPosition)
        #ans = intersect_outside_back?(b_traj,attackteam)
        ans = b.call(b_traj,attackteam)
        if ans
          puts "SHOOT !!!! at: " + istate[:scene].getTime.to_s
          return true
        end
      rescue Exception => e
        #puts "Ball1 Position " + " x: " + ball1.getPosition.getX.to_s + " y: " + ball1.getPosition.getY.to_s
        #puts "Ball2 Position " + " x: " + ball2.getPosition.getX.to_s + " y: " + ball2.getPosition.getY.to_s
        #puts "Ball3 Position " + " x: " + ball3.getPosition.getX.to_s + " y: " + ball3.getPosition.getY.to_s
        puts e.to_s + " at: " + iscene.getTime.to_s
      end
    end
  end
    

end



class ShootTarget < ShootIntercepted
  def preview_shoot_condition(gamestate,iscene,fscene,dest_player)
    less3 = less_3_points?(iscene,fscene)
    if less3
      return preview_shoot_less3(gamestate,iscene,fscene,dest_player) do |b_traj,attackteam|
        #puts "dentro da condicao less3"
        region_is_area = SoccerConstants.get_area(attackteam).detect { |reg| reg == gamestate[iscene.getTime][:region][1] }
        val = intersect_goal?(b_traj,attackteam) && region_is_area
        if val
          #puts "REMATE A BALIZA COM APENAS 2 PONTOS at: " + iscene.getTime.to_s + " pela equipa " + attackteam.to_s
          return "Shoot on Target"
        end
        val 
      end
    else
      return preview_shoot(gamestate,iscene,fscene,dest_player) do |b_traj,attackteam|
        puts "Nao se concretizou o remate a baliza at: " + iscene.getTime.to_s + " pela equipa "+ attackteam.to_s
        # Jose repara no seguinte
        # cada regiao tem um belongs_to modifica o codigo (com cuidado)
        # para qd fores verificar se e golo ou nao fazer o belongs_to para cada baliza
        val = intersect_goal?(b_traj,attackteam)
        if val
          return "Shoot on Target"
          # puts "REMATE A BALIZA at: " + iscene.getTime.to_s
        end
        val
      end
    end
  end

end

class Goal < SoccerEvent
  attr_accessor :team, :gamestate, :iscene, :player
  @@walked = []
  

  def initialize(gamestate)
    self.gamestate = gamestate
  end

  def start_condition(scene1,scene2)
    ball = scene1.getBall
    bpos = ball.getPosition
    goal = intersect_goal_wanswer(bpos)
    self.iscene = scene1
    if goal 
      player = who_kicked?(self.gamestate,scene1.getTime - 1)
      self.player = player
      self.team = -1 if goal == SoccerConstants::LEFT_GOAL
      self.team = 1 if goal == SoccerConstants::RIGHT_GOAL
      puts "Goal from player " + player.getNumber.to_s + " from team: " + player.getTeam.to_s
      puts "By team"
      puts self.team
      p goal
      return "Goal from player " + player.getNumber.to_s + " from team: " + player.getTeam.to_s
      #return true
    end
    false
  end

  def constrain(scene1,scene2)
    ball = scene1.getBall
    bpos = ball.getPosition
    res = intersect_goal_wanswer(bpos)
    return res
  end

  def final_condition(scene1,scene2)    
    # VERY IMPORTANT NOTE:
    # When there's a goal, this function will be called several times with
    # the sames parametres (for the celebrations)
    return false unless @@walked.index(scene1).nil?
    @@walked << scene1
    #puts "Time1 : " + scene1.getTime.to_s + " Time2: " + scene2.getTime.to_s
    ball = scene1.getBall
    bpos = ball.getPosition
    res = !intersect_goal_wanswer(bpos)
    return "Goal from player: " +  self.player.getNumber.to_s if res
    #puts "golo no momento: " + self.iscene.getTime.to_s + " q termina: " + scene1.getTime.to_s + " by: " + self.player.getNumber.to_s if res
    return res
  end

end