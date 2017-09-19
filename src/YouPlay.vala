/* YouPlay
 */

Gtk.Window window = null;
Granite.Widgets.DynamicNotebook notebook;

void load_video() {
    var dialog = new Gtk.Dialog.with_buttons("Open Video", window, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.DESTROY_WITH_PARENT, 
        "Done", Gtk.ResponseType.ACCEPT, 
        "Cancel", Gtk.ResponseType.REJECT, null);

    var content_area = dialog.get_content_area();
    content_area.add(new Gtk.Label("Enter video URL"));

    var entry = new Gtk.Entry();
    entry.margin = 4;
    content_area.add(entry);
    content_area.show_all();

    int result = dialog.run();
    switch(result) {
    case Gtk.ResponseType.ACCEPT:
        YouVideo data;
        data = new YouVideo.with_url(entry.text);
        dialog.destroy();

        if(data.is_valid) {
            stdout.puts(data.embed + "\n");
            
            var video_view = new YouVideoView(data);
            video_view.add_to(notebook);
        } else {
            var error_msg = new Gtk.MessageDialog(window, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.DESTROY_WITH_PARENT,
                Gtk.MessageType.ERROR,
                Gtk.ButtonsType.CLOSE,
                "%s",
                data.error == null ? "An error occured" : data.error);

            error_msg.run();
            error_msg.close();
        }
        break;
    default:
        dialog.destroy();
        break;
    }
}

void load_playlist() {
    var dialog = new Gtk.Dialog.with_buttons("Open Playlist", window, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.DESTROY_WITH_PARENT, 
        "Done", Gtk.ResponseType.ACCEPT, 
        "Cancel", Gtk.ResponseType.REJECT, null);

    var content_area = dialog.get_content_area();
    content_area.add(new Gtk.Label("Enter playlist URL"));

    var entry = new Gtk.Entry();
    entry.margin = 4;
    content_area.add(entry);
    content_area.show_all();

    int result = dialog.run();
    switch(result) {
    case Gtk.ResponseType.ACCEPT:
        var data = new YouPlayList.with_url(entry.text);
        dialog.destroy()
        
        if(data.is_valid) {
            var video_view = new YouVideoView(data);
            video_view.add_to(notebook);
        } else {
            var error_msg = new Gtk.MessageDialog(window, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.DESTROY_WITH_PARENT,
                Gtk.MessageType.ERROR,
                Gtk.ButtonsType.CLOSE,
                "%s",
                data.error == null ? "An error occured" : data.error);

            error_msg.run();
            error_msg.close();
        }
        break;
    default:
        dialog.destroy();
        break;
    }
}

int main(string[] args) {
    Gtk.init(ref args);
    
    // Initialize Window
    window = new Gtk.Window();
    window.title = "YouPlay";
    window.set_position(Gtk.WindowPosition.CENTER);
    window.set_default_size(750, 450);
    window.destroy.connect(Gtk.main_quit);
    var headerbar = YouTop.create_headerbar(load_video, load_playlist);
    window.set_titlebar(headerbar);

    var root = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

    notebook = new Granite.Widgets.DynamicNotebook();
    notebook.new_tab_requested.connect(() => {
        load_video();
    });
    root.pack_start(notebook, true, true, 0);

    // Start screen
    var start_screen = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    var welcome_title = new Gtk.Label(null);
    welcome_title.set_markup("<big><b>Welcome!</b></big>");
    welcome_title.yalign = 1;
    var welcome_text = new Gtk.Label("Welcome to YouPlay! Open up a video to start.");
    welcome_text.yalign = 0;
    start_screen.pack_start(welcome_title, true, true, 0);
    start_screen.pack_start(welcome_text, true, true, 0);

    var tab = new Granite.Widgets.Tab("Welcome", null, start_screen);

    notebook.insert_tab(tab, -1);

    window.add(root);

    window.show_all();
    Gtk.main();
    return 0;
}
