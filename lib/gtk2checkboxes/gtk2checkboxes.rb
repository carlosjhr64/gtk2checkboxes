class Gtk2CheckBoxes
  # using Rafini::Exception

  class EntryDialog < Such::Dialog
    def initialize(*par)
      super
      add_button Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL
      add_button Gtk::Stock::ADD, Gtk::ResponseType::OK
    end

    def entry(*par)
      @entry = Such::Entry.new child, *par
    end

    def text
      show_all
      text = (run == Gtk::ResponseType::OK)? @entry.text : nil
      destroy
      text
    end
  end

  TABS = {}

  def add_check_button(vbox, name, status)
    check_button = Such::CheckButton.new vbox, :checkbutton!
    check_button.set_label name
    check_button.set_active status
    check_button
  end

  def add_page(fn)
    label = File.basename fn, '.*'
    vbox = Such::Box.new @notebook, :vbox!
    @notebook.set_tab_label vbox, Such::Label.new([label], :tab_label)
    TABS[label] = vbox
    if File.exist? fn
      File.open(fn, 'r') do |fh|
        fh.each do |line|
          line.chomp!
          case line
          when %r{^\- (\S.*)$}
            add_check_button vbox, $1, false
          when %r{^\+ (\S.*)$}
            add_check_button vbox, $1, true
          end
        end
      end
    end
  end

  def initialize(stage, toolbar, options)
    @notebook = Such::Notebook.new stage, :notebook!
    Find.find(CACHE) do |fn|
      Find.prune if !(fn==CACHE) && File.directory?(fn)
      case fn
      when %r{/\w+\.txt$}
        add_page fn
      when %r{/\w+\.txt\.bak$}
        File.unlink fn
      end
    end
    add_page CONFIG[:DefaultTab] if TABS.length < 1
    @tools = Such::Box.new toolbar, :hbox!
    Such::Button.new @tools, :add_item! do
      dialog = EntryDialog.new :entry_dialog!
      dialog.entry :dialog_entry!
      Gtk3App.transient dialog
      if text = dialog.text
        vbox = @notebook.children[@notebook.page]
        add_check_button(vbox, text, false).show
      end
    end
    Such::Button.new @tools, :delete_item! do
      puts "TODO: delete item."
    end
  end
end
