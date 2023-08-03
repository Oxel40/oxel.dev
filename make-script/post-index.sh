#!/bin/bash -e

echo '<h1>Posts</h1>'
echo '<ul class="articles">'

first_line=1
for f in $@; do
	if [ $first_line -eq 1 ]; then
		first_line=0
	else
		echo '<hr>'
	fi

	url="$(echo "$f" | grep --only-matching -e '/post/.*\.')html"
	desc="$(grep '^# .*$' "$f" | head -1 | cut -c 3-)"
	date='February 23, 2021'

	echo '<li><a href="'
	echo "$url"
	echo '">'
	echo "$desc"
	echo '</a><p class="date">'
	echo "$date"
	echo '</p></li>'
done

echo '</ul>'

