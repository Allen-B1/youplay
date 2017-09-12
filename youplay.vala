/* YouPlay
 */

int main(string[] args) {
    Gtk.init(ref args);
    
    // Initialize Window
    var window = new Gtk.Window();
    window.title = "YouPlay";
    window.set_position(Gtk.WindowPosition.CENTER);
    window.set_default_size(950, 950);
    window.destroy.connect(Gtk.main_quit);

    var root = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

    var toolbar = new Gtk.Toolbar();
    toolbar.vexpand = false;
    toolbar.valign = Gtk.Align.START;

    var toolbar_from_id = new Gtk.ToolButton(null, "ID");
    toolbar.insert(toolbar_from_id, -1);

    root.pack_start(toolbar, false, false, 0);

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

    toolbar_from_id.button_press_event.connect(() => {
        var dialog = new Gtk.Dialog.with_buttons("Load Video", window, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.DESTROY_WITH_PARENT, 
            "Done", Gtk.ResponseType.ACCEPT, 
            "Cancel", Gtk.ResponseType.REJECT, null);

        var content_area = dialog.get_content_area();
        var entry = new Gtk.Entry();
        entry.show();
        content_area.add(entry);

        int result = dialog.run();
        switch(result) {
        case Gtk.ResponseType.ACCEPT:
            YouData data = YouData.with_id(entry.text);
            if(data.is_valid) {
                title.set_markup("<big><b>" + data.title + "</b></big>");
                author.set_text(data.author);
            } else {
                title.set_text("An error occured.");
                author.set_text("");
            }
            break;
        }            
        dialog.close();
        return false;
    });

    window.add(root);

    window.show_all();
    Gtk.main();
    return 0;
}
