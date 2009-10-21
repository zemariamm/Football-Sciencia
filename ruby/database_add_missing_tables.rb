require 'rubygems'
require 'activerecord'

ActiveRecord::Base.establish_connection(
                                        #:adapter => "jdbcmysql",
                                        :adapter => "mysql",
                                        :host => "localhost",
                                        :username => "root",
                                        :database => "football_sciencia")
class MoreTables < ActiveRecord::Migration

  def self.up

    create_table('formation_types') do |t|
      t.column 'name' , :string
    end

    create_table('formations') do |t|
      t.column 'formation_type_id' , :integer
      t.column 'team_id', :integer
      t.column 'tick',:integer
      t.column 'game_id', :integer
    end

    
  end

  def self.down
    drop_table :formation_types
    drop_table :formations
  end
end

