class Gtk2CheckBoxes
  using Rafini::String # String#semantic
  # extend Rafini::Empty # a0 and h0
  CONFIG = {
    about_dialog: {
      set_program_name: 'Gtk2CheckBoxes',
      set_version: VERSION.semantic(0..1),
      set_copyright: '(c) 2021 CarlosJHR64',
      set_comments: 'A Ruby Gtk3App With Check-Boxes',
      set_website: 'https://github.com/carlosjhr64/gtk2checkboxes',
      set_website_label: 'See it at GitHub!',
    },
    window: {
      set_title: 'Gtk2CheckBoxes',
      set_window_position: :center,
    },
    # app_menu: {
    #   add_menu_item: [ :minime!, :help!, :about!, :quit!  ],
    # },
  }
end
