class Gtk2CheckBoxes
  using Rafini::String # String#semantic
  extend Rafini::Empty # a0 and h0

  CACHE = File.join UserSpace::XDG['cache'], 'gtk3app', 'gtk2checkboxes'

  CONFIG = {
    DefaultTab: 'Todo',
    Editor: 'gedit',

    about_dialog: {
      set_program_name: 'Gtk2CheckBoxes',
      set_version: VERSION.semantic(0..1),
      set_copyright: '(c) 2021 CarlosJHR64',
      set_comments: 'A Ruby Gtk3App With Check-Boxes',
      set_website: 'https://github.com/carlosjhr64/gtk2checkboxes',
      set_website_label: 'See it at GitHub!',
    },

    ENTRY_DIALOG: a0,
    entry_dialog: h0,
    entry_dialog!: a0,

    DIALOG_ENTRY: a0,
    dialog_entry: h0,
    dialog_entry!: [:DIALOG_ENTRY, :dialog_entry],

    window: {
      set_title: 'Gtk2CheckBoxes',
      set_window_position: :center,
    },

    NOTEBOOK: a0,
    notebook: h0,
    notebook!: [:NOTEBOOK, :notebook],

    tab_label: h0,

    VBOX: [:vertical],
    vbox: {
      into: [:append_page],
    },
    vbox!: [:VBOX, :vbox],

    CHECKBUTTON: a0,
    checkbutton: {show: a0},
    checkbutton!: [:CHECKBUTTON, :checkbutton],

    HBOX: [:horizontal],
    hbox: h0,
    hbox!: [:HBOX, :hbox],

    ADD_ITEM: [label: 'Add'],
    add_item: h0,
    add_item!: [:ADD_ITEM, :add_item],

    EDIT_ITEMS: [label: 'Edit'],
    edit_items: h0,
    edit_items!: [:EDIT_ITEMS, :edit_items],

    DELETE_ITEM: [label: 'Delete'],
    delete_item: h0,
    delete_item!: [:DELETE_ITEM, :delete_item],

    # app_menu: {
    #   add_menu_item: [ :minime!, :help!, :about!, :quit!  ],
    # },
  }
end
