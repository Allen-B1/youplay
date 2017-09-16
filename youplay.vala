/* YouPlay
 */

Gtk.Label title = null;
Gtk.Label author = null;
WebKit.WebView video_view = null;
Gtk.Window window = null;
Gtk.Box root = null;
Gtk.Box content = null;
Gtk.Box start_screen = null;
YouData current_video = null;

// Open video screen, close other screens
void open_content() {
    root.pack_start(content, false, false, 0);
    content.show_all();
    start_screen.destroy();
}

void load_video(bool is_url) {
    var dialog = new Gtk.Dialog.with_buttons("Open Video", window, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.DESTROY_WITH_PARENT, 
        "Done", Gtk.ResponseType.ACCEPT, 
        "Cancel", Gtk.ResponseType.REJECT, null);

    var content_area = dialog.get_content_area();
    content_area.add(new Gtk.Label("Enter video " + (is_url ? "URL" : "ID")));

    var entry = new Gtk.Entry();
    entry.margin = 4;
    content_area.add(entry);
    content_area.show_all();

    int result = dialog.run();
    switch(result) {
    case Gtk.ResponseType.ACCEPT:
        YouVideo data;
        if(is_url)
            data = new YouVideo.with_url(entry.text);
        else
            data = new YouVideo.with_id(entry.text);
        dialog.destroy();

        if(data.is_valid) {
            open_content();
            current_video = data as YouData;

            stdout.puts(data.embed + "\n");
            video_view.load_uri(data.embed);
            title.set_markup("<big><b>" + data.title + "</b></big>");
            author.set_text(data.author);
        } else {
            var error_msg = new Gtk.MessageDialog(window, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.DESTROY_WITH_PARENT,
                Gtk.MessageType.ERROR,
                Gtk.ButtonsType.CLOSE,
                "%s",
                data.error);

            error_msg.run();
            error_msg.close();
        }
        break;
    default:
        dialog.destroy();
        break;
    }
}

bool resize_video_view() {
    int w, h;
    window.get_size(out w, out h);
    video_view.set_size_request((int)((double)w * 0.85), 500);
    return true;
}

