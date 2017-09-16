all: dependecies build install

dependecies:
	dpkg -l libwebkit2gtk-4.0-dev || apt install libwebkit2gtk-4.0-dev
	dpkg -l libgtk-3-dev || apt install libgtk-3-dev
	dpkg -l valac || apt install valac
	dpkg -l glib-* || apt install glib-2.0
	dpkg -l libjson-glib-dev || apt install libjson-glib-dev

build:
	valac youplay.vala youdata.vala --pkg gtk+-3.0 --pkg json-glib-1.0 --pkg webkit2gtk-4.0

install:
	mkdir ~/YouPlay || true
	rm ~/YouPlay/youplay || true
	cp ./youplay ~/YouPlay/youplay
	cp ./icon.png ~/YouPlay/icon.png
	youplay_username=$(USERNAME)
	sed -e "s/username/$(USERNAME)/g" youplay.desktop > ~/.local/share/applications/youplay.desktop
