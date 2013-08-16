About
=====

 This is a ruby script I wrote to get familiar with the ruby language.
 Currently, it can fetch webpages and save as pdf.

Usage
=====

*  Install `gir_ffi` and `gir_ffi-gtk` gems.

        gem install gir_ffi gir_ffi-gtk

* Make sure gir data for webkit is installed on your system. `gir1.2-webkit-3.0` for ubuntu.

        root @ ~$ dpkg -s gir1.2-webkit-3.0 | grep -i status
        Status: install ok installed

*  Run the script, the webpage will be saved as pdf using its title as filename.

        ./webpage2pdf 'http://www.google.com'

TODO
====

* Lots of stuff
