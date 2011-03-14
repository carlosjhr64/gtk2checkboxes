require 'find' # Find defined
# Gtk2AppLib defined
# Configuration defined
# File defined
# Gtk defined

module Gtk2CheckBoxes

class Page < Gtk2AppLib::Widgets::HBox # Page defined
  Gtk2AppLib::Widgets.define_composite(:CheckButton,:Entry)

  def initialize(data_file,container)
    super(container)
    @save = true
    @changed = false

    button_action = proc {|box,signal,*event|
      case signal
        when 'clicked' then self.add_item(box)
        when 'button-press-event' then self.parse(box) if event.last.button == 3
      end
      false
    }

    signals = ['clicked', 'button-press-event']

    # Button to add a column
    button1 = Gtk2AppLib::Widgets::Button.new('+', self, Configuration::BUTTON_OPTIONS, *signals){
      vbox1 = Gtk2AppLib::Widgets::VBox.new(self)
      # Button to add a row
      button2 = Gtk2AppLib::Widgets::Button.new('+', vbox1, Configuration::BUTTON_OPTIONS, *signals){|*emits| button_action.call(*emits)}
      button2.is = vbox1
      self.show_all
    }

    vbox2 = Gtk2AppLib::Widgets::VBox.new(self)
    button3 = Gtk2AppLib::Widgets::Button.new('+', vbox2, Configuration::BUTTON_OPTIONS, *signals){|*emits| button_action.call(*emits)}
    button3.is = vbox2

    File.open(data_file,'r') { |fh|
      fh.each { |line|
        line.strip!
        if line == '' then
          vbox2 = Gtk2AppLib::Widgets::VBox.new(self)
          button4 = Gtk2AppLib::Widgets::Button.new('+', vbox2, Configuration::BUTTON_OPTIONS, *signals){|*emits| button_action.call(*emits)}
          button4.is = vbox2
        else
          checked = false
          if line =~ /\*\s+(\S.*)/ then
            line = $1
            checked = true
          end
          self.add_item(vbox2,line,checked)
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
  def add_item(vbox, text='', checked=false)
    cbe = Gtk2AppLib::Widgets::CheckButtonEntry.new([Configuration::CHECK_OPTIONS,'toggled'], text, vbox, Configuration::ENTRY_OPTIONS,'focus-in-event'){ @changed ||= true; false }
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
      Gtk2AppLib::DIALOGS.quick_message(message,Configuration::TOTAL)
    end
  end
end

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
