#!/bin/sh
url="$1"
#save and empty PATH so commands aren't found
#path="$PATH"
#PATH=""
#where the thing should run
#PATH="$path"
encoded="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$url")" ||
{ echo "fallback to jq" >&2;encoded="$(jq -nr --arg v "$url" '$v|@uri')";}||
{ echo "fallback to xxd (brute convert)";echo "$url"|xxd -p|tr -d \\n|sed 's/../%&/g';}||
{ echo "fallback to hexdump (brute convert)";echo "$url"|hexdump -v -e '/1 "%02x"' | sed 's/\(..\)/%\1/g';}
echo "$encoded"
