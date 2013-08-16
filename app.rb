require 'gir_ffi-gtk3'
require './webpage.rb'

module Settings
    attr_reader :zoom_level, :left_margin, :right_margin

    def zoom_level=(zoom_level)
        @zoom_level = zoom_level
        @webpages.each do |webpage|
            webpage.webview.set_zoom_level @zoom_level
        end
    end

    def left_margin=(left_margin)
        @pagesetup.set_left_margin left_margin, :mm
    end

    def right_margin=(right_margin)
        @pagesetup.set_right_margin right_margin, :mm
    end
end

class App
    include Settings

    def initialize
        Gtk.init
        trap("SIGINT") { quit }

        @webpages = []
        @zoom_level = 1
        @pagesetup = Gtk::PageSetup.new
    end

    def add_webpage (uri)
        webpage = WebPage.new uri
        @webpages << webpage
    end

    def run
        @webpages.each do |webpage|
            webpage.pagesetup = @pagesetup
        end
        Gtk.main
    end

    def quit
        Gtk.main_quit
    end
end
