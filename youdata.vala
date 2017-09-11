string YouData {
    string title;
    string author;
    string embed;
}

YouData get_data_for(string video) {
    File f = File.new_for_uri("http://noembed.com/embed?url=http://youtu.be/tRFOjLIl7G0");
    DataInputStream data_stream = null;
    try {
        data_stream = new DataInputStream(f.read());
    } catch(Error err) {
        stdout.printf("Error: %s\n", err.message);
        return 1;
    }

    var text = new StringBuilder();
    string line;
    try {
        while((line = data_stream.read_line()) != null) {
            text.append(line);
            text.append_c('\n');
        }
    } catch(GLib.IOError err) {
        stdout.printf("Error: %s\n", err.message);
        return 1;
    }

    var json_parser = new Json.Parser();
    try {
        json_parser.load_from_data(text.str);
        Json.Node root = json_parser.get_root();

        unowned Json.Object obj = root.get_object();       

        var title = obj.get_member("title").get_string();
        stdout.printf("%s\n", title);
    } catch(Error err) {
        stdout.printf("Error: %s\n", err.message);
        return 1;
    }
}
