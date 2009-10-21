require 'java'
require '/Users/zemariamm/workspace/mestrado/soccer/SoccerScope2src-old/SoccerScope2/soccer.jar'


include_class "soccerscope.util.geom.Point2f"
module SoccerConstants


  class SoccerRegion
    attr_accessor :pointsl , :pointsr, :pointil, :pointir
    def initialize(a_pointsl , a_pointsr, a_pointil, a_pointir)
      self.pointsl = a_pointsl 
      self.pointsr = a_pointsr
      self.pointil = a_pointil
      self.pointir = a_pointir
    end

    def to_s
      return "(#{pointsl.getX},#{pointsl.getY}) (#{pointsr.getX},#{pointsr.getY}) (#{pointil.getX},#{pointil.getY}) (#{pointir.getX},#{pointir.getY})"
    end
    def translate_to(xscale,yscale)
      self.instance_variables.each do |var|
        x = instance_variable_get(var).getX + xscale
        instance_variable_get(var).setX x
        y = instance_variable_get(var).getY + yscale
        instance_variable_get(var).setY y
      end
    end

    def belongs_to(obj)
      if obj.respond_to? :getPosition
        objpos = obj.getPosition 
      else
        objpos = obj 
      end
      if objpos.getX >= self.pointsl.getX && objpos.getX <= self.pointsr.getX
        if (objpos.getY >= self.pointsl.getY && objpos.getY <= self.pointil.getY )
          return true
        end
      end
      return false
    end


    def invertxy
      a_pointir = Point2f.new(XF - self.pointsl.getX , YN - self.pointsl.getY)
      a_pointil = Point2f.new(XF - self.pointsr.getX , YN - self.pointsr.getY)
      a_pointsr = Point2f.new(XF - self.pointil.getX, YN - self.pointil.getY)
      a_pointsl = Point2f.new(XF - self.pointir.getX, YN - self.pointir.getY)

      SoccerRegion.new(a_pointsl,a_pointsr,a_pointil,a_pointir)
    end

    def invertx
      a_pointir = Point2f.new(XF - self.pointsl.getX , self.pointir.getY)
      a_pointil = Point2f.new(XF - self.pointsr.getX , self.pointil.getY)
      a_pointsr = Point2f.new(XF - self.pointil.getX, self.pointsr.getY)
      a_pointsl = Point2f.new(XF - self.pointir.getX, self.pointsl.getY)

      SoccerRegion.new(a_pointsl,a_pointsr,a_pointil,a_pointir)
    end


    def ==(obj)
      success = (self.pointsl == obj.pointsl && self.pointsr == obj.pointsr &&
                 self.pointil == obj.pointil && self.pointir == obj.pointir)
      return success
    end


  end

  XI = 0.0
  XF = 105.0
  YI = 0.0
  YF = 34.0 * 2.0
  MARGIN = 5.0
  
  XI0 = XI - MARGIN
  XF0 = XF + MARGIN

  YI0 = YI - MARGIN
  YF0 = YF + MARGIN

  YX = 13.85

    
  XN = 16.5
  YN = 11.0
  
  #BALL_SIZE = 0.085
  BALL_SIZE = 1.8

  #Create 2 Goals
=begin
  LEFT_GOAL = SoccerRegion.new( Point2f.new(XI - MARGIN, YI + YX + YN),
                                Point2f.new(XI,  YI + YX + YN),
                                Point2f.new(XI - MARGIN, YF - (YX + YN)),
                                Point2f.new(XI, YF - (YX + YN)))
