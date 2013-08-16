require 'gir_ffi-gtk3'
require './webpage.rb'

class App
    def initialize(uri)
        Gtk.init
        @webpage = WebPage.new uri

        trap("SIGINT") { quit }
    end

    def run
        Gtk.main
    end

    def quit
        Gtk.main_quit
    end
end
