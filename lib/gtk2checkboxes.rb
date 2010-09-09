module Gtk2CheckBoxes
include Gtk2AppLib

class Notebook < Widgets::Notebook
  include Gtk2AppLib
  include Configuration
  def add_page(tab=DEFAULT_TAB)
    fn = "#{USERDIR}/#{tab}.txt"
    @tabs[tab] = Page.new(fn,self)
    Widgets::Label.new(tab,self,TAB_OPTIONS)
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
    Find.find(USERDIR){|fn|
      Find.prune if !(fn==USERDIR) && File.directory?(fn)
      if fn=~/\/(\w+)\.txt$/ then
        add_page($1)
      elsif fn=~/\.txt\.bak$/ then
        # Remove previous bak files
        File.unlink(fn)
      end
    }
  end

  def initialize(container)
    super(container)
    @tabs = {}
    load_pages
    add_page	if @tabs.keys.length < 1
  end
end

class Page < Widgets::HBox
  include Gtk2AppLib
  include Configuration
  Widgets.define_composite(:CheckButton,:Entry)
  def add_item(vbox, text='', checked=false)
    cbe = Widgets::CheckButtonEntry.new([CHECK_OPTIONS,'toggled'], text, vbox, ENTRY_OPTIONS,'focus-in-event'){ @changed ||= true }
    cbe.checkbutton.active = checked
    vbox.show_all
  end

  def delete
    @save = false
    @changed = true
    self.destroy
  end

  def parse(vbox)
    top = nil
    nothing = true
    total = 0.0
    active = 0.0
    inactive = 0.0
    vbox.children.each{|child|
      if child.kind_of?( Gtk::HBox ) then
        if child.children.last.kind_of?( Gtk::Entry ) then
          text = child.children.last.text.strip
          top = text if !top
          checked = child.children.first.active?
          if text=~/([\+\-\*\/])((\d+)(\.\d+)?)/ then
            a,d = $1, $2.to_f
            case a
              when '+'
                total += d
                active += d	if checked
                inactive += d	if !checked
              when '-'
                total -= d
                active -= d	if checked
                inactive -= d	if !checked
              when '*'
                total *= d
                active *= d	if checked
                inactive *= d	if !checked
              when '/'
                total /= d
                active /= d	if checked
                inactive /= d	if !checked
            end
            nothing = false if nothing
          end
        end
      end
    }
    if !nothing then
      message = <<EOT
#{top}
Total:\t#{total}
Active:\t#{active}
Inactive:\t#{inactive}
EOT
      DIALOGS.quick_message(message,TOTAL)
    end
  end

  def initialize(data_file,container)
    super(container)
    @save = true
    @changed = false

    button_action = proc {|box,signal,button,event|
      case signal
        when 'clicked' then add_item(box)
        when 'button-press-event' then parse(box) if event.button == 3
      end
    }

    signals = ['clicked', 'button-press-event']

    # Button to add a column
    button1 = Widgets::Button.new('+', self, BUTTON_OPTIONS, *signals){
      vbox1 = Widgets::VBox.new(self)
      # Button to add a row
      button2 = Widgets::Button.new('+', vbox1, BUTTON_OPTIONS, *signals){|*emits| button_action.call(*emits)}
      button2.is = vbox1
      self.show_all
    }

    vbox2 = Widgets::VBox.new(self)
    button3 = Widgets::Button.new('+', vbox2, BUTTON_OPTIONS, *signals){|*emits| button_action.call(*emits)}
    button3.is = vbox2

    File.open(data_file,'r') { |fh|
      fh.each { |line|
        line.strip!
        if line == '' then
          vbox2 = Widgets::VBox.new(self)
          button4 = Widgets::Button.new('+', vbox2, BUTTON_OPTIONS, *signals){|*emits| button_action.call(*emits)}
          button4.is = vbox2
        else
          checked = false
          if line =~ /\*\s+(\S.*)/ then
            line = $1
            checked = true
          end
          add_item(vbox2,line,checked)
        end
      }
    } if File.exist?(data_file)

    self.signal_connect('destroy') {
      if @changed then
        File.rename(data_file, data_file+'.bak') if File.exist?(data_file)
        File.open(data_file,'w'){|fh|
          nl = false
          self.children.each{|vbox|
            if vbox.children.length > 1 then
              count = 0
              vbox.each { |box|
                check, entry = box.children
                if entry && entry.text.strip.length > 0 then
                  count += 1
                  if check.active? then
                    fh.print "*\t"
                  else
                    fh.print "\t"
                  end
                  fh.puts entry.text
                end
              }
              fh.puts if count > 0
            end
          }
        }
        File.rename(data_file, data_file+'.bak') if !@save
      end
    }
  end
end
end
