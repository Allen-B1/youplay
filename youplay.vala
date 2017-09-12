/* YouPlay
 */

void load_video(Gtk.Label title, Gtk.Label author, Gtk.Window window, bool is_url) {
    var dialog = new Gtk.Dialog.with_buttons("Load Video", window, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.DESTROY_WITH_PARENT, 
        "Done", Gtk.ResponseType.ACCEPT, 
        "Cancel", Gtk.ResponseType.REJECT, null);

    var content_area = dialog.get_content_area();
    content_area.add(new Gtk.Label("Enter video url"));

    var entry = new Gtk.Entry();
    entry.margin = 8;
    content_area.add(entry);
    content_area.show_all();

    int result = dialog.run();
    switch(result) {
    case Gtk.ResponseType.ACCEPT:
        YouData data;
        if(is_url)
            data = YouData.with_url(entry.text);
        else
            data = YouData.with_id(entry.text);
        if(data.is_valid) {
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
    }
    dialog.destroy();
}

int main(string[] args) {
    Gtk.init(ref args);
    
    // Initialize Window
    var window = new Gtk.Window();
    window.title = "YouPlay";
    window.set_position(Gtk.WindowPosition.CENTER);
    window.set_default_size(950, 750);
    window.destroy.connect(Gtk.main_quit);

    var root = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

    // Toolbar
    var toolbar = new Gtk.Toolbar();
    toolbar.vexpand = false;
    toolbar.valign = Gtk.Align.START;

    // Open video from url
    var toolbar_from_url = new Gtk.ToolButton(new Gtk.Image.from_icon_name
        ("document-open",
        Gtk.IconSize.LARGE_TOOLBAR),
        "URL");
    toolbar.insert(toolbar_from_url, -1);

    root.pack_start(toolbar, false, false, 0);

    // Title and Author
    var content = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    content.valign = Gtk.Align.START;
    content.hexpand = true;
    content.vexpand = false;
    root.pack_start(content, false, false, 0);

    var author = new Gtk.Label(null);
    author.hexpand = true;
    author.halign = author.valign = Gtk.Align.START;
    author.margin = 12;
    author.margin_top = 0;

    var title = new Gtk.Label(null);
    title.hexpand = true;
    title.halign = title.valign = Gtk.Align.START;
    title.margin = 12;

    content.add(title);
    content.add(author);

    toolbar_from_url.button_press_event.connect(() => {
        load_video(title, author, window, true);
        return false;
    });

    window.add(root);

    window.show_all();
    Gtk.main();
    return 0;
}
