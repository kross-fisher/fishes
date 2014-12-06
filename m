#! /bin/bash
# m -- play music
# see also: n s

keywords="$@"
locations="/work/Music /home/apple/PPTu/Story"
playlist="/tmp/$$.music"

function play() {
    # stop previous music
    pkill mplayer; MPID=$BASHPID
    kill $(pgrep "^m\b" | grep -v $MPID) >/dev/null 2>&1

    mplayer "$1" >/dev/null 2>&1
    total=$(cat $playlist | wc -l)
    while [ $total -gt 0 ]; do 
        index=$(($RANDOM % $total))
        chosen=$(sed -n "${index}p" $playlist)
        mplayer "$chosen" >/dev/null 2>&1
        sed -i "${index}d" $playlist
        total=$(cat $playlist | wc -l)
        sleep 1
    done
}

#ls $locations/* | grep -i "$keywords" > $playlist
find $locations -type f -name "*${keywords}*" > $playlist
if [ ! -s $playlist ]; then
    echo "No music matches \"$keywords\" found"
    exit 1
fi

total=$(cat $playlist | wc -l)
if [ $total -eq 1 ]; then
    chosen=$(cat $playlist)
    echo "Music chosen: $(basename "$chosen")"
    sed -i "1d" $playlist
    (play "$chosen" &); exit 0
fi

echo "Music files that match: "
#sed "s:$locations/::" $playlist | cat -n
cat -n $playlist
echo -n "Which would you like? [1-$total] "; read index

echo $index | grep -q "^[0-9][0-9]*$" && \
if [ "$index" -ge 1 -a "$index" -le $total ]; then
    chosen=$(sed -n "${index}p" $playlist)
    echo "Music chosen: $(basename "$chosen")"
    sed -i "${index}d" $playlist
    (play "$chosen" &); exit 0
fi

echo "Bad input: $index"
