FILE_PATH ?= lib/js/3rdparty

all: Makefile build

uglify:
	uglifyjs $(FILE_PATH)/d3.min.js $(FILE_PATH)/jquery.js $(FILE_PATH)/jquery.fittext.js $(FILE_PATH)/jquery.photoset-grid.min.js $(FILE_PATH)/leaflet.js $(FILE_PATH)/underscore-min.js -o lib/js/3rdparty.min.js
	uglifyjs lib/js/sstory.js -o lib/js/sstory.min.js
	
build: uglify