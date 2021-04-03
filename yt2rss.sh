# Check for args
if [[ $# -eq 0 ]]
then
	echo ":: Link to channel(s) not provided"
	exit 1
elif [[ $@ = "-h" ]] || [[ $@ = "--help" ]]
then
	echo "yt2rss.sh - Fetch YouTube channel RSS feeds"
	echo ""
	echo "yt2rss.sh [LINK] [LINK 2] [LINK 3] ..."
	exit 0
fi

URLS=( "$@" )

for URL in ${URLS[@]}
do
	CHANNEL_ID=$(curl -s "$URL" | sed -e 's/[{}]/''/g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | grep -m 1 'channelId' | sed -e 's/header\"\:\"c4TabbedHeaderRenderer\"\:\"channelId\"\:\"//g' -e 's/\"//g' -e 's/content\:horizontalListRenderer\:items\:\[gridChannelRenderer\:channelId\://g' -e 's/content\:expandedShelfContentsRenderer\:items\:\[channelRenderer\:channelId\://g')
	echo "https://www.youtube.com/feeds/videos.xml?channel_id=$CHANNEL_ID"
done

exit 0
