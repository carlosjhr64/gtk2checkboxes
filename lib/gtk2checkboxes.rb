class Gtk2CheckBoxes
  HELP = <<~HELP
    Usage:
      gtk2checkboxes [:options+]
    Options:
      -h --help
      -v --version
      --minime      \t Real minime
      --notoggle    \t Minime wont toggle decorated and keep above
      --notdecorated\t Dont decorate window
  HELP
  VERSION = '3.0.210823'

  def self.run
    # StdLib
    require 'find'
    require 'fileutils'
    # Gems
    require 'gtk3app'
    # This Gem
    require_relative 'gtk2checkboxes/config.rb'
    require_relative 'gtk2checkboxes/gtk2checkboxes.rb'
    # Run
    Gtk3App.run(klass:Gtk2CheckBoxes)
  end
end
# Requires:
#`ruby`
#`gedit`
