module Gtk2AppLib
module Configuration
  # MENU defined in gtk2applib/configuration
  MENU[:close]	= '_Close'	if !HILDON || Gtk2AppLib::Configuration::OSTYPE == 'Internet Tablet OS: maemo Linux based OS2008'
  FONT[:Large] = Pango::FontDescription.new( 'Arial 18' ) if HILDON
  MENU[:fs]	= '_FullScreen'	if Gtk2AppLib::HILDON
end
end

module Gtk2CheckBoxes
module Configuration
  DEFAULT_TAB = 'CheckBoxes'

  TAB_OPTIONS = {}.freeze

  width	= (Gtk2AppLib::HILDON)? 150: 100
  font	= (Gtk2AppLib::HILDON)? Gtk2AppLib::Configuration::FONT[:Large]: Gtk2AppLib::Configuration::FONT[:Small]

  # Dialogs
  # Tab Name Entry Dialog (entry)
  TABNAME_DIALOG = ['Name:', {:Title => 'New Tab...', :width_request => width}].freeze
  # Tab Name Error (quick_message)
  ERROR_MESSAGE = ['Tab name must be a word', {:Title=>'Error'}].freeze

  # Dialog's Choose Tag (choose_tags)
  TABNAME_CHOOSE_OPTIONS = {:Title=>'Delete Tab...',:Single_Choice=>true}.freeze

  BUTTON_OPTIONS = {:modify_font => font}.freeze
  ENTRY_OPTIONS = {:modify_font => font, :width_request= => width}.freeze
  CHECK_OPTIONS = Gtk2AppLib::HNIL

  TOTAL = {:Title=>"Totals",:Scrolled_Window=>false}.freeze
end
end
