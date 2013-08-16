
require 'gir_ffi-gtk3'
require 'gir_ffi'

GirFFI.setup :WebKit

class WebPage
    attr_reader :webview, :pagesetup
    attr_writer :pagesetup

    def initialize(uri)
        @uri = uri
        @webview = WebKit::WebView.new
        @webview.load_uri uri
        @webview.signal_connect 'notify::load-status' do on_load_status_changed end
        @webview.signal_connect 'notify::progress' do on_progress_changed end

        window = Gtk::OffscreenWindow.new
        window.add @webview
        window.show_all
    end

    def on_load_status_changed
        status = @webview.get_load_status
        case status
        when :commited
            puts 'Loading #{uri}.'

        when :failed
            puts 'Loading failed. :('
            Gtk.main_quit

        when :finished
            puts "\nLoading finished."
            printoperation = Gtk::PrintOperation.new
            printoperation.set_default_page_setup @pagesetup
            filename = @webview.get_title + '.pdf'
            printoperation.set_export_filename filename

            printoperation.signal_connect('done') do |operation, data|
                puts 'Done.'
                Gtk.main_quit
            end

            frame = @webview.get_main_frame
            puts "Saving page to #{filename}..."
            frame.print_full printoperation,:export
        end
    end

    def on_progress_changed
        progress = object.get_property 'progress'
        percent  = (progress * 100).round
        STDOUT.write "\rLoading page #{percent}% ..."
    end
end
