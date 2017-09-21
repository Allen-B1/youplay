class YouVideoView : Gtk.Box {
    private YouData data;

    public YouVideoView(YouData video) {
        this.set_orientation(Gtk.Orientation.VERTICAL);
        this.valign = Gtk.Align.START;
        this.hexpand = true;
        this.vexpand = false;
        this.data = video;

        var video_view = new WebKit.WebView();
        video_view.hexpand = true;
        video_view.halign = video_view.valign = Gtk.Align.START;
        video_view.set_size_request(750, 750 * 9 / 16);
        video_view.load_uri(video.embed);

        var author = new Gtk.Label(null);
        author.hexpand = true;
        author.halign = author.valign = Gtk.Align.START;
        author.margin = 12;
        author.margin_top = 0;

        if(this.data is YouVideo) {
            author.set_text(((YouVideo)this.data).author);
        } else {
            author.set_text("Unknown");
        }

        var title = new Gtk.Label(null);
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
