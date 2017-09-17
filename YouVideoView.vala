class YouVideoView : Gtk.Box {
    private YouData data;

    public YouVideoView(YouData video) {
        this.set_orientation(Gtk.Orientation.VERTICAL);
        this.valign = Gtk.Align.START;
        this.hexpand = true;
        this.vexpand = false;
        this.data = video;

        video_view = new WebKit.WebView();
        video_view.hexpand = true;
        video_view.halign = video_view.valign = Gtk.Align.START;
        video_view.set_size_request(750, 750 * 9 / 16);
        video_view.load_uri(video.embed);
        Gdk.threads_add_idle(() => {
            int w, h;
            window.get_size(out w, out h);
            video_view.set_size_request(w - 160, 500);
            return true;
        });

        if(this.data is YouVideo) {
            author = new Gtk.Label(((YouVideo)this.data).author);
            author.hexpand = true;
            author.halign = author.valign = Gtk.Align.START;
            author.margin = 12;
            author.margin_top = 0;
        }

        title = new Gtk.Label(null);
        title.set_markup("<big><b>" + this.data.title + "</b></big>");
        title.hexpand = true;
        title.halign = title.valign = Gtk.Align.START;
        title.margin = 12;

        this.add(video_view);
        this.add(title);
        this.add(author);
    }

    public void add_to(Gtk.Notebook notebook) {
        this.show_all();
        notebook.append_page(this, new Gtk.Label(this.data.title));
    }
}
