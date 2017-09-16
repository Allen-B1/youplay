all: dependecies build install

dependecies:
	dpkg -l libwebkit2gtk-4.0-dev || sudo apt install libwebkit2gtk-4.0-dev
	dpkg -l libgtk-3-dev || sudo apt install libgtk-3-dev
	dpkg -l valac || sudo apt install valac
	dpkg -l glib-* || sudo apt install glib-2.0
	dpkg -l libjson-glib-dev || sudo apt install libjson-glib-dev

build:
	valac youplay.vala youdata.vala --pkg gtk+-3.0 --pkg json-glib-1.0 --pkg webkit2gtk-4.0

install:
	mkdir ~/YouPlay || true
	rm ~/YouPlay/youplay || true
	cp ./youplay ~/YouPlay/youplay
	cp ./icon.png ~/YouPlay/icon.png
	sed -e "s/username/$(NAME)/g" youplay.desktop > ~/.local/share/applications/youplay.desktop
