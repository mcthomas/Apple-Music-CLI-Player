# Apple Music TUI

*scripts compatible with sh, bash, zsh*

### Now Playing

<img src="np.png" width="400"/>

Enjoy a simple "Now Playing" TUI from your terminal.  Uses standard Unix tooling/piping, Applescript for interfacing with Apple Music, and [Viu](https://github.com/atanunq/viu) for displaying the album art images.  Pairs well with the additional Apple Music scripts I've included here.

Dependencies: [Viu](https://github.com/atanunq/viu), [Doug's album-art.applescript](https://dougscripts.com/itunes/2014/10/save-current-tracks-artwork/)

Configuration: 

* Adjust the `-h` dimension of the album art (the two calls to `viu`) to ensure a square appearance with your terminal emulator's line spacing
* Configure a valid path to album-art.applescript, e.g. ~/Library/Scripts/album-art.applescript

Usage: `bash np.sh`

### Listen

Call this script to begin playback of a specified song, album, songs from a specific artist, or songs from a specific playlist.  This is dictated by the flag you pass.  Without specifying a title after the flag will allow you to select on the fly via [fzf](https://github.com/junegunn/fzf).  Unfortunately there is no simple way to play a specific album or songs from a specific artist with Applescript, but I was able to modify code shared by a "jccc" [here](https://discussions.apple.com/thread/1053355), which involves creating a temporary playlist.

Dependencies: [fzf](https://github.com/junegunn/fzf)

Configuration: 

* Remove calls to `np` if you don't have my Now Playing script in your bin or aliased

Usage: `bash listen.sh -s House of Cards`, `bash listen.sh -r In Rainbows`, `bash listen.sh -a Radiohead`, `bash listen.sh -p Radiohead Essentials`

### List Music

List out the contents of different collections or a specific collection in your library.

Usage: `bash songs.sh`, `bash records.sh`, `bash artists.sh`, `bash playlists.sh`, `bash record.sh In Rainbows`, `bash artist.sh Radiohead`, `bash playlist.sh Radiohead Essentials`
