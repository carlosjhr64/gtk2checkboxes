module Gtk2AppLib
  Lock.lock_mode
module Configuration
  # MENU defined in gtk2applib/configuration
  MENU[:close]	= '_Close'	if !HILDON || Gtk2AppLib::Configuration::OSTYPE == 'Internet Tablet OS: maemo Linux based OS2008'
  FONT[:LARGE] = Pango::FontDescription.new( 'Arial 18' ) if HILDON
  MENU[:fs]	= '_FullScreen'	if Gtk2AppLib::HILDON
  MENU[:help]	= '_Help'
end
end

module Gtk2CheckBoxes
module Configuration
  DEFAULT_TAB = 'CheckBoxes'

  TAB_OPTIONS = {}.freeze

  width	= (Gtk2AppLib::HILDON)? 150: 100
  font	= (Gtk2AppLib::HILDON)? Gtk2AppLib::Configuration::FONT[:LARGE]: Gtk2AppLib::Configuration::FONT[:SMALL]

  # Dialogs
  # Tab Name Entry Dialog (entry)
  TABNAME_DIALOG = ['Name:', {:TITLE => 'New Tab...', :width_request => width}].freeze
  # Tab Name Error (quick_message)
  ERROR_MESSAGE = ['Tab name must be a word', {:TITLE=>'Error'}].freeze

  # Dialog's Choose Tag (choose_tags)
  TABNAME_CHOOSE_OPTIONS = {:TITLE=>'Delete Tab...',:SINGLE_CHOICE=>true}.freeze

  BUTTON_OPTIONS = {:modify_font => font}.freeze
  ENTRY_OPTIONS = {:modify_font => font, :width_request= => width}.freeze
  CHECK_OPTIONS = Gtk2AppLib::HNIL

  TOTAL = {:TITLE=>"Totals",:SCROLLED_WINDOW=>false}.freeze

  ADD_TAB = '_Add Tab'
  DELETE_TAB = '_Delete Tab'
end
end
