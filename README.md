# Ruby-Gnome CheckBoxes

* [VERSION 3.0.230113](https://github.com/carlosjhr64/gtk2checkboxes/releases)
* [github](https://www.github.com/carlosjhr64/gtk2checkboxes)
* [rubygems](https://rubygems.org/gems/gtk2checkboxes)

![Day Mode](img/snapshot.png)

## DESCRIPTION

Create a simple shopping list.
Maintain a check list of recurring chores.
Anything that one would make a check list for.

Just a really simple app.
Allows for multiple lists.

## INSTALL
```shell
gem install gtk2checkboxes
```
## HELP
```shell
$ gtk2checkboxes --help
Usage:
  gtk2checkboxes [:options+]
Options:
  -h --help
  -v --version
  --minime      	 Real minime
  --notoggle    	 Minime wont toggle decorated and keep above
  --notdecorated	 Dont decorate window
```
## More

* Mouse button 1 on logo: minime
* Mouse button 2 on logo: app menu
* Toolbar "Edit" button opens the tasks markdown file with `gedit` by default
* Configuration file: `~/.config/gtk3app/gtk2checkboxes/config-*.rbon`

You can change your editor from `gedit` to something else in the configuration
file.  The process should not detach(go to background).  For example, I edited
my `Editor:` key from:

    Editor: "gedit $cachefile",

to:

    Editor: "foot -W 80x13 nvim $cachefile 2>/dev/null",

Note that the tasks cache file is markdown.
Any line that matches `/^- \[x| \] /` is considered to be a check box and
should be followed by an item to be checked off.
All other lines are ignored by the application.

## LICENSE

(The MIT License)

Copyright (c) 2023 CarlosJHR64

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
