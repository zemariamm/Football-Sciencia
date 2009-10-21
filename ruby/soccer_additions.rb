require 'java'
require '/Users/zemariamm/workspace/mestrado/soccer/SoccerScope2src-old/SoccerScope2/soccer.jar'

# First extend SoccerObject to include a radious method
include_class "soccerscope.model.SoccerObject"
include_class "soccerscope.util.geom.Vector2f"

require 'math_utils.rb'

# Aditions to java soccerscope base classes
module SoccerAdditions
  include_class "soccerscope.model.SoccerObject"
  include_package "soccerscope.util.geom"
  include_class "soccerscope.util.geom.Circle2f"
  JSoccerObject = SoccerObject
  class JSoccerObject
    def radious
      return Circle2f.new(self.pos, 5.0)
    end

    def belongs_to(obj)
      rad = radious
      rad.contains(obj.pos)
    end

    def distance(obj)
      self.pos.distance(obj.pos)
    end

    def closer(list_objs)
      raise 'Empty list of Objects' if list_objs.size < 1
      min= self.distance(list_objs[0])
      minobj = list_objs[0]
      min = list_objs.each do |obj|
        thisdist = self.distance(obj)
        if thisdist < min
          min = thisdist; minobj = obj
        end
      end
      minobj
    end

  end
end

include_class "soccerscope.util.geom.Vector2f"
JVector = Vector2f

class JVector
  include Comparable
  def <=>(avector)
    res1 = MathUtils.velocity_intensity(self.getX,self.getY)
    res2 = MathUtils.velocity_intensity(avector.getX,avector.getY)
    return  res1 <=> res2
  end
end
