

int main(string[] args) {
    Gtk.init(ref args);
    
    var window = new Gtk.Window();
    window.title = "YouPlay";
    window.set_position(Gtk.WindowPosition.CENTER);
    window.set_default_size(950, 950);
    window.destroy.connect(Gtk.main_quit);

    var id_input = new Gtk.Entry();

    window.show_all();
    Gtk.main();
    return 0;

}
