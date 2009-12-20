require 'gtk2applib/gtk2_app_widgets_button.rb'
require 'gtk2applib/gtk2_app_widgets_checkbuttonentry.rb'

module CheckBoxes
  include Configuration
  WIDGET = {:font=>FONT[:small], :entry_width=>90}.freeze

class Page < Gtk::HBox
  def add_item(vbox, text='', checked=false)
    Gtk2App::CheckButtonEntry.new(text, vbox, WIDGET).active = checked
    vbox.show_all
  end

  def delete
    @save = false
    self.destroy
  end

  def initialize(data_file)
    super()
    @save = true
    vbox = nil

    # Button to add a column
    Gtk2App::Button.new('+', self, WIDGET){
      vbox = Gtk::VBox.new
      # Button to add a row
      Gtk2App::Button.new('+', vbox, WIDGET){|value| add_item(value)}.value = vbox
      self.pack_start(vbox, false, false)
      self.show_all
    }

    vbox = Gtk::VBox.new
    Gtk2App::Button.new('+', vbox, WIDGET){|value| add_item(value)}.value = vbox

    File.open(data_file,'r') { |fh|
      fh.each { |line|
        line.strip!
        if line == '' then
          self.pack_start(vbox, false, false)
          vbox = Gtk::VBox.new
          Gtk2App::Button.new('+', vbox, WIDGET){|value| add_item(value)}.value = vbox
        else
          checked = false
          if line =~ /\*\s+(\S.*)/ then
            line = $1
            checked = true
          end
          add_item(vbox,line,checked)
        end
      }
    } if File.exist?(data_file)
    self.pack_start(vbox, false, false)

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
