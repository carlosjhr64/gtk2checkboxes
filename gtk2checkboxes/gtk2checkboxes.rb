require 'gtk2applib/gtk2_app_widgets_button.rb'
require 'gtk2applib/gtk2_app_widgets_checkbuttonentry.rb'

module CheckBoxes
  include Configuration
  WIDGET = {:font=>FONT[:small], :entry_width=>90}.freeze
  TOTAL = {:title=>"Totals",:scrolled_width=>200,:scrolled_height=>100}.freeze

class Page < Gtk::HBox
  def add_item(vbox, text='', checked=false)
    Gtk2App::CheckButtonEntry.new(text, vbox, WIDGET).active = checked
    vbox.show_all
  end

  def delete
    @save = false
    self.destroy
  end

  def parse(vbox)
    top = nil
    nothing = true
    total = 0.0
    active = 0.0
    inactive = 0.0
    vbox.children.each{|child|
      if child.class == Gtk::HBox then
        if child.children.last.class == Gtk2App::Entry then
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
In-active:\t#{inactive}
EOT
      @dialogs.quick_message(message,TOTAL)
    end
  end

  def initialize(data_file,dialogs)
    super()
    @save = true
    @dialogs = dialogs

    # Button to add a column
    button1 = Gtk2App::Button.new('+', self, WIDGET){
      vbox1 = Gtk::VBox.new
      # Button to add a row
      button2 = Gtk2App::Button.new('+', vbox1, WIDGET){|value| add_item(value)}
      button2.signal_connect('button-press-event'){|s,e| parse(s.parent) if e.button == 3 }
      button2.value = vbox1
      self.pack_start(vbox1, false, false)
      self.show_all
    }

    vbox2 = Gtk::VBox.new
    button3 = Gtk2App::Button.new('+', vbox2, WIDGET){|value| add_item(value)}
    button3.signal_connect('button-press-event'){|s,e| parse(s.parent) if e.button == 3 }
    button3.value = vbox2

    File.open(data_file,'r') { |fh|
      fh.each { |line|
        line.strip!
        if line == '' then
          self.pack_start(vbox2, false, false)
          vbox2 = Gtk::VBox.new
          button4 = Gtk2App::Button.new('+', vbox2, WIDGET){|value| add_item(value)}
          button4.signal_connect('button-press-event'){|s,e| parse(s.parent) if e.button == 3 }
          button4.value = vbox2
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
    self.pack_start(vbox2, false, false)

    self.signal_connect('destroy') {
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
    }
  end
end
end