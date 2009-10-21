require 'java'

require '/Users/zemariamm/workspace/mestrado/soccer/SoccerScope2src-old/SoccerScope2/soccer.jar'
require 'swing-layout-1.0.1.jar'

include_class "soccerscope.file.LogFileReader"
include_class "soccerscope.model.SceneSet"
include_class "soccerscope.model.SceneSetMaker"
include_class "java.util.ArrayList"
include_class "soccerscope.model.GameEvent"

include_class "soccerscope.SoccerScope"

require 'soccerextended.rb'

require 'chart.rb'

require 'rubygems'
require 'cheri/swing'
include Cheri::Swing

@frame_pg = swing.frame do |f|
  @pg = swing.progress_bar
  @pg.setMaximum(100)
  @pg.setValue(0)
end

=begin
#f = LogFileReader.new("teste.rcg")
f = LogFileReader.new("teste13.rcg")

sceneSet = SceneSet.new

ssm = SceneSetMaker.new(f, sceneSet)
ssm.start()
ssm.join

game_events = sceneSet.getEventList
scenes = sceneSet.sceneList
puts "Number of scenes:"
puts scenes.size

Statistics.set_scenes(scenes)

#Statistics.add_event_class(PassMiss)
#Statistics.add_event_class(PassShort)
#Statistics.add_event_class(PassLong)
#Statistics.add_event_class(Shoot)
#Statistics.add_event_class(ShootIntercepted)
#Statistics.add_event_class(ShootTarget)
#Statistics.add_event_class(Goal)
#Statistics.add_event_class(Outside)
#Statistics.add_event_class(Offside)
#Statistics.add_event_class(OffsideIntercept)
Statistics.process

#Statistics.gamestate.print_goals
=end

include_class "soccerscope.model.WorldModel"
@cbitems = []
@@allitems = []
@@is_loaded = nil

#ed = swing.editor_pane

class Displayer
  attr_accessor :main_window
  
  def initialize(window)
    self.main_window =window
  end

end

class MouseJList # MouseListener
  attr_accessor :cbitems, :main_window
  def mouseClicked(e)
    # puts "DEBUG - MOUSECLICKED!!!"
    list = e.getSource
    index = list.locationToIndex(e.getPoint)
    # p self.cbitems
    # p index
    time = self.cbitems[index].time.to_i
    self.main_window.jumpTo(time)
  end

  def mouseEntered(e)
    # puts "mouseEntered"
  end

  def mouseExited(e)
    # puts "mouseExited"
  end

  def mousePressed(e)
    # puts "mousePressed"
  end

  def mouseReleased(e)
    # puts "mouseReleased"
  end

  def setObject(obj)
    obj.addMouseListener(self)
  end
end


@@lism = swing.default_list_model
@jl = swing.list(@@lism)
# @jl.setPreferredSize(Dimension.new(500,500))
@@mousel = MouseJList.new
@@mousel.setObject(@jl)

 
class Filter
  def get_filter
    raise 'Every class has to override this method'
  end
end

class SelectTeam < Filter
  attr_accessor :curitem
  def actionPerformed(e)
    obj = e.getSource
    item = obj.getSelectedItem
    #puts "ITEM SELECIONADO: " + item.to_s
    left_team = -1
    right_team = 1
    both_teans = 2
    self.curitem = item.to_s
    puts "Cur Item:"
    puts self.curitem
    load_combo_items
=begin
    if item.to_s == "Left Team"
      its = @@allitems.find_all { |data| data.team == -1 }
      its.sort! {|a,b| a.time <=> b.time }
      self.display.cbitems = its
      load_combo_items(its)
    elsif item.to_s == "Right Team"
      its = @@allitems.find_all { |data| data.team == 1 }
      its.sort! {|a,b| a.time <=> b.time }
      self.display.cbitems = its
      load_combo_items(its)
    else
      self.display.cbitems = @@allitems
      load_combo_items(@@allitems)
    end
