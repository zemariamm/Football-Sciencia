
module FileManagement

  def replace(file,regex,new_str)
    new_contents = []
    File.open(file) do |fich|
      fs = fich.readlines
      #while ( (s = fich.readline))
      fs.each do |s|
        unless (s =~ regex).nil?
          new_contents << new_str
        else
          #puts s
          new_contents << s
        end
      end

    end
    File.open(file,"w") do |fich|
      new_contents.each do |line|
        fich.puts line
      end
    end
  end

  module_function :replace
end

=begin
file = "/Users/zemariamm/workspace/mestrado/soccer/2d/Teste.java"
regex = /package[\s]+.*;/
new_str = "package soccerscope.file.pattern;"
FileManagement::replace(file,regex,new_str)
=end
