struct YouData {
    public string title;
    public string author;
    public string embed;
    public string? url; // if null, video doesn't exist

    public YouData(string title="", string author="", string embed="", string? url=null) {
        this.title = title;
        this.author = author;
        this.embed = embed;
        this.url = url;
    }

    public static YouData with_id(string id) {
        return YouData.with_url("http://youtu.be/" + id);
    }

    public static YouData with_url(string url) {
        var data = YouData();
        data.url = url;


        File f = File.new_for_uri("https://noembed.com/embed?url=" + url);
        DataInputStream data_stream = null;
        try {
            data_stream = new DataInputStream(f.read());
        } catch(Error err) {
            return YouData(err.message);
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

            if(obj.has_member("error")) {
                return YouData("URL or video ID is invalid");
            }

            data.title = obj.get_member("title").get_string();
            data.author = obj.get_member("author_name").get_string();
        } catch(Error err) {
            stdout.printf("Error: %s\n", err.message);
            return YouData();
        }
        return data;
    }

    public bool is_valid { get {
        return this.url != null;
    }}

    public string? error { get {
        if(!this.is_valid)
            return this.title;
        else
            return null;
    }}
}
