class Gtk2CheckBoxes
  # using Rafini::Exception
  TABS = {}

  def add_check_button(vbox, name, status)
    check_button = Such::CheckButton.new vbox, :checkbutton!
    check_button.set_label name
    check_button.set_active status
  end

  def add_page(fn)
    label = File.basename fn, '.*'
    vbox = Such::Box.new @notebook, :vbox!
    @notebook.set_tab_label vbox, Gtk::Label.new(label)
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
    # vbox = Such::Box.new notebook, :vbox!
  end
end
