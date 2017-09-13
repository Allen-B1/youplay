abstract class YouData {
    public string title;
    public string author;
    public string embed;
    public string? id; // if null, video doesn't exist

    public bool is_valid { get {
        return this.id != null;
    }}

    public string? error { get {
        if(!this.is_valid)
            return this.title;
        else
            return null;
    }}
}

class YouVideo : YouData {
    public YouVideo(string title="", string author="", string embed="", string? id=null) {
        this.title = title;
        this.author = author;
        this.embed = embed;
        this.id = id;
    }

    public YouVideo.with_id(string id) {
        this.id = id;

        stdout.puts("https://youtu.be/" + id);
        stdout.flush();

        File f = File.new_for_uri("https://noembed.com/embed?url=https://youtu.be/" + id);
        DataInputStream data_stream = null;
        try {
            data_stream = new DataInputStream(f.read());
        } catch(Error err) {
            this.title = "Error: " + err.message;
            return;
        }

        var text = new StringBuilder();
        string line;
        try {
            while((line = data_stream.read_line()) != null) {
                text.append(line);
                text.append_c('\n');
            }
        } catch(GLib.IOError err) {
            this.title = "Error: " + err.message;
            return;
        }

        var json_parser = new Json.Parser();
        try {
            json_parser.load_from_data(text.str);
            Json.Node root = json_parser.get_root();

            unowned Json.Object obj = root.get_object();       

            if(obj.has_member("error")) {
                this.title = ("URL or video ID is invalid");
                return;
            }

            this.title = obj.get_string_member("title");
            this.author = obj.get_string_member("author_name");
            this.embed = "http://youtube.com/embed/" + id + "?rel=0";
        } catch(Error err) {
            this.title = ("URL or video ID is invalid: " + err.message);
            return;
        }
        return;
    }

    public YouVideo.with_url(string url) {
        var startIndex = 0;
        var endIndex = 0;
        if(url.index_of("youtu.be") != -1) {
            startIndex = url.index_of("be/") + 3;
            endIndex = 0;
        } else {
            startIndex = url.index_of("v=") + 2;
            endIndex = url.index_of("&", startIndex + 1) + 1;
        }
        string id;
        if(endIndex == 0 || endIndex == -1)
            id = url[startIndex:url.length];
        else
            id = url[startIndex:endIndex];
        this.with_id(id);
    }

    
}