=end
  LEFT_GOAL = SoccerRegion.new( Point2f.new(XI - BALL_SIZE, YI + YX + YN),
                                Point2f.new(XI,  YI + YX + YN),
                                Point2f.new(XI - BALL_SIZE, YF - (YX + YN)),
                                Point2f.new(XI, YF - (YX + YN)))

  RIGHT_GOAL = LEFT_GOAL.invertx
  #puts "LEFT_GOAL: " + LEFT_GOAL.to_s
  #puts "RIGHT_GOAL: " + RIGHT_GOAL.to_s  

  # Create each Region
  LEFT_LEFT_WING_BACK = SoccerRegion.new( Point2f.new(XI, YI), #superior esquerdo
                                     Point2f.new(XF/6,YI), #superior direito
                                     Point2f.new(XI, YI + YX), #inferior esq
                                     Point2f.new(XF/6, YI + YX)) # inf direito



  LEFT_LEFT_WING_MIDDLE = SoccerRegion.new( Point2f.new(XI + (XF/6), YI), #superior esquerdo
                                     Point2f.new(XF/6 * 2,YI), #superior direito
                                     Point2f.new(XI+ (XF/6), YI + YX), #inferior esq
                                     Point2f.new(XF/6 * 2, YI + YX)) # inf direito
  

  LEFT_LEFT_WING_FRONT = SoccerRegion.new( Point2f.new(XI + (XF/6) * 2, YI), #superior esquerdo
                                     Point2f.new(XF/2,YI), #superior direito
                                     Point2f.new(XI + (XF/6) * 2, YI + YX), #inferior esq
                                     Point2f.new(XF/2, YI + YX)) # inf direito
  
 
 

  LEFT_RIGHT_WING_BACK = SoccerRegion.new( Point2f.new(XI, YF - YX), #superior esquerdo
                                     Point2f.new(XF/6, YF - YX), #superior direito
                                     Point2f.new(XI, YF), #inferior esq
                                     Point2f.new(XF/6, YF)) # inf direito                                     
  
  LEFT_RIGHT_WING_MIDDLE = SoccerRegion.new( Point2f.new(XI + (XF/6), YF - YX), #superior esquerdo
                                     Point2f.new(XF/6 * 2,YF - YX), #superior direito
                                     Point2f.new(XI+ (XF/6), YF), #inferior esq
                                     Point2f.new(XF/6 * 2, YF)) # inf direito

  

  LEFT_RIGHT_WING_FRONT = SoccerRegion.new( Point2f.new(XI + (XF/6) * 2, YF - YX), #superior esquerdo
                                     Point2f.new(XF/2,YF - YX), #superior direito
                                     Point2f.new(XI + (XF/6) * 2, YF), #inferior esq
                                     Point2f.new(XF/2, YF)) # inf direito

  

  LEFT_OUTSIDE_BACK = SoccerRegion.new( Point2f.new(XI0,YI), #sup esq
                                        Point2f.new(XI,YI), # sup dir
                                        Point2f.new(XI0,YF), # inf eqs
                                        Point2f.new(XI,YF)) # inf dir

  

  LEFT_OUTSIDE_LEFT = SoccerRegion.new( Point2f.new(XI0,YI0),
                                        Point2f.new(XF/2,YI0),
                                        Point2f.new(XI0,YI),
                                        Point2f.new(XF/2,YI))


  LEFT_OUTSIDE_RIGHT = SoccerRegion.new( Point2f.new(XI0,YF),
                                        Point2f.new(XF/2,YF),
                                         Point2f.new(XI0,YF0), # ao contrario do que dizia o doc do abreu
                                        Point2f.new(XF/2,YF0)) # ao contrario do que dizia o doc do abreu

  

  
  LEFT_PENALTY_BOX_LEFT = SoccerRegion.new ( Point2f.new(XI,YI + YX), #sup esq
                                             Point2f.new(XI+XN,YI + YX),
                                             Point2f.new(XI,YI + YX + YN),
                                             Point2f.new(XI+XN,YI + YX + YN))


                                       
  LEFT_PENALTY_BOX_RIGHT = SoccerRegion.new ( Point2f.new(XI,YF - YX - YN), #sup esq
                                             Point2f.new(XI + XN,YF - YX - YN),
                                             Point2f.new(XI,YF - YX ),
                                             Point2f.new(XI + XN,YF - YX))
  


  LEFT_PENALTY_BOX_BACK = SoccerRegion.new ( Point2f.new(XI,YI + YX + YN), #sup esq
                                             Point2f.new(XI + XN/3,YI + YX + YN),
                                             Point2f.new(XI,YF - YN - YX),
                                             Point2f.new(XI + XN/3,YF - YN - YX))



  LEFT_PENALTY_BOX_FRONT = SoccerRegion.new ( Point2f.new(XI + XN/3,YI + YX + YN), #sup esq
                                             Point2f.new(XI + XN,YI + YX + YN),
                                             Point2f.new(XI + XN/3,YF - YN - YX),
                                             Point2f.new(XI + XN,YF - YN - YX))



  LEFT_MIDDLE_BACK = SoccerRegion.new( Point2f.new(XI+XN, YI + YX),
                                       Point2f.new( (XI + XN) + ((XF/2)-( XI + XN))/3 , YI + YX),
                                       Point2f.new(XI + XN, YF - YX ),
                                       Point2f.new( (XI + XN) + ((XF/2)-( XI + XN))/3 , YF - YX))


  LEFT_MIDDLE_CENTER = SoccerRegion.new( Point2f.new((XI + XN) + ((XF/2)-( XI + XN))/3,  YI + YX),
                                       Point2f.new( (XI + XN) +  ((((XF/2)-( XI + XN))*2)/3) , YI + YX),
                                       Point2f.new((XI + XN) + ((XF/2)-( XI + XN))/3,  YF - YX),
                                       Point2f.new( (XI + XN) +  ((((XF/2)-( XI + XN))*2)/3) ,  YF - YX))



  LEFT_MIDDLE_FRONT = SoccerRegion.new( Point2f.new((XI + XN) +  ((((XF/2)-( XI + XN))*2)/3), YI + YX),
                                       Point2f.new( XF/2 , YI + YX),
                                       Point2f.new((XI + XN) +  ((((XF/2)-( XI + XN))*2)/3),  YF - YX),
                                       Point2f.new( XF/2 , YF - YX))


  LEFT_PENALTY_BOX_BACK_SHOOT = SoccerRegion.new ( Point2f.new(XI,YI + YX), #sup esq
                                             Point2f.new(XI + XN/3,YI + YX),
                                             Point2f.new(XI,YF - YX),
                                             Point2f.new(XI + XN/3,YF - YX))
  
  RIGHT_PENALTY_BOX_BACK_SHOOT = LEFT_PENALTY_BOX_BACK_SHOOT.invertx
  #RIGHT_LEFT_WING_FRONT = LEFT_LEFT_WING_FRONT.invertxy
  RIGHT_LEFT_WING_FRONT = LEFT_RIGHT_WING_FRONT.invertx

  #RIGHT_LEFT_WING_BACK =  LEFT_LEFT_WING_BACK.invertxy
  RIGHT_LEFT_WING_BACK =  LEFT_RIGHT_WING_BACK.invertx

  #RIGHT_RIGHT_WING_BACK= LEFT_RIGHT_WING_BACK.invertxy
  RIGHT_RIGHT_WING_BACK= LEFT_LEFT_WING_BACK.invertx
  
  #RIGHT_LEFT_WING_MIDDLE = LEFT_LEFT_WING_MIDDLE.invertxy
  RIGHT_LEFT_WING_MIDDLE = LEFT_RIGHT_WING_MIDDLE.invertx

  #RIGHT_RIGHT_WING_MIDDLE = LEFT_RIGHT_WING_MIDDLE.invertxy
  RIGHT_RIGHT_WING_MIDDLE = LEFT_LEFT_WING_MIDDLE.invertx

  #RIGHT_RIGHT_WING_FRONT = LEFT_RIGHT_WING_FRONT.invertxy
  RIGHT_RIGHT_WING_FRONT = LEFT_LEFT_WING_FRONT.invertx


  RIGHT_OUTSIDE_BACK = LEFT_OUTSIDE_BACK.invertx

  #RIGHT_OUTSIDE_LEFT = LEFT_OUTSIDE_LEFT.invertxy
  RIGHT_OUTSIDE_LEFT = LEFT_OUTSIDE_RIGHT.invertx


  #RIGHT_OUTSIDE_RIGHT = LEFT_OUTSIDE_RIGHT.invertxy
  RIGHT_OUTSIDE_RIGHT = LEFT_OUTSIDE_LEFT.invertx


  #RIGHT_PENALTY_BOX_LEFT = LEFT_PENALTY_BOX_LEFT.invertxy
  RIGHT_PENALTY_BOX_LEFT = LEFT_PENALTY_BOX_RIGHT.invertx


  #RIGHT_PENALTY_BOX_RIGHT = LEFT_PENALTY_BOX_RIGHT.invertxy
  RIGHT_PENALTY_BOX_RIGHT = LEFT_PENALTY_BOX_LEFT.invertx

  RIGHT_PENALTY_BOX_BACK = LEFT_PENALTY_BOX_BACK.invertx

  RIGHT_PENALTY_BOX_FRONT = LEFT_PENALTY_BOX_FRONT.invertx

  RIGHT_MIDDLE_BACK = LEFT_MIDDLE_BACK.invertx

  RIGHT_MIDDLE_CENTER = LEFT_MIDDLE_CENTER.invertx

  RIGHT_MIDDLE_FRONT = LEFT_MIDDLE_FRONT.invertx


  def get_field_regions
    ar = []
    outside_regions = [LEFT_OUTSIDE_BACK,RIGHT_OUTSIDE_BACK,LEFT_OUTSIDE_LEFT,LEFT_OUTSIDE_RIGHT,RIGHT_OUTSIDE_LEFT,RIGHT_OUTSIDE_RIGHT]
    SoccerConstants.constants.each do |conts|
      conts_obj = SoccerConstants.const_get(conts)
      if conts_obj.respond_to? :belongs_to
        ar << conts_obj if outside_regions.index(conts_obj).nil?
      end
    end
    return ar
  end


  def get_outside_field_regions
    return outside_regions = [LEFT_OUTSIDE_BACK,RIGHT_OUTSIDE_BACK,LEFT_OUTSIDE_LEFT,LEFT_OUTSIDE_RIGHT,RIGHT_OUTSIDE_LEFT,RIGHT_OUTSIDE_RIGHT]
  end
    
  def which_region?(obj)
      SoccerConstants.constants.each do |conts|
        conts_obj = SoccerConstants.const_get(conts)
        if conts_obj.respond_to? :belongs_to
          return [conts,conts_obj] if conts_obj.belongs_to obj
        end
      end
      return nil
    end

    def get_area(attackteam)
      if attackteam == "l"
        return [RIGHT_PENALTY_BOX_LEFT,RIGHT_PENALTY_BOX_RIGHT,RIGHT_PENALTY_BOX_BACK,RIGHT_PENALTY_BOX_FRONT]
      else
        return [LEFT_PENALTY_BOX_LEFT,LEFT_PENALTY_BOX_RIGHT,LEFT_PENALTY_BOX_BACK,LEFT_PENALTY_BOX_FRONT]
      end
    end

    def get_mid_field(attackteam)
      # -1 == Team Right
      # 1 == Left TEAm
      #puts "TEAM: " + dest_player.getTeam.to_s
      if attackteam == -1
        return [RIGHT_PENALTY_BOX_LEFT,RIGHT_PENALTY_BOX_RIGHT,RIGHT_PENALTY_BOX_BACK,RIGHT_PENALTY_BOX_FRONT,RIGHT_RIGHT_WING_FRONT,RIGHT_RIGHT_WING_MIDDLE,RIGHT_RIGHT_WING_BACK,
                RIGHT_LEFT_WING_FRONT,RIGHT_LEFT_WING_MIDDLE,RIGHT_LEFT_WING_BACK, RIGHT_MIDDLE_FRONT, RIGHT_MIDDLE_BACK, RIGHT_MIDDLE_CENTER]
      else
        return [LEFT_PENALTY_BOX_LEFT,LEFT_PENALTY_BOX_RIGHT,LEFT_PENALTY_BOX_BACK,LEFT_PENALTY_BOX_FRONT,LEFT_RIGHT_WING_FRONT,LEFT_RIGHT_WING_MIDDLE,LEFT_RIGHT_WING_BACK,
                LEFT_LEFT_WING_FRONT,LEFT_LEFT_WING_MIDDLE,LEFT_LEFT_WING_BACK, LEFT_MIDDLE_FRONT, LEFT_MIDDLE_BACK, LEFT_MIDDLE_CENTER]
      end
    end

    def return_by_field(strTeam)
      str = /RIGHT/
      if (strTeam == "l")
        str = /LEFT/
      end
      ans = []
      SoccerConstants.constants.each do |conts|
        conts_obj = SoccerConstants.const_get(conts)
        if (conts =~ str) == 0
          ans << conts_obj
        end
      end
      return ans
    end
    
    def print_regions
      SoccerConstants.constants.sort.each do |conts|
        conts_obj = SoccerConstants.const_get(conts)
        if conts_obj.respond_to? :pointsl
          puts "RegionName: #{conts} Point Superior Left: #{conts_obj.pointsl} RIGHT: #{conts_obj.pointir}"
        end
      end
      return nil
    end

    def force_translate(xscale,yscale)
      SoccerConstants.constants.sort.each do |conts|
        conts_obj = SoccerConstants.const_get(conts)
        if conts_obj.kind_of? SoccerRegion
          conts_obj.translate_to(xscale,yscale)
        end
      end
    end

    
  module_function :which_region?, :print_regions, :force_translate, :return_by_field, :get_area, :get_field_regions, :get_outside_field_regions, :get_mid_field
  # force_translate(-52.5,-34.0)
end