=end
  end

  def get_filter
    puts "Calling filter for item:"
    puts self.curitem
    if self.curitem == "Left Team"
      #return lambda {|items| items.find_all { |data| data.team == -1 } }
      return lambda {|items| items.find_all { |data| data.team == 1 } }
    elsif self.curitem == "Right Team"
      # return lambda {|items| items.find_all { |data| data.team == 1 } }
      return lambda {|items| items.find_all { |data| data.team == -1 } }
    else
      return lambda {|items| items}
    end
  end
end

@cbaction = SelectTeam.new
@@list_of_filters = Array.new
@@list_of_filters << @cbaction



def load_combo_items
  #puts "In load combo_items"
  # sort items by time
  #p @@list_of_filters
  filters = @@list_of_filters.collect { |filter_p_class| puts "Debug: " + filter_p_class.class.to_s; filter_p_class.get_filter }
  curitems = filters.inject(@@allitems) do |result,filter|
    filter.call(result)
  end
  curitems.sort! { |a,b| a.time <=> b.time }
  # tell the mouse listener which items are shown
  @@mousel.cbitems = curitems
  @@lism.clear
  curitems.each do |data|
    @@lism.addElement(data.message.to_s + " - " + data.time.to_s + " - " + data.klass.to_s) if data.message != true
  end
end

def process(sceneset)
=begin
  puts str.class
  f = LogFileReader.new(str)

  sceneSet = SceneSet.new

  ssm = SceneSetMaker.new(f, sceneSet)
  ssm.start()
  ssm.join

  game_events = sceneSet.getEventList

=end
  scenes = sceneset.sceneList
  # scenes = sceneSet.sceneList
  
  puts "Number of scenes:"
  puts scenes.size

  Statistics.set_scenes(scenes)

  Statistics.add_event_class(PassMiss)
  Statistics.add_event_class(Shoot)
  Statistics.add_event_class(ShootIntercepted)
  Statistics.add_event_class(ShootTarget)
  @pg.setValue(5)
  Statistics.add_event_class(Pass)
  @pg.setValue(10)
  Statistics.add_event_class(Goal)
  Statistics.add_event_class(Outside)
  Statistics.add_event_class(Offside)
  @pg.setValue(20)
  Statistics.add_event_class(OffsideIntercept)
  @pg.setValue(100)
  Statistics.process

  puts "Starting..."
  @frame_pg.visible = false
  events = Statistics.get_events
  @@allitems = []
  events.each do |data|
    @@allitems << data
  end
  @@allitems.sort! {|a,b| a.time <=> b.time }
  # @@mousel.cbitems = @@allitems
  load_combo_items
  @@is_loaded = true
  
  # p PassJava.get_list
  @@force_viewer.setListPasses(PassJava.get_list)
  @@pass_viewer.setListPasses(PassJava.get_list)
  calculate_charts("Pass")
  create_table_stats
  # code to create a txt with each klass
  listevents = ["Pass","PassMiss","Shoot","ShootIntercepted","ShootTarget","Goal","Outside","Offside","OffsideIntercept"]
  # File::File.open("resultado.txt","w") do |fich|
  listevents.each do |klass|
    eventsp = events.find_all {|e| e.klass.casecmp(klass) == 0 }
    eventsp.sort! { |a,b| a.time <=> b.time }
    puts "Classe: " + klass
    teams = {}
    eventsp.each do |e|
      if teams[e.team].nil?
        teams[e.team] = 1
      else
        teams[e.team] = teams[e.team] + 1
      end
    end
    teams.keys.each do |team|
      teamevents = eventsp.find_all {|e| e.team == team }
      puts "Right Team" if team.to_i == -1
      puts "Left Team" if team.to_i == 1
      teamevents.each do |e|
        puts "(#{e.time}) #{e.player}"
      end
    end
  end
  # end
  

  
  #load_combo_items(@@allitems)

end

puts "a criar a interface"
include_class "soccerscope.view.ScopePane"
include_class "soccerscope.view.ScopePane"
include_class "soccerscope.view.StatusBar"
include_class "soccerscope.view.ScenePlayer"
include_class "soccerscope.SoccerScopeMenuBar"
include_class "soccerscope.view.layer.DynamicSpineLayer"

