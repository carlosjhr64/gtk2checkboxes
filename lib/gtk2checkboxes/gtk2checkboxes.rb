class Gtk2CheckBoxes
  # using Rafini::Exception

  class EntryDialog < Such::Dialog
    def initialize(*par)
      super(*par)
      add_button Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL
      add_button Gtk::Stock::OK, Gtk::ResponseType::OK
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

  class YesNo < Such::Dialog
    def initialize(*par)
      super(*par)
      add_button Gtk::Stock::NO, Gtk::ResponseType::CANCEL
      add_button Gtk::Stock::YES, Gtk::ResponseType::OK
    end

    def label(*par)
      Such::Label.new child, *par
    end

    def yes?
      show_all
      response = run
      destroy
      response == Gtk::ResponseType::OK
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

  def add_page(fn, populate:false)
    label = File.basename fn, '.*'
    vbox = Such::Box.new @notebook, :vbox!
    @notebook.set_tab_label vbox, Such::Label.new([label], :tab_label)
    populate_page(fn, vbox) if populate and File.exist? fn
  end

  def clear
    page.each do |item|
      page.remove item
      item.destroy
    end
  end

  def reload
    clear
    populate_page
  end

  def delete
   clear
   # Notebook requires at least one page
   if @notebook.children.length > 1
     @notebook.remove_page @notebook.page
   else
     FileUtils.touch cachefile
   end
  end

  def append(text)
    File.open(cachefile, 'a'){_1.puts '- '+text}
  end

  def get_new_page_name(dialog_key)
    loop do
      dialog = EntryDialog.new dialog_key
      dialog.entry :add_entry!
      Gtk3App.transient dialog
      text = dialog.text
      return text if text.nil? or /^\w+$/.match? text
      dialog_key = :dialog_retry!
    end
  end

  def initialize(stage, toolbar, options)
    @notebook = Such::Notebook.new stage, :notebook!
    Find.find(CACHE) do |fn|
      Find.prune if !(fn==CACHE) && File.directory?(fn)
      case fn
      when %r{/\w+\.txt$}
        add_page fn, populate:true
      when %r{/\w+\.txt\.bak$}
        File.unlink fn
      end
    end
    add_page CONFIG[:DefaultTab] if @notebook.children.empty?
    @tools = Such::Box.new toolbar, :hbox!
    Such::Button.new @tools, :append_item! do
      dialog = EntryDialog.new :item_dialog!
      dialog.entry :dialog_entry!
      Gtk3App.transient dialog
      if text = dialog.text
        append text
        add_check_button page, text, false
      end
    end
    Such::Button.new @tools, :edit_page! do
      start = Time.now
      system "#{CONFIG[:Editor]} #{cachefile}"
      reload if File.mtime(cachefile) > start
    end
    Such::Button.new @tools, :rename_page! do
      if text = get_new_page_name(:rename_dialog!)
        puts "TODO: RENAME" # TODO
      end
    end
    Such::Button.new @tools, :add_page! do
      if text = get_new_page_name(:add_dialog!)
        add_page text
      end
    end
    Such::Button.new @tools, :delete_page! do
      dialog = YesNo.new :delete_dialog!
      dialog.label :delete_label!
      Gtk3App.transient dialog
      if dialog.yes?
        File.rename cachefile, cachefile+'.bak'
        delete
      end
    end
  end
end
