/**
 * abstract class YouData:
 *    represents data for a youtube video or playlist
 * class YouVideo:
 *    represents a youtube video
 * class YouPlayList:
 *    represents a youtube playlist
 */

abstract class YouData {
    public string title;
    public string embed;
    public string? id;

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
    public string author;

    public YouVideo() {
        this.title = "";
        this.author = "";
        this.embed = "";
        this.id = null;
    }

    public YouVideo.with_id(string id) {
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
            this.embed = "http://youtube.com/embed/" + id + "?rel=0&fs=0";
        } catch(Error err) {
            this.title = ("URL or video ID is invalid: " + err.message);
            return;
        }

        this.id = id;
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

class YouPlayList: YouData {
    public YouPlayList() {
        this.embed = "";
        this.title = "";
        this.id = null;
    }
    public YouPlayList.with_id(string? id) {
        if(id == null) return;

        this.embed = "http://youtube.com/embed?listType=playlist&list=" + id + "&rel=0&fs=0";
        var f = File.new_for_uri(this.embed);
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

        this.id = id;
        
        var titleStart = text.str.index_of("<title>") + 7;
        var titleEnd = text.str.index_of("</", titleStart) - 10;

        this.title = text.str[titleStart:titleEnd];
    }
    public YouPlayList.with_url(string url) {
        var startIndex = 0;
        var endIndex = 0;
        startIndex = url.index_of("list=") + 5;
        endIndex = url.index_of("&", startIndex);
        string id;
        if(endIndex == 0 || endIndex == -1)
            id = url[startIndex:url.length];
        else
            id = url[startIndex:endIndex];

        if(this.id != null)
           this.with_id(id);
    }
}
