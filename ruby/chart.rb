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



include_class "java.awt.Dimension"
include_class "java.awt.Graphics"
include_class "java.awt.Image"
include_class "javax.swing.ImageIcon"
include_class "javax.swing.JFrame"
include_class "javax.swing.JPanel"

include_class "org.jfree.chart.ChartFactory"
include_class "org.jfree.chart.ChartUtilities"
include_class "org.jfree.chart.JFreeChart"
include_class "org.jfree.data.general.DefaultPieDataset"
include_class "org.jfree.data.category.DefaultCategoryDataset"
include_class "java.io.File"

include_class "org.jfree.chart.plot.PlotOrientation"
class ImagePanel < javax.swing.JPanel
  attr_accessor :img

  def initialize(_img)
    super()
    self.img = ImageIcon.new(_img).getImage
    #super(ImageIcon.new(self.img).getImage)
    size = Dimension.new(img.getWidth(nil), img.getHeight(nil))
    setPreferredSize(size)
    setMinimumSize(size)
    setMaximumSize(size)
    setSize(size)
  end

  def paintComponent(g)
    g.drawImage(self.img,0,0,nil)
  end
end

module Chart

  def create_chart(title,labels,values)
    data_set = DefaultCategoryDataset.new
    i = 0
    while i < labels.size
      data_set.setValue(values[i],labels[i],labels[i])
      i = i + 1
    end

=begin


JFreeChart chart = ChartFactory.createBarChart("Comparison between Salesman",
                "Salesman", "Profit", dataset, PlotOrientation.VERTICAL, false,
                true, false);

=end
    chart = ChartFactory.createBarChart(
                                        title,
                                        "",
                                        "",
                                    data_set, 
                                    PlotOrientation::VERTICAL,
                                        false,
                                    true, 
                                    false)
    aux = chart.createBufferedImage(700,300)
    return ImagePanel.new(aux)
  end




  module_function :create_chart
end
=begin
panel = Chart::create_chart("Pontos final Champ",["benfas","sporting","cabecudos"],[80,76,50])
@frame = swing.frame do |f|
  cherify panel
end
@frame.pack
@frame.visible = true
=end
