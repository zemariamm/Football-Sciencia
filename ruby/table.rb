require 'java'

require '/Users/zemariamm/workspace/mestrado/soccer/2d/chartlib/gnujaxp.jar'
require '/Users/zemariamm/workspace/mestrado/soccer/2d/chartlib/iText-2.1.3.jar'
require '/Users/zemariamm/workspace/mestrado/soccer/2d/chartlib/jcommon-1.0.15.jar'
require '/Users/zemariamm/workspace/mestrado/soccer/2d/chartlib/jfreechart-1.0.12-experimental.jar'
require '/Users/zemariamm/workspace/mestrado/soccer/2d/chartlib/jfreechart-1.0.12-swt.jar'
require '/Users/zemariamm/workspace/mestrado/soccer/2d/chartlib/jfreechart-1.0.12.jar'
require '/Users/zemariamm/workspace/mestrado/soccer/2d/chartlib/servlet.jar'
require '/Users/zemariamm/workspace/mestrado/soccer/2d/chartlib/swtgraphics2d.jar'

require 'rubygems'
require 'cheri/swing'
include Cheri::Swing

include_class "javax.swing.JFrame"
include_class "javax.swing.JPanel"
include_class "javax.swing.JTable"
# include_class "java.util.Vector"
Vector = java.util.Vector

module Table
  include Cheri::Swing
  # dados must be something like a array of arrays where each inner array is
  # something in this line: ["Pass", num_pass_left_team, num_pass_right_team]
  
  def convert_for_table(dados)
    global = Vector.new

    first = Vector.new
    first.add ""; first.add "Left Team"; first.add "Right Team"
    global.add first

    dados.each do |line|
      klass = line[0]
      left_num = line[1]
      right_num = line[2]
      aux = Vector.new; aux.add klass; aux.add left_num ; aux.add right_num
      global.add aux
    end
    names = Vector.new
    dados.each { |d| names.add "" }
    return [global,names]
  end

  module_function :convert_for_table
end
=begin
dados = [["Goal",2,3],["Pass",20,49],["Shoot",2,4], ["jvgvhgV",322,32]]
input = Table::convert_for_table(dados)
table = swing.table(input[0],input[1])
table.visible = true

@frame = swing.frame do |f|
  box_layout f, :Y_AXIS
  size 400,400
end

@frame.add(table.getTableHeader)
@frame.add(table)
table.visible = true
@frame.pack
@frame.visible = true
=end
