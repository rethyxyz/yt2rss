#!/usr/bin/env bash

[[ "$#" -eq 0 ]] || [[ "$@" = "-h" ]] || [[ "$@" = "--help" ]] \
	&& printf "%s: Convert YouTube channel link to RSS feed format.\n" "$0" \
	&& printf "\t%s [LINK] [LINK 2] [LINK 3] ...\n" "$0" \
	&& exit 0

for url in "$@"; do
	id=$(\
		curl -s "$url"\
		| sed -e 's/[{}]/''/g'\
		| awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}'\
		| grep -m 1 'channelId'\
		| sed\
			-e 's/header\"\:\"c4TabbedHeaderRenderer\"\:\"channelId\"\:\"//g'\
			-e 's/\"//g'\
			-e 's/content\:horizontalListRenderer\:items\:\[gridChannelRenderer\:channelId\://g'\
			-e 's/content\:expandedShelfContentsRenderer\:items\:\[channelRenderer\:channelId\://g'\
	)

	printf "https://www.youtube.com/feeds/videos.xml?channel_id=$id\n"
done