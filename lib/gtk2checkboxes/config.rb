class Gtk2CheckBoxes
  using Rafini::String # String#semantic
  extend Rafini::Empty # a0 and h0

  CACHE = File.join UserSpace::XDG['cache'], 'gtk3app', 'gtk2checkboxes'
  DATA_DIR = File.join UserSpace::XDG['data'], 'gtk3app', 'gtk2checkboxes'

  CONFIG = {
    DefaultTab: 'TODO',
    Editor: 'gedit',
    HelpFile: 'https://github.com/carlosjhr64/gtk2checkboxes',
    Logo: "#{DATA_DIR}/logo.png",

    about_dialog: {
      set_program_name: 'Gtk2CheckBoxes',
      set_version: VERSION.semantic(0..1),
      set_copyright: '(c) 2021 CarlosJHR64',
      set_comments: 'A Ruby Gtk3App With Check-Boxes',
      set_website: 'https://github.com/carlosjhr64/gtk2checkboxes',
      set_website_label: 'See it at GitHub!',
    },

    entry_dialog: h0,

    ITEM_DIALOG: [title: 'Append Item'],
    item_dialog!: [:ITEM_DIALOG, :entry_dialog],

    RENAME_DIALOG: [title: 'Raname Page'],
    rename_dialog!: [:RENAME_DIALOG, :entry_dialog],

    ADD_DIALOG: [title: 'Add Page'],
    add_dialog!: [:ADD_DIALOG, :entry_dialog],

    DIALOG_RETRY: [title: 'Need one word:'],
    dialog_retry!: [:DIALOG_RETRY, :entry_dialog],

    DIALOG_ENTRY: a0,
    dialog_entry: h0,
    dialog_entry!: [:DIALOG_ENTRY, :dialog_entry],

    ADD_ENTRY: a0,
    add_entry: h0,
    add_entry!: [:ADD_ENTRY, :add_entry],

    DELETE_DIALOG: [title: 'Detete Page'],
    delete_dialog: h0,
    delete_dialog!: [:DELETE_DIALOG, :delete_dialog],

    DELETE_LABEL: ['Are you sure?'],
    delete_label: h0,
    delete_label!: [:DELETE_LABEL, :delete_label],

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
      show: a0,
    },
    vbox!: [:VBOX, :vbox],

    CHECKBUTTON: a0,
    checkbutton: {show: a0},
    checkbutton!: [:CHECKBUTTON, :checkbutton],

    HBOX: [:horizontal],
    hbox: h0,
    hbox!: [:HBOX, :hbox],

    APPEND_ITEM: [label: 'Append item'],
    append_item: h0,
    append_item!: [:APPEND_ITEM, :append_item],

    EDIT_PAGE: [label: 'Edit'],
    edit_page: h0,
    edit_page!: [:EDIT_PAGE, :edit_page],

    ADD_PAGE: [label: 'Add'],
    add_page: h0,
    add_page!: [:ADD_PAGE, :add_page],

    RENAME_PAGE: [label: 'Rename'],
    rename_page: h0,
    rename_page!: [:RENAME_PAGE, :rename_page],

    DELETE_PAGE: [label: 'Delete'],
    delete_page: h0,
    delete_page!: [:DELETE_PAGE, :delete_page],

    app_menu: {
      add_menu_item: [:minime!, :help!, :about!, :quit!],
    },
  }
end
