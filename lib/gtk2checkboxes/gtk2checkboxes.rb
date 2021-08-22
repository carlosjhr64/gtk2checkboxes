class Gtk2CheckBoxes
  # using Rafini::Exception

  class EntryDialog < Such::Dialog
    def initialize(*par)
      super(*par)
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

  def add_check_button(vbox, text, status)
    Such::CheckButton.new vbox, {set_label: text, set_active: status},
      :checkbutton!
  end

  def page
    @notebook.children[@notebook.page]
  end

  def tab
    @notebook.get_tab_label(page).text
  end

  def cachefile
    File.join CACHE, tab+'.txt'
  end


  def populate_page(fn=cachefile, vbox=page)
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

  def add_page(fn)
    label = File.basename fn, '.*'
    vbox = Such::Box.new @notebook, :vbox!
    @notebook.set_tab_label vbox, Such::Label.new([label], :tab_label)
    populate_page(fn, vbox) if File.exist? fn
  end

  def reload
    page.each do |item|
      page.remove item
      item.destroy
    end
    populate_page
  end

  def append(text)
    File.open(cachefile, 'a'){_1.puts '- '+text}
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
    add_page CONFIG[:DefaultTab] if @notebook.children.empty?
    @tools = Such::Box.new toolbar, :hbox!
    Such::Button.new @tools, :append_item! do
      dialog = EntryDialog.new :entry_dialog!
      dialog.entry :dialog_entry!
      Gtk3App.transient dialog
      if text = dialog.text
        add_check_button page, text, false
        append text
      end
    end
    Such::Button.new @tools, :edit_page! do
      start = Time.now
      system "#{CONFIG[:Editor]} #{cachefile}"
      reload if File.mtime(cachefile) > start
    end
    Such::Button.new @tools, :delete_page! do
    end
    Such::Button.new @tools, :add_page! do
    end
  end
end
