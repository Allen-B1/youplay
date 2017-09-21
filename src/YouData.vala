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

