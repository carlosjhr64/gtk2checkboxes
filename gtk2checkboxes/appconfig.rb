module Configuration
  DEFAULT_TAB = 'CheckBoxes'

  MENU[:close]	= '_Close'
  MENU[:fs]	= '_FullScreen'	if Gtk2App::HILDON

  entry_width	= (Gtk2App::HILDON)? 150: 75
  entry_font	= (Gtk2App::HILDON)? FONT[:large]: FONT[:small]

  # Dialogs
  # Tab Name Entry Dialog (entry)
  TABNAME_ENTRY_MESSAGE	= 'Name:'
  TABNAME_ENTRY_OPTIONS	= {:title=>'New Tab...',:entry_width=>entry_width}.freeze
  # Tab Name Error (quick_message)
  TABNAME_ERROR_MESSAGE	= 'Tab name must be a word'
  TABNAME_ERROR_OPTIONS	= {:title=>'Error'}.freeze
  # Dialog's Choose Tag (choose_tags)
  TABNAME_CHOOSE_OPTIONS = {:title=>'Delete Tab...',:single_choice=>true}.freeze

  # Gtk::Notebook.set_page does not respond until after build :-??
  SET_PAGE_EVENT = 500 # milliseconds to wait before executing set_page

  WIDGET = {:font=>FONT[:small], :entry_font=>entry_font, :entry_width=>entry_width}.freeze
  TOTAL = {:title=>"Totals",:scrolled_width=>nil,:scrolled_height=>nil}.freeze
end
