all: dependecies build

dependecies:
	apt install valac
	apt install json-glib-1.0

build:
	valac youplay.vala youdata.vala --pkg gtk+-3.0 --pkg json-glib-1.0
