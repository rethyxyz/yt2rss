# Check for args
[ $# -eq 0 ] && { \
	printf ":: Link to channel(s) not provided\n";
	printf "::\n";
    printf ":: $0 [LINK] [LINK 2] [LINK 3] ...\n";
	exit 1; \
}

if [ $@ = "-h" ] || [ $@ = "--help" ]; then
    printf "$0 - Convert YouTube channel link to RSS feed format.\n"
	printf "\n"
    printf "$0 [LINK] [LINK 2] [LINK 3] ...\n"
	exit 0
fi

URLS=("$@")

for URL in ${URLS[@]}; do
    # I'm sure this sed shit could be done better, but there is not impact
    # performance thus far, so I'll leave it alone.
	CHANNEL_ID=$(\
        curl -s "$URL" \
        | sed -e 's/[{}]/''/g' \
        | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' \
        | grep -m 1 'channelId' \
        | sed \
            -e 's/header\"\:\"c4TabbedHeaderRenderer\"\:\"channelId\"\:\"//g' \
            -e 's/\"//g' \
            -e 's/content\:horizontalListRenderer\:items\:\[gridChannelRenderer\:channelId\://g' \
            -e 's/content\:expandedShelfContentsRenderer\:items\:\[channelRenderer\:channelId\://g' \
    )

	printf "https://www.youtube.com/feeds/videos.xml?channel_id=$CHANNEL_ID\n"
done

exit 0
