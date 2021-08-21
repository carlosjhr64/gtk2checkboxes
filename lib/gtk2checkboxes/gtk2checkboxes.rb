class Gtk2CheckBoxes
  # using Rafini::Exception
  def initialize(stage, toolbar, options)
    notebook = Such::Notebook.new stage, :notebook!
    hbox = Such::Box.new notebook, :hbox!
  end
end