void load_playlist(bool is_url) {
    var dialog = new Gtk.Dialog.with_buttons("Open Playlist", window, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.DESTROY_WITH_PARENT, 
        "Done", Gtk.ResponseType.ACCEPT, 
        "Cancel", Gtk.ResponseType.REJECT, null);

    var content_area = dialog.get_content_area();
    content_area.add(new Gtk.Label("Enter playlist " + (is_url ? "URL" : "ID")));

    var entry = new Gtk.Entry();
    entry.margin = 4;
    content_area.add(entry);
    content_area.show_all();

    int result = dialog.run();
    switch(result) {
    case Gtk.ResponseType.ACCEPT:
        var data = new YouPlayList.with_id(entry.text);
        dialog.destroy();

        if(data.is_valid) {
            open_content();
            current_video = data as YouData;

            stdout.puts(data.embed + "\n");
            video_view.load_uri(data.embed);
            title.set_markup("<big><b>" + data.title + "</b></big>");
            author.set_text("Unknown");
        } else {
            var error_msg = new Gtk.MessageDialog(window, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.DESTROY_WITH_PARENT,
                Gtk.MessageType.ERROR,
                Gtk.ButtonsType.CLOSE,
                "%s",
                data.error);

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

    root = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

    {
        // Menubar
        var menubar = new Gtk.MenuBar();
        var file_menu = new Gtk.Menu();
        var file_item = new Gtk.MenuItem.with_label("File");

        var about_item = new Gtk.MenuItem.with_label("About");
        about_item.activate.connect(() => {
            var dialog = new Gtk.MessageDialog.with_markup(window, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.DESTROY_WITH_PARENT,
                Gtk.MessageType.INFO,
                Gtk.ButtonsType.CLOSE,
                "<big><b>%s</b></big>\n%s",
                "About YouPlay",
                "YouPlay is a minimalistic YouTube player.");
            dialog.title = "About";
            dialog.run();
            dialog.destroy();
        });
        file_menu.append(about_item);

        var quit_item = new Gtk.MenuItem.with_label("Quit");
        quit_item.activate.connect(() => {
            window.destroy();
        });
        file_menu.append(quit_item);
        
        file_item.set_submenu(file_menu);
        menubar.append(file_item);


        // Load menu
        var load_menu = new Gtk.Menu();
        var load_item = new Gtk.MenuItem.with_label("Open");


        // Load video menu
        var load_video_menu = new Gtk.Menu();
        var load_video_item = new Gtk.MenuItem.with_label("Video");
        load_video_item.set_submenu(load_video_menu);
        load_menu.append(load_video_item);

        var load_from_url = new Gtk.MenuItem.with_label("From URL");
        load_from_url.activate.connect(() => {
            load_video(true);
        });
        load_video_menu.append(load_from_url);

        var load_from_id = new Gtk.MenuItem.with_label("From ID");
        load_from_id.activate.connect(() => {
            load_video(false);
        });
        load_video_menu.append(load_from_id);


        // Playlist menu
        var load_playlist_item = new Gtk.MenuItem.with_label("Playlist");
        var load_playlist_menu = new Gtk.Menu();
        load_playlist_item.set_submenu(load_playlist_menu);
        load_menu.append(load_playlist_item);

        var load_list_from_id = new Gtk.MenuItem.with_label("From ID");
        load_list_from_id.activate.connect(() => {
            load_playlist(false);
        });
        load_playlist_menu.append(load_list_from_id);

        
        load_item.set_submenu(load_menu);
        menubar.append(load_item);
        root.pack_start(menubar, false, false, 0);
    }


    {
        // Toolbar
        var toolbar = new Gtk.Toolbar();
        toolbar.valign = Gtk.Align.START;

        // Open video from url
        var toolbar_video = new Gtk.ToolButton(new Gtk.Image.from_icon_name
            ("document-open",
            Gtk.IconSize.LARGE_TOOLBAR),
            "Video");
        toolbar_video.clicked.connect(() => {
            load_video(true);
        });
        toolbar.insert(toolbar_video, -1);

        var toolbar_playlist = new Gtk.ToolButton(new Gtk.Image.from_icon_name
            ("insert-object",
            Gtk.IconSize.LARGE_TOOLBAR),
            "Playlist");
        toolbar_playlist.clicked.connect(() => {
            load_playlist(false);
        });
        toolbar.insert(toolbar_playlist, -1);

        var separator = new Gtk.SeparatorToolItem();
        separator.draw = true;
        toolbar.insert(separator, -1);

        var toolbar_share = new Gtk.ToolButton(new Gtk.Image.from_icon_name
            ("emblem-shared",
            Gtk.IconSize.LARGE_TOOLBAR),
            "Share");
        toolbar_share.clicked.connect(() => {
            if(current_video != null) {
                string url = "";
                if(current_video is YouVideo) {
                    url = "https://youtu.be/" + current_video.id;
                } else { // is YouPlayList
                    url = "https://youtube.com/playlist?list=" + current_video.id;
                }
                var dialog = new Gtk.MessageDialog.with_markup(window, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.DESTROY_WITH_PARENT,
                    Gtk.MessageType.INFO,
                    Gtk.ButtonsType.CLOSE,
                    "%s",
                    url);
                dialog.title = "Share";                
                dialog.run();
                dialog.destroy();
            }
        });
        toolbar.insert(toolbar_share, -1);

        root.pack_start(toolbar, false, false, 0);
    }


    // Start screen
    start_screen = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    var welcome_title = new Gtk.Label(null);
    welcome_title.set_markup("<big><b>Welcome!</b></big>");
    var welcome_text = new Gtk.Label("Welcome to YouPlay! Open up a video to start.");
    start_screen.pack_start(welcome_title, true, true, 0);
    start_screen.pack_start(welcome_text, true, true, 0);
    root.pack_start(start_screen, true, false, 0);


    // Actual video viewing thing
    content = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    content.valign = Gtk.Align.START;
    content.hexpand = true;
    content.vexpand = false;

    video_view = new WebKit.WebView();
    video_view.hexpand = true;
    video_view.halign = video_view.valign = Gtk.Align.START;
    video_view.set_size_request(750, 750 * 9 / 16);
    Gdk.threads_add_idle(resize_video_view);

    author = new Gtk.Label("Unknown");
    author.hexpand = true;
    author.halign = author.valign = Gtk.Align.START;
    author.margin = 12;
    author.margin_top = 0;

    title = new Gtk.Label(null);
    title.set_markup("<big><b>N/A</b></big>");
    title.hexpand = true;
    title.halign = title.valign = Gtk.Align.START;
    title.margin = 12;

    content.add(video_view);
    content.add(title);
    content.add(author);

    window.add(root);

    window.show_all();
    Gtk.main();
    return 0;
}
