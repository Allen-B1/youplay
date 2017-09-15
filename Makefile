all: dependecies build

dependecies:
	dpkg -l webkit2gtk-4.0 || apt install webkit2gtk-4.0
	dpkg -l libgtk-3-dev || apt install libgtk-3-dev
	dpkg -l valac || apt install valac
	dpkg -l glib-2.0 || apt install glib-2.0
	dpkg -l libjson-glib-dev || apt install libjson-glib-dev

build:
	valac youplay.vala youdata.vala --pkg gtk+-3.0 --pkg json-glib-1.0 --pkg webkit2gtk-4.0

install:
	mkdir ~/YouPlay || true
	cp ./youplay ~/YouPlay/youplay
	cp ./youplay.desktop ~/.local/share/applications/
