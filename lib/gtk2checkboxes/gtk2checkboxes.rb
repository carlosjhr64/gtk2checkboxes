class Gtk2CheckBoxes
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

  def page
    @notebook.children[@notebook.page]
  end

  def tab
    @notebook.get_tab_label(page).text
  end

  def cachefile
    File.join CACHE, tab+'.md'
  end

  def add_check_button(vbox, text, status)
    checkbutton = Such::CheckButton.new(
      vbox,
      {set_label: text, set_active: status},
      :checkbutton!,
      'toggled'
    ) do
      x = checkbutton.active? ? 'x' : ' '
      # Note that x was toggled, so the xbox is inverted for the matcher.
      xbox = checkbutton.active? ? '- [ ]' : '- [x]'
      matcher = "#{xbox} #{checkbutton.label}"
      File.open(cachefile, 'r+') do |fh|
        fh.each_line do |line|
          if matcher == line.chomp
            fh.seek(3-line.length, IO::SEEK_CUR)
            fh.write x
            break
          end
        end
      end
    end
  end

  def populate_page(fn=cachefile, vbox=page)
    File.open(fn, 'r') do |fh|
      fh.each do |line|
        line.chomp!
        case line
        when %r{^\- \[ \] (.*)$}
          add_check_button vbox, $1, false
        when %r{^\- \[x\] (.*)$}
          add_check_button vbox, $1, true
        end
      end
    end
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

  def set_tab_text(text)
    @notebook.get_tab_label(page).set_text text
  end

  def tab_exist?(text)
    @notebook.children.each do |page|
      return true if text == @notebook.get_tab_label(page).text
    end
    return false
  end

  def get_new_page_name(dialog_key)
    loop do
      dialog = EntryDialog.new dialog_key
      dialog.entry :add_entry!
      Gtk3App.transient dialog
      text = dialog.text
      return text if text.nil? or (/^\w+$/.match? text and not tab_exist? text)
      dialog_key = :dialog_retry!
    end
  end

  def append(text)
    File.open(cachefile, 'a'){_1.puts '- [ ] '+text}
  end

  def add_page(fn, populate:false, touch:false)
    label = File.basename fn, '.*'
    vbox = Such::Box.new @notebook, :vbox!
    @notebook.set_tab_label vbox, Such::Label.new([label], :tab_label)
    populate_page(fn, vbox) if populate and File.exist? fn
    FileUtils.touch File.join(CACHE, label+'.md') if touch
  end

  def initialize(stage, toolbar, options)
    @notebook = Such::Notebook.new stage, :notebook!
    Find.find(CACHE) do |fn|
      Find.prune if !(fn==CACHE) && File.directory?(fn)
      case fn
      when %r{/\w+\.md$}
        add_page fn, populate:true
      when %r{/\w+\.md\.bak$}
        File.unlink fn
      end
    end
    add_page CONFIG[:DefaultTab], touch:true if @notebook.children.empty?
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
        File.rename cachefile, File.join(CACHE, text+'.md')
        set_tab_text text
      end
    end
    Such::Button.new @tools, :add_page! do
      if text = get_new_page_name(:add_dialog!)
        add_page text, touch:true
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
