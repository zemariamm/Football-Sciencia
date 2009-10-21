require 'rubygems'
require 'activerecord'
require 'ar-extensions'

require File.join(File.dirname(__FILE__)) + "/database_classes.rb"


ft = FormationType.find_by_name "dummy"
ftid = ft[:id]

all_test_formations = Formation.find_all_by_formation_type_id ftid

File.open("formation.arff","w") do |fich|
  fich.puts "@relation formation"
  fich.puts "@attribute id numeric"
  fich.puts "@attribute formation_type_id numeric"
  fich.puts "@attribute team_id numeric"
  fich.puts "@attribute tick numeric"
  fich.puts "@attribute game_id numeric"
  
  fich.puts "@data"
  all_test_formations.each do |f|
    fich.puts "#{f[:id]}, #{f[:formation_type_id]}, #{f[:team_id]}, #{f[:tick]}, #{f[:game_id]}"
  end
end

    



  
  
