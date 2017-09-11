struct YouData {
    public string title;
    public string author;
    public string embed;
    public string? id; // if null, video doesn't exist

    public YouData(string title="", string author="", string embed="", string? id=null) {
        this.title = title;
        this.author = author;
        this.embed = embed;
        this.id = id;
    }

    public static YouData with_id(string id) {
        var data = YouData();
        data.id = id;

        File f = File.new_for_uri("http://noembed.com/embed?url=http://youtu.be/" + id);
        DataInputStream data_stream = null;
        try {
            data_stream = new DataInputStream(f.read());
        } catch(Error err) {
            stdout.printf("Error: %s\n", err.message);
            return YouData();
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
            return YouData();
        }

        var json_parser = new Json.Parser();
        try {
            json_parser.load_from_data(text.str);
            Json.Node root = json_parser.get_root();

            unowned Json.Object obj = root.get_object();       

            data.title = obj.get_member("title").get_string();
            data.author = obj.get_member("author_name").get_string();

            stdout.printf("%s\n", data.is_valid ? "Yes" : "No");
        } catch(Error err) {
            stdout.printf("Error: %s\n", err.message);
            return YouData();
        }
        return data;
    }

    public bool is_valid {
        get {
            return this.id != null;
        }
    }
}
