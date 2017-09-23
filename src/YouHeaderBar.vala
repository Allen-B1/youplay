class YouHeaderBar : Gtk.HeaderBar {
    public delegate void LoadFunc();

    public YouHeaderBar(LoadFunc load_video, LoadFunc load_playlist) {// headerbar
        this.show_close_button = true;
        this.title = "YouPlay";
        this.subtitle = "Welcome";

        // Open video from url
        var headerbar_video = new Gtk.ToolButton(new Gtk.Image.from_icon_name
            ("list-add",
            Gtk.IconSize.SMALL_TOOLBAR),
            "Video");
        headerbar_video.clicked.connect(() => {
            load_video();
            stdout.puts("Done\n");
        });
        this.add(headerbar_video);

        var headerbar_playlist = new Gtk.ToolButton(new Gtk.Image.from_icon_name
            ("insert-object",
            Gtk.IconSize.LARGE_TOOLBAR),
            "Playlist");
        headerbar_playlist.clicked.connect(() => {
            load_playlist();
        });
        this.add(headerbar_playlist);

        var separator = new Gtk.SeparatorToolItem();
        separator.draw = true;
        this.add(separator);

        var headerbar_share = new Gtk.ToolButton(new Gtk.Image.from_icon_name
            ("emblem-shared",
            Gtk.IconSize.LARGE_TOOLBAR),
            "Share");
        headerbar_share.clicked.connect(() => {
            /*if(current_video != null) {
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
            }*/
            var dialog = new Gtk.MessageDialog(window, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.DESTROY_WITH_PARENT,
                Gtk.MessageType.INFO,
                Gtk.ButtonsType.CLOSE,
                "Unfortunately, sharing is not available yet.");

            dialog.title = "Share";                
            dialog.run();
            dialog.destroy();
        });
        this.add(headerbar_share);
    }
}