scope = SoccerScope.new
@@mousel.main_window = scope
spane = scope.getScopePane
@@force_viewer = spane.getDynamicSpineLayer
@@force_viewer.toogleState() # by default show force model
@@pass_viewer = spane.getPassLayer
# @@pass_viewer.toogleState
dominant_region = spane.getDominatRegionLayer

menu_bar = scope.getSoccerScopeMenuBar # SoccerScopeMenuBar.new(scope)
status_bar = scope.getStatusBar# StatusBar.new(spane)
scene_player = scope.getScenePlayer# ScenePlayer.new(spane,status_bar,false)
tool_bar = scope.getSoccerScopeToolBar
scope.visible = false
swing[:auto]

############ FORCE MODEL CONTROLLER ##################
fforce = swing.frame do |f|
  size 200,200
  box_layout f, :Y_AXIS
  button('Toogle Force Model') { |d|
    on_click { @@force_viewer.toogleState() }
  }
  button('Toogle Teams') {
    on_click { @@force_viewer.toogleTeams() }
  }
  button('Toogle Dominant Region') {
    on_click { dominant_region.toogleState }
  }

  button('Toogle Pass Layer') {
    on_click { @@pass_viewer.toogleState }
  }

  button('Toogle Teams - Pass Layer') {
    on_click { @@pass_viewer.toogleTeams }
  }


  swing.panel do |p|
    box_layout p, :Y_AXIS
    swing.panel do |p1|
      box_layout p1, :X_AXIS
      swing.label "BEG"
      @@beg_model = swing.j_text_field("0")
    end
    
    swing.panel do |p2|
      box_layout p2, :X_AXIS
      swing.label "END"
      @@end_model = swing.j_text_field("6000")
    end

  end

  button('Update Force Model Limits') {
    on_click{ @@force_viewer.setLimit(@@beg_model.getText.to_i,@@end_model.getText.to_i) }
  }

end
fforce.pack
fforce.visible = true

############################## Event Listener controller ##############################
include_class "java.awt.BorderLayout"

# listevents = ["Pass","PassMiss","PassShort","PassLong","Shoot","ShootIntercepted","ShootTarget","Goal","Outside","Offside","OffsideIntercept"]
listevents = ["Pass","PassMiss","Shoot","ShootIntercepted","ShootTarget","Goal","Outside","Offside","OffsideIntercept"]

class CheckBoxController 
  attr_accessor :lchecks
  def initialize
    super
    self.lchecks = []
  end
  def itemStateChanged(e)
    obj = e.getItemSelectable
    puts obj.getLabel
    load_combo_items
  end

  def get_filter
    labels = []
    self.lchecks.each do |checkb|
      labels << checkb.getLabel if checkb.state == true
    end
    return lambda { |items| items.find_all do |item|
        labels.include?(item.klass) 
      end
    }
  end
end
checkcontroller = CheckBoxController.new
@@list_of_filters << checkcontroller

checkboxs = swing.frame do |f|
  size 300, 300
  box_layout f, :Y_AXIS
  listevents.each do |checkevent|
    checkbox(checkevent,true) { |c|  c.addItemListener(checkcontroller) ; checkcontroller.lchecks << c }
  end

end
checkboxs.pack
checkboxs.visible = true



############################## TAB PANEL AND SUB-PANELS ##############################

# Statistics
jpanel1 = swing.panel

jpanel_viewer = cherify(spane)

aux_panel = swing.panel
split_panel_aux = swing.split_pane {|pan|
  pan.setOrientation(javax.swing.JSplitPane::VERTICAL_SPLIT)
  setLeftComponent(cherify(scene_player))
  setRightComponent(cherify(tool_bar))
}

aux_panel.add split_panel_aux
jpanel_controls = cherify(aux_panel)

# Animation

# create event list & checkbox

sp = swing.scroll_pane { |pan|
  pan.setViewportView(@jl)
  setPreferredSize(Dimension.new(300,500))
}
cb = swing.combo_box(["Both Teams","Left Team", "Right Team"].to_java)
cb.addActionListener(@cbaction)



