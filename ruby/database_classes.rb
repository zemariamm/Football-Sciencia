require 'rubygems'
require 'activerecord'
require 'ar-extensions'

ActiveRecord::Base.establish_connection(
                                        :adapter => "jdbcmysql",
                                        :host => "localhost",
                                        :username => "root",
                                        :database => "football_sciencia")
class Team < ActiveRecord::Base
  has_and_belongs_to_many :games
  has_many :players


  def has_players?
    return true if (not self.players.nil? and self.players.size > 0 )
  end
    
end

class Player < ActiveRecord::Base
  has_and_belongs_to_many :games
  has_and_belongs_to_many :events
  has_many :global_positions
  belongs_to :team
end

class Event < ActiveRecord::Base
  #has_and_belongs_to_many :games
  has_and_belongs_to_many :players
  
  has_one :event_type
  has_one :game
end

class EventType < ActiveRecord::Base
  has_many :events

  def self.is_empty?
    list = EventType.find :all
    return true if  (list.nil? or list.size < 1)
  end

end

class Game < ActiveRecord::Base
  has_and_belongs_to_many :events
  has_and_belongs_to_many :players
  has_and_belongs_to_many :global_positions
  has_many :formations

  has_one :home_team,
  :class_name => 'Team',
  :foreign_key => 'team1_id'

  has_one :away_team,
  :class_name => 'Team',
  :foreign_key => 'team2_id'
end


class GlobalPosition < ActiveRecord::Base
  has_one :player, :class_name => 'Player', :foreign_key => 'object_id'
  has_one :game
end

class GamesPlayers < ActiveRecord::Base
  belongs_to :player
  belongs_to :game
end

class EventsPlayers < ActiveRecord::Base
  belongs_to :player
  belongs_to :event
end

class EventsGames < ActiveRecord::Base
  belongs_to :event
  belongs_to :game
end

class Formation < ActiveRecord::Base
  has_one :team
  has_one :game
  has_one :formation_type
end

class FormationType < ActiveRecord::Base
  has_many :formations

  def self.is_empty?
    list = FormationType.find :all
    return true if  (list.nil? or list.size < 1)
  end

end





