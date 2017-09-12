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

    var toolbar = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
    toolbar.vexpand = false;
    toolbar.valign = Gtk.Align.START;

    var id_input = new Gtk.Entry();
    id_input.text = "Aed7TgSbCN0";
    toolbar.pack_start(id_input, true, true, 0);

    var button = new Gtk.Button.with_label("Go!");
    toolbar.pack_end(button, true, true, 0);

    root.pack_start(toolbar, true, true, 0);

    var content = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    content.valign = Gtk.Align.START;
    content.expand = true;
    root.pack_end(content);

    var author = new Gtk.Label(null);
    author.hexpand = true;
    author.halign = author.valign = Gtk.Align.START;
    author.margin = 12;

    var title = new Gtk.Label(null);
    title.hexpand = true;
    title.override_background_color(Gtk.StateFlags.NORMAL, {0,0,0,1});
    title.halign = title.valign = Gtk.Align.START;
    title.margin = 12;

    content.add(title);
    content.add(author);

    button.button_press_event.connect(() => {
        YouData data = YouData.with_id(id_input.text);
        if(data.is_valid) {
            title.set_markup("<big><b>" + data.title + "</b></big>");
            author.set_text(data.author);
        } else {
            title.set_text("An error occured.");
        }
        return false;
    });

    window.add(root);

    window.show_all();
    Gtk.main();
    return 0;
}