right_panel = swing.panel {|p|
    
  swing.panel do |paux|
    #flow_layout java.awt.FlowLayout::LEADING
    #size 100,100
    add(cb)
  end
  swing.panel do |paux|
    flow_layout java.awt.FlowLayout::LEADING
    #size 500,800
    add(sp)
  end
}

# now add them to the viewer
splitpane1 = swing.split_pane { |tab|
  tab.setOrientation(javax.swing.JSplitPane::VERTICAL_SPLIT)
  setLeftComponent(jpanel_viewer)
  setRightComponent(jpanel_controls)
}

@@anim_panel = swing.panel do |p|
  box_layout p, :X_AXIS
  add(splitpane1)
  add(right_panel)
end

# Tables & Charts
@@splitpane2 = swing.split_pane { |tab|
  tab.setOrientation(javax.swing.JSplitPane::VERTICAL_SPLIT)
  #tab.setLeftComponent(Chart::create_chart("Pontos final Champ",["benfas","sporting","cabecudos"],[80,76,50]))
}

class SelectChart
  attr_accessor :chartklass
  def actionPerformed(e)
    obj = e.getSource
    chartk = obj.getSelectedItem
    calculate_charts(chartk)
  end
end

# @@cbklass = swing.combo_box(["Pass","PassMiss","PassShort","PassLong","Shoot","ShootIntercepted","ShootTarget","Goal","Outside","Offside","OffsideIntercept"].to_java)
@@cbklass = swing.combo_box(["Pass","PassMiss","Shoot","ShootIntercepted","ShootTarget","Goal","Outside","Offside","OffsideIntercept"].to_java)
@@cbklass.addActionListener(SelectChart.new)

@@chart_panel = swing.panel do |pan|
  box_layout pan, :X_AXIS
  pan.add(@@splitpane2)
  pan.add(@@cbklass)
end


def calculate_charts(klass)
  evs = Statistics.get_events
  calculate_passes(evs,klass)
end
def calculate_passes(events,klass)
  passes = events.find_all {|p| p.klass == klass }
  # puts "Numeros golos"
  passes.uniq!
  pass_p_player = Array.new
  players = ["1","2","3","4","5","6","7","8","9","10","11"]
  players.each_with_index do |p,index|
    total = passes.find_all { |pas| pas.player == p.to_i && pas.team == 1}
    pass_p_player[index] = total.size
  end
  @@splitpane2.setLeftComponent(Chart::create_chart(klass + " Team Left",players,pass_p_player))

  passes = events.find_all {|p| p.klass == klass }
  passes.uniq!
  pass_p_player = Array.new
  players = ["1","2","3","4","5","6","7","8","9","10","11"]
  players.each_with_index do |p,index|
    total = passes.find_all { |pas| pas.player == p.to_i && pas.team == -1}
    pass_p_player[index] = total.size
  end
  @@splitpane2.setRightComponent(Chart::create_chart(klass + " Team Right",players,pass_p_player))
end
@@tablepanel = swing.panel do |p|
  size 400, 400
  box_layout p, :Y_AXIS
end

require 'table.rb'
def create_table_stats
  evs = Statistics.get_events
  # klasses = ["Pass","PassMiss","PassShort","PassLong","Shoot","ShootIntercepted","ShootTarget","Goal","Outside","Offside","OffsideIntercept"]
  klasses = ["Pass","PassMiss","Shoot","ShootIntercepted","ShootTarget","Goal","Outside","Offside","OffsideIntercept"]
  res = klasses.collect! do |klass|
    left = evs.find_all {|ev| ev.klass == klass && ev.team == 1}
    right = evs.find_all {|ev| ev.klass == klass && ev.team == -1}
    [klass.to_s,left.size,right.size]
  end
  input = Table::convert_for_table(res)
  table = swing.table(input[0],input[1])
  table.visible = true
=begin
  @nframe = swing.frame do |f|
    box_layout f, :Y_AXIS
    size 400,400
  end
=end

  @@tablepanel.add(table.getTableHeader)
  @@tablepanel.add(table)
end
@@tablepanel.visible = true  

