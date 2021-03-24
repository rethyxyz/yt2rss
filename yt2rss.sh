# Check if args given
if [ $# -eq 0 ]; then echo ":: No link to channel(s) given"; exit 1; fi

URLS=( "$@" )

for URL in ${URLS[@]}
do
	CHANNEL_ID=$(curl -s "$URL" | sed -e 's/[{}]/''/g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | grep -m 1 'channelId' | sed -e 's/header\"\:\"c4TabbedHeaderRenderer\"\:\"channelId\"\:\"//g' -e 's/\"//g' -e 's/content\:horizontalListRenderer\:items\:\[gridChannelRenderer\:channelId\://g' -e 's/content\:expandedShelfContentsRenderer\:items\:\[channelRenderer\:channelId\://g')
	echo "https://www.youtube.com/feeds/videos.xml?channel_id=$CHANNEL_ID"
done
