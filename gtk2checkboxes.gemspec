Gem::Specification.new do |s|

  s.name     = 'gtk2checkboxes'
  s.version  = '3.0.230113'

  s.homepage = 'https://github.com/carlosjhr64/gtk2checkboxes'

  s.author   = 'CarlosJHR64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2023-01-13'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
Create a simple shopping list.
Maintain a check list of reacuring chores.
Anything that one would make a check list for.

Just a really simple app.
Allows for multiple lists.
DESCRIPTION

  s.summary = <<SUMMARY
Create a simple shopping list.
Maintain a check list of reacuring chores.
Anything that one would make a check list for.
SUMMARY

  s.require_paths = ['lib']
  s.files = %w(
README.md
bin/gtk2checkboxes
data/logo.png
lib/gtk2checkboxes.rb
lib/gtk2checkboxes/config.rb
lib/gtk2checkboxes/gtk2checkboxes.rb
  )
  s.executables << 'gtk2checkboxes'
  s.add_runtime_dependency 'gtk3app', '~> 5.1', '>= 5.1.210203'
  s.requirements << 'ruby: ruby ruby 3.2.0 (2022-12-25 revision a528908271) [aarch64-linux]'
  s.requirements << 'gedit: gedit - Version 40.1'

end
