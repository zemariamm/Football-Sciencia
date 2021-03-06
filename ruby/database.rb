# require 'java' 
require 'rubygems'
require 'activerecord'

ActiveRecord::Base.establish_connection(
                                        #:adapter => "jdbcmysql",
                                        :adapter => "mysql",
                                        :host => "localhost",
                                        :username => "root",
                                        :database => "football_sciencia")

class Initial < ActiveRecord::Migration
  def self.up
    
    create_table('teams') do |t|
      t.column 'name' , :string
    end

    create_table('players') do |t|
      t.column 'number', :integer
      t.column 'team_id', :integer
      # t.column 'global_position_id', :integer
    end

    create_table('global_positions') do |t|
      t.column 'posx', :integer
      t.column 'posy', :integer
      t.column 'posz', :integer
      t.column 'object_id', :integer
      t.column 'game_id', :integer
      t.column 'tick', :integer
    end
=begin
    create_table('global_positions_players') do |t|
      t.column 'player_id', :integer
      t.column 'global_position_id' , :integer
    end
=end
    create_table('event_types') do |t|
      t.column 'name', :string
    end

    create_table('events') do |t|
      t.column 'tick1', :integer
      t.column 'tick2', :integer
      t.column 'event_type_id', :integer
      t.column 'player_id', :integer
      t.column 'game_id', :integer
    end

    create_table('events_players') do |t|
      t.column 'player_id', :integer
      t.column 'event_id', :integer
    end

    create_table('games') do |t|
      t.column 'data', :date
      t.column 'fich', :string
      t.column 'team1_id', :integer
      t.column 'team2_id', :integer
    end
=begin
    create_table('games_global_positions') do |t|
      t.column 'game_id' , :integer
      t.column 'global_position_id' , :integer
    end
=end
    create_table('games_players') do |t|
      t.column 'game_id' , :integer
      t.column 'player_id' , :integer
    end

    create_table('events_games') do |t|
      t.column 'game_id' , :integer
      t.column 'event_id' , :integer
    end


=begin
    create_table('balls') do |t|
      # t.column 'global_position_id', :integer
    end

    create_table('event_types') do |t|
      t.column 'name', :string
    end

    create_table('events') do |t|
      t.column 'moment1_id' , :integer
      t.column 'moment2_id', :integer
      t.column 'event_type_id', :integer
    end

    create_table('games') do |t|
    end

    create_table('games_teams') do |t|
      t.column 'team_id' , :integer , :null => false
      t.column 'game_id', :integer , :null => false
      t.column 'create_at' , :datetime
    end


    create_table('moments') do |t|
      t.column 'tick' , :integer 
    end

    create_table('global_positions') do |t|
      t.column 'x', :integer
      t.column 'y', :integer
      t.column 'z', :integer, :null => true
      t.column 'ball_id', :integer, :null => true
      t.column 'player_id', :integer, :null => true
      t.column 'moment_id', :integer
    end
=end
  end

  def self.down
    drop_table :teams
    drop_table :players
    drop_table :global_positions
    #drop_table :global_positions_players
    drop_table :event_types
    drop_table :events
    drop_table :events_players
    drop_table :games
    #drop_table :games_global_positions
    drop_table :games_players
    drop_table :events_games
  end
end



#puts Initial.migrate(:up)
