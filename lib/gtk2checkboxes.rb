require 'find' # Find defined
# Gtk2AppLib defined
# Configuration defined
# File defined
# Gtk defined

# Check Boxex
module Gtk2CheckBoxes

# Da Page
class Page < Gtk2AppLib::Widgets::HBox # Page defined
  Gtk2AppLib::Widgets.define_composite(:CheckButton,:Entry)
  SIGNALS = ['clicked', 'button-press-event']

  def button_action(box,signal,*event)
    case signal
      when 'clicked' then self.add_item(box,'',false)
      when 'button-press-event' then Page.parse(box) if event.last.button == 3
    end
    false
  end

  def _read(data_file,vbox)
    fh = File.open(data_file,'r')
    fh.each do |line|
      (line.strip! == '')? (vbox = self.last_button) : self.add_item_line(vbox,line)
    end
    fh.close
  end

  def add_item_line(vbox,line)
    checked = false
    if line =~ /\*\s+(\S.*)/ then
      line = $1
      checked = true
    end
    self.add_item(vbox,line,checked)
  end

  def last_button
    vbox = Gtk2AppLib::Widgets::VBox.new(self)
    button = Gtk2AppLib::Widgets::Button.new('+', vbox, Configuration::BUTTON_OPTIONS, *SIGNALS){|*emits| button_action(*emits)}
    button.is = vbox
  end

  def initialize(data_file,container)
    super(container)
    @save = true
    @changed = false

    # Button to add a column
    Gtk2AppLib::Widgets::Button.new('+', self, Configuration::BUTTON_OPTIONS, *SIGNALS){ self.first_button }

    vbox = Gtk2AppLib::Widgets::VBox.new(self)
    button = Gtk2AppLib::Widgets::Button.new('+', vbox, Configuration::BUTTON_OPTIONS, *SIGNALS){|*emits| button_action(*emits)}
    button.is = vbox

    _read(data_file,vbox) if File.exist?(data_file)

    self.signal_connect('destroy'){ self.signal_connect_destroy(data_file) }
  end

  def first_button
    vbox = Gtk2AppLib::Widgets::VBox.new(self)
    # Button to add a row
    button = Gtk2AppLib::Widgets::Button.new('+', vbox, Configuration::BUTTON_OPTIONS, *SIGNALS){|*emits| button_action(*emits)}
    button.is = vbox
    self.show_all
  end

  def self._puts_this(check,entry_text,fh)
    if entry_text =~ /\S/ then
      (check.active?)?  (fh.print "*\t") : (fh.print "\t")
      fh.puts entry_text
      return true
    end
    return false
  end

  def self.puts_this(vbox,fh)
    count = false
    vbox.each do |box|
      check,entry = box.children
      (count ||= true) if (entry && Page._puts_this(check,entry.text,fh))
    end
    fh.puts if count
  end

  def _signal_connect_destroy(data_file)
    fh = File.open(data_file,'w')
    #nl = false
    self.children.each{|vbox| Page.puts_this(vbox,fh) if vbox.children.length > 1 }
    fh.close
  end

  def signal_connect_destroy(data_file)
    bak = data_file+'.bak'
    if @changed || !@save then # not save means delete
      File.rename(data_file, bak) if File.exist?(data_file)
      self._signal_connect_destroy(data_file)	if @save
    end
  end

  def add_item(vbox, text, checked)
    cbe = Gtk2AppLib::Widgets::CheckButtonEntry.new([Configuration::CHECK_OPTIONS,'toggled'], text, vbox, Configuration::ENTRY_OPTIONS,'focus-in-event'){ @changed ||= true; false }
    cbe.checkbutton.active = checked
    vbox.show_all
  end

  def delete
    @save = false
    @changed = true
    self.destroy
  end

  def self.__parse(text,key,counter)
    counter[:TOP] = text if !counter[:TOP]
    if text =~ /([\+\-\*\/])((\d+)(\.\d+)?)/ then
      operator, operand = $1, $2.to_f
      counter[:TOTAL] = counter[:TOTAL].method(operator).call(operand)
      counter[key] = counter[key].method(operator).call(operand)
      counter[:NOTHING] &&= false
    end
  end

  def self._parse(child_children,counter)
    child_children_last = child_children.last
    Page.__parse(
	child_children_last.text.strip,
	(child_children.first.active?)? :ACTIVE : :INACTIVE,
	counter
    ) if child_children_last.kind_of?( Gtk::Entry )
  end

  def self.parse_report(counter)
    message = <<EOT
#{counter[:TOP]}
Total:\t#{counter[:TOTAL]}
Active:\t#{counter[:ACTIVE]}
Inactive:\t#{counter[:INACTIVE]}
EOT
    Gtk2AppLib::DIALOGS.quick_message(message,Configuration::TOTAL)
  end

  def self.parse(vbox)
    counter = Hash.new(0)
    counter[:TOP] = nil
    counter[:NOTHING] = true
    vbox.children.each{|child| Page._parse(child.children,counter) if child.kind_of?( Gtk::HBox ) }
    Page.parse_report(counter) if !counter[:NOTHING]
  end
end

# Da Notebook
class Notebook < Gtk2AppLib::Widgets::Notebook

  def initialize(container)
    super(container)
    @tabs = {}
    self.load_pages
    self.add_page	if @tabs.keys.length < 1
  end

  def add_page(tab=Configuration::DEFAULT_TAB)
    fn = "#{Gtk2AppLib::USERDIR}/#{tab}.txt"
    @tabs[tab] = Page.new(fn,self)
    Gtk2AppLib::Widgets::Label.new(tab,self,Configuration::TAB_OPTIONS)
    self.show_all
  end

  def delete(tab)
    @tabs[tab].delete
    @tabs.delete(tab)
  end

  def has_tab?(tab)
    @tabs.has_key?(tab)
  end

  def tabs
    @tabs.keys
  end

  def load_pages
    Find.find(Gtk2AppLib::USERDIR){|fn|
      Find.prune if !(fn==Gtk2AppLib::USERDIR) && File.directory?(fn)
      if fn=~/\/(\w+)\.txt$/ then
        add_page($1)
      elsif fn=~/\.txt\.bak$/ then
        # Remove previous bak files
        File.unlink(fn)
      end
    }
  end


end
end
