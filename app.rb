require 'gir_ffi-gtk3'
require './webpage.rb'

module Settings
    def initialize
        @zoom_level = 1
    end

    def zoom_level
        return @zoom_level
    end

    def zoom_level=(zoom_level)
        @zoom_level = zoom_level
        @webpages.each do |webpage|
            webpage.webview.set_zoom_level @zoom_level
        end
    end
end

class App
    include Settings

    def initialize(uri)
        Gtk.init
        @webpages = [WebPage.new(uri)]
        trap("SIGINT") { quit }
    end

    def run
        Gtk.main
    end

    def quit
        Gtk.main_quit
    end
end
