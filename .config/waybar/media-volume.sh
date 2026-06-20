id=$(wpctl status | awk '/Streams:/{s=1} s && /Spotify/ && !/output_/ {print $1+0; exit}')
id=${id%.}
volume=$(wpctl get-volume "$id" | awk '{printf "%d\n", $2 * 100}')
echo "$volume"


