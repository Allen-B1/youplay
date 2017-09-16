namespace YouTop {
    delegate void LoadFunc(bool is_url);

    Gtk.MenuBar create_menu(LoadFunc load_video, LoadFunc load_playlist) {
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
        return menubar;
    }
}
