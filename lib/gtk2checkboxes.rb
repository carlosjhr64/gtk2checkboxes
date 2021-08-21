class Gtk2CheckBoxes
  HELP = <<~HELP
    Usage:
      gtk2checkboxes [:options+]
    Options:
      -h --help
      -v --version
  HELP
  VERSION = '3.0.210821'

  def self.run
    # StdLib
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