############################## RIGHT TAB - EVENT ##############################




#splitpane1.add(right_panel)
# splitpane1.add(@@anim_panel)

=begin
layout_right_panel = org.jdesktop.layout.GroupLayout.new(right_panel);
right_panel.setLayout(layout_right_panel)



layout_right_panel.setHorizontalGroup(layout_right_panel.createParallelGroup(org.jdesktop.layout.GroupLayout::LEADING).add(layout_right_panel.createSequentialGroup().add(sp,org.jdesktop.layout.GroupLayout::PREFERRED_SIZE, 300, org.jdesktop.layout.GroupLayout::PREFERRED_SIZE)).add(layout_right_panel.createSequentialGroup().add(cb,org.jdesktop.layout.GroupLayout::PREFERRED_SIZE, 300, org.jdesktop.layout.GroupLayout::PREFERRED_SIZE).addContainerGap))


layout_right_panel.setVerticalGroup(layout_right_panel.createParallelGroup(org.jdesktop.layout.GroupLayout::LEADING).add(layout_right_panel.createSequentialGroup().addContainerGap().add(cb,org.jdesktop.layout.GroupLayout::PREFERRED_SIZE, 20, org.jdesktop.layout.GroupLayout::PREFERRED_SIZE).add(sp,org.jdesktop.layout.GroupLayout::PREFERRED_SIZE, 630, org.jdesktop.layout.GroupLayout::PREFERRED_SIZE).addContainerGap))

=end
############################## GLOBAL PANEL ##############################
@frame = swing.frame('Football Scientia') { |f|

  box_layout f, :X_AXIS
  setPreferredSize(Dimension.new(1150,750))
  tabbedpane = swing.tabbed_pane
  # tabbedpane.addTab("Animation",splitpane1.java_object)
  tabbedpane.addTab("Animation",@@anim_panel.java_object)
  #tabbedpane.addTab("Statistics",jpanel1.java_object)
  #tabbedpane.addTab("Charts",@@splitpane2.java_object)
  tabbedpane.addTab("Charts",@@chart_panel.java_object)
  tabbedpane.addTab("Table",@@tablepanel.java_object)


=begin
  layout = org.jdesktop.layout.GroupLayout.new(f.getContentPane());

  layout.setHorizontalGroup(layout.createParallelGroup(org.jdesktop.layout.GroupLayout::LEADING).add(layout.createSequentialGroup().add(tabbedpane, org.jdesktop.layout.GroupLayout::PREFERRED_SIZE, 800, org.jdesktop.layout.GroupLayout::PREFERRED_SIZE).addPreferredGap(org.jdesktop.layout.LayoutStyle::RELATED, 5, 10).add(right_panel,org.jdesktop.layout.GroupLayout::PREFERRED_SIZE,300,org.jdesktop.layout.GroupLayout::PREFERRED_SIZE).addContainerGap()))

  layout.setVerticalGroup(layout.createParallelGroup(org.jdesktop.layout.GroupLayout::LEADING).add(org.jdesktop.layout.GroupLayout::TRAILING, tabbedpane, org.jdesktop.layout.GroupLayout::DEFAULT_SIZE, 469, 500).add(right_panel,org.jdesktop.layout.GroupLayout::PREFERRED_SIZE,630,org.jdesktop.layout.GroupLayout::PREFERRED_SIZE))
=end
  
  #f.getContentPane().setLayout(layout);

  menu_bar { 
    menu('File') {  
      menu_item('Open') { 
        on_click do
          fc = swing.file_chooser
          fc.showOpenDialog(f.java_object)
          file = fc.getSelectedFile
          @pg.setIndeterminate(true)
          sceneset = scope.loadFileStub(fc.java_object)
          sleep 1
          process(sceneset)
          #process(sceneset)
          #process(file.getPath)
        end
      }
      menu_item('Exit') {
        on_click{ @frame.dispose }
      }
    }}

  # f.add(tabbedpane.java_object,java.awt.BorderLayout::CENTER)
}
@frame.pack
@frame.visible = true



@frame_pg.pack
@frame_pg.visible = true
