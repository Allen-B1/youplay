all: dependecies build

dependecies:
	apt show webkit2gtk-4.0 || apt install webkit2gtk-4.0
	apt show libgtk-3-dev || apt install libgtk-3-dev
	apt show valac || apt install valac
	apt show json-glib-1.0 || apt install json-glib-1.0

build:
	valac youplay.vala youdata.vala --pkg gtk+-3.0 --pkg json-glib-1.0 --pkg webkit2gtk-4.0

run: 
	./youplay

b-run: build run
