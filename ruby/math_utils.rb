# Helpful Math functions
class MathUtils

  ERRO = 2
  LARGE_INTEGER = 600000
  class << self
    
    def velocity_intensity(fsceneobj, ssceneobj)
      return Math.sqrt( (fsceneobj * fsceneobj) + (ssceneobj * ssceneobj) )
    end


    def vector_module(vec)
      return Math.sqrt( (vec.getX * vec.getX) + (vec.getY * vec.getY))
    end

    def velocityvector(fsceneobj,ssceneobj)
      #return Vector2f.new(fsceneobj.pos,ssceneobj.pos)
      return Vector2f.new(fsceneobj.getPosition,ssceneobj.getPosition)
    end

    def velocity(fsceneobj, esceneobj)
      v = velocityvector(fsceneobj, esceneobj)
      #puts "Vel X:" + v.getX.to_s + " Vel Y: " + v.getY.to_s
      #return velocity_intensity(v.getX,v.getY)
      return v
    end

    def distance(p1,p2)
      return p2.subPoint(p1)
    end
    # FIXME ISTO NAO PODE SER ASSIM !!! NAO SE PODE FAZER ESTES ABSs
    def coeficiente(p1,p2)
      return p2.abs.subPoint(p1.abs)
    end

    def ball_velocity_increasing?(scene1,scene2)
      vel1 = Statistics.gamestate.get_event_for(scene1)[:velocity_ball]
      vel2 = Statistics.gamestate.get_event_for(scene2)[:velocity_ball]
      return vel2 > vel1
    end

  end
end
