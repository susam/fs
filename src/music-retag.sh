set -e

retag() {
    f="pub/fs/music/$1/$1.mp3"
    ffmpeg -y -i "$f" \
        -bitexact -map 0:a -c copy -map_metadata -1 -map_chapters -1 \
        -metadata title="$2" \
        -metadata artist="$3" \
        -metadata date="$4" \
        -id3v2_version 3 -write_id3v1 0 \
        "pub/fs/music/$1/retag-$1.mp3"
    cp -v "pub/fs/music/$1/retag-$1.mp3" "$f"
}

retag "a-few-notes"                  "A Few Notes"                     "Susam Pal" "2009"
retag "meadows"                      "Meadows"                         "Susam Pal" "2010"
retag "waiting-for-dawn"             "Waiting for Dawn"                "Susam Pal" "2010"
retag "twinkle-twinkle-little-star"  "Twinkle Twinkle Little Star"     "Susam Pal" "2013"
