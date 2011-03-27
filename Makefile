gallery: init
	cp img/* staging/img
	#cp src/* staging
	sh make_gallery.sh

init: 
	mkdir staging
	mkdir staging/img

clean:
	rm -rf staging
