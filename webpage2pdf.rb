#! /usr/bin/env ruby
# A ruby script to convert webpage to pdf using webkitgtk

require 'gir_ffi-gtk3'
require 'gir_ffi'
require 'uri'

GirFFI.setup :WebKit

def main (uri)
    Gtk.init
    webview = WebKit::WebView.new
    webview.load_uri uri

    webview.signal_connect('notify::load-status') do |object, param|
        status = object.get_load_status
        case status
        when :commited
            puts 'Loading #{uri}.'

        when :failed
            puts 'Loading failed. :('
            Gtk.main_quit

        when :finished
            puts "\nLoading finished."
            printoperation = Gtk::PrintOperation.new
            filename = object.get_title + '.pdf'
            printoperation.set_export_filename filename

            printoperation.signal_connect('done') do |operation, data|
                puts 'Done.'
                Gtk.main_quit
            end

            frame = object.get_main_frame
            puts "Saving page to #{filename}..."
            frame.print_full printoperation,:export
        end
    end

    webview.signal_connect('notify::progress') do |object, param|
        progress = object.get_property 'progress'
        percent  = (progress * 100).round
        STDOUT.write "\rLoading page #{percent}%..."
    end

    window = Gtk::OffscreenWindow.new
    window.add webview
    window.show_all

    # handle keyboard interrupt
    trap("SIGINT") { Gtk.main_quit }
    Gtk.main
end

if __FILE__ == $0
    # Argument Checking
    if ARGV.length == 1
        uri = ARGV.first
        if uri =~ URI::regexp
            main uri
        else
            puts 'Invalid URI.'
        end
    else
        puts "Usage: #{$0} URI"
    end
end
