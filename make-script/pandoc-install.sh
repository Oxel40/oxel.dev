#!/bin/bash -e

if command -v pandoc &> /dev/null
then
	echo "pandoc found" 1>&2
	echo "$(command -v pandoc)"
	exit 0
fi

VERSION="3.1.6"

if command -v "$PWD/pandoc-$VERSION/bin/pandoc" &> /dev/null
then
	echo "pandoc found" 1>&2
	echo "$PWD/pandoc-$VERSION/bin/pandoc"
	exit 0
fi

echo "pandoc not found, installing" 1>&2

wget "https://github.com/jgm/pandoc/releases/download/$VERSION/pandoc-$VERSION-linux-amd64.tar.gz"
tar xvf "pandoc-$VERSION-linux-amd64.tar.gz" 1>&2
echo "$PWD/pandoc-$VERSION/bin/pandoc"
