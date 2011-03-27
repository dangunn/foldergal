#!/bin/sh
BASE=originals
echo "making nav"
OUT_HTML_FILE=`mktemp /tmp/gal_html.XXXXXX`

function replace {
	echo "replace occurences of $2 in $1 with the contents of file $3.  Outpu will go to $4"
	src="$1"
	tag="$2"
	rep="$3"
	out="$4"

	tmp_file=`mktemp /tmp/gal_rep.XXXXXX`
	grep -B10000 "$tag" "$src" | grep -v "$tag" > $tmp_file
	cat "$rep" >> $tmp_file
	grep -A10000 "$tag" "$src" | grep -v "$tag" >> $tmp_file
	mv "$tmp_file" "$out"
}

ls $BASE | while read d; do
	echo "making tmp $OUT_HTML_FILE for $d"
	tmp_title_file=`mktemp /tmp/gal_text.XXXXXX`
	echo "$d" > "$tmp_title_file"
	replace "gallery_template.html" "GALLERY_TITLE" "$tmp_title_file" "$OUT_HTML_FILE"


	tmp_nav_file=`mktemp /tmp/gal_nav.XXXXXX`
	echo "making nav file $tmp_nav_file"
	ls $BASE | while read d2; do
		if [ "$d" = "$d2" ]; then
			echo "$d" >> $tmp_nav_file
		else
			echo "<a href=\"$d2.html\">$d2</a>" >> $tmp_nav_file
		fi
	done

	replace "$OUT_HTML_FILE" "GALLERY_NAVIGATION" "$tmp_nav_file" "$OUT_HTML_FILE"

	tmp_img_tags=`mktemp /tmp/gal_img.XXXXXX`
	ls $BASE/$d/*.jpg | while read f; do
		echo "file $f"
		text_file=`echo $f | sed 's/.jpg/.txt/'`
		if [ -f "$text_file" ]; then
			echo "text file $text_file exists"
			title=`cat $text_file`
		else
			echo "text file $text_file doesnt exist"
			title=`echo $f | sed 's/.*\///' | sed 's/.jpg//'`
		fi
		echo title $title
		f2=`echo $f | sed "s/$BASE\/$d/img/"`
		f3="staging/$f2"
		echo f2 "$f2"
		echo "<li><img src=\"$f2\" title=\"$title\"></li>" >> "$tmp_img_tags"

		echo "resizing $f"
		python resize_image.py "$f"
		if [ $? -ne 0 ]; then
			echo "copying $f to $f3"
			mkdir -p staging/img
			cp "$f" "$f3"
		else
			echo "moving out.jpg to $f3"
			mkdir -p staging/img
			mv out.jpg "$f3"
		fi
	done
	replace "$OUT_HTML_FILE" "GALLERY_IMAGES" "$tmp_img_tags" "$OUT_HTML_FILE"
	mv "$OUT_HTML_FILE" "staging/$d.html"
done
