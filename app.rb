require 'gir_ffi-gtk3'
require './webpage.rb'

module Settings
    attr_reader :zoom_level
    attr_reader :left_margin, :right_margin
    attr_reader :top_margin, :bottom_margin
    attr_reader :scale, :quality, :use_color

    def zoom_level=(zoom_level)
        @zoom_level = zoom_level
        @webpages.each do |webpage|
            webpage.webview.set_zoom_level @zoom_level
        end
    end

    def left_margin=(left_margin)
        @left_margin = left_margin
        @pagesetup.set_left_margin @left_margin, :mm
    end

    def right_margin=(right_margin)
        @right_margin = right_margin
        @pagesetup.set_right_margin @right_margin, :mm
    end

    def top_margin=(top_margin)
        @top_margin = top_margin
        @pagesetup.set_top_margin @top_margin, :mm
    end

    def bottom_margin=(bottom_margin)
        @bottom_margin = bottom_margin
        @pagesetup.set_bottom_margin @bottom_margin, :mm
    end

    def scale=(scale)
        @scale = scale
        @printsettings.set_scale @scale
    end

    def quality=(quality)
        @quality = quality
        @printsettings.set_quality @quality
    end

    def use_color=(use_color)
        @use_color = use_color
        @printsettings.set_use_color @use_color
    end
end

class App
    include Settings

    def initialize
        Gtk.init
        trap("SIGINT") { quit }

        @webpages = []
        @pagesetup = Gtk::PageSetup.new
        @printsettings = Gtk::PrintSettings.new
    end

    def add_webpage (uri)
        webpage = WebPage.new uri
        @webpages << webpage
    end

    def run
        @webpages.each do |webpage|
            webpage.pagesetup = @pagesetup
            webpage.printsettings = @printsettings
        end
        Gtk.main
    end

    def quit
        Gtk.main_quit
    end
end
