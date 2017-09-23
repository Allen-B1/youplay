class YouPlayList: YouData {
    public YouPlayList() {
        this.embed = "";
        this.title = "";
        this.id = null;
    }
    public YouPlayList.with_id(string? id) {
        if(id == null) {
            this.title = "An error occured";
            return;
        }

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

        this.with_id(id);
    }
}
