module Gtk2AppLib
module Configuration

  DEFAULT_TAB = 'CheckBoxes'

  ABOUT = {
	'name'		=> 'Ruby-Gnome CheckBoxes',
        'authors'       => ['carlosjhr64@gmail.com'],
        'website'       => 'http://ruby-gnome-apps.blogspot.com/search/label/Checkboxes',
        'website-label'	=> 'Ruby-Gnome CheckBoxes Blog',
        'license'       => 'GPL',
        'copyright'     => '2010-02-24 09:57:05',
  }


  MENU[:close]	= '_Close'
  MENU[:fs]	= '_FullScreen'	if Gtk2AppLib::HILDON

  TAB_OPTIONS = {}.freeze

  width	= (Gtk2AppLib::HILDON)? 150: 100
  font	= (Gtk2AppLib::HILDON)? FONT[:Large]: FONT[:Small]

  # Dialogs
  # Tab Name Entry Dialog (entry)
  TABNAME_DIALOG = ['Name:', {:Title => 'New Tab...', :width_request => width}].freeze
  # Tab Name Error (quick_message)
  ERROR_MESSAGE = ['Tab name must be a word', {:Title=>'Error'}].freeze

  # Dialog's Choose Tag (choose_tags)
  TABNAME_CHOOSE_OPTIONS = {:Title=>'Delete Tab...',:Single_Choice=>true}.freeze

  BUTTON_OPTIONS = {:modify_font => font}.freeze
  ENTRY_OPTIONS = {:modify_font => font, :width_request= => width}.freeze
  CHECK_OPTIONS = HNIL

  TOTAL = {:Title=>"Totals",:Scrolled_Window=>false}.freeze
end
end
