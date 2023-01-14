Gem::Specification.new do |s|

  s.name     = 'gtk2checkboxes'
  s.version  = '3.1.230114'

  s.homepage = 'https://github.com/carlosjhr64/gtk2checkboxes'

  s.author   = 'CarlosJHR64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2023-01-14'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
More than just check-boxes.
Create a simple check list, bookmarks, or start menu.
DESCRIPTION

  s.summary = <<SUMMARY
More than just check-boxes.
Create a simple check list, bookmarks, or start menu.
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
  s.add_runtime_dependency 'gtk3app', '~> 5.4', '>= 5.4.230109'
  s.requirements << 'ruby: ruby 3.2.0 (2022-12-25 revision a528908271) [aarch64-linux]'
  s.requirements << 'gedit: gedit - Version 3.38.1'

end
