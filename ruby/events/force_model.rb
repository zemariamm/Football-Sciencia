=begin
require 'java'
require '/Users/zemariamm/workspace/mestrado/soccer/SoccerScope2src-old/SoccerScope2/soccer.jar'

include_class "soccerscope.view.layer.DynamicSpineLayer"


class ForceModel < DynamicSpineLayer
  attr_accessor :gamestate, :is_enable

  def initialize(field_pane, enable)
    super(field_pane,enable)
    self.is_enable = enable
  end

  def draw(g)
    

  end

  
end
=end
