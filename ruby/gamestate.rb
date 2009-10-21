
class GameState
  include Enumerable
  def initialize
    @board = Array.new
  end

  def slice_by_scenes(scene1,scene2)
    @board[scene1.getTime .. scene2.getTime]
  end
  
  def add_event(scene,event)
    if @board[scene.getTime].nil?
      @board[scene.getTime] = {}.merge(event)
    else
      @board[scene.getTime] = @board[scene.getTime].merge(event)
    end
  end
  
  def get_event_for(scene)
    unless @board[scene.getTime].nil?
      return @board[scene.getTime]
    end
    return nil
  end

  def method_missing(method, *args, &block)
    @board.send(method, *args, &block)
  end
=begin
  def print_goals()
    puts @board.size
    @board.each do |scene|
      unless scene[:goal]
        puts "Golo no momento: " + scene.getTime.to_s + " da equipa: " + scene[:goal].to_s
      end
    end
  end
=end
end
