cd `mktemp -d`
git clone https://github.com/allen-b1/youplay.git
cd youplay
username=`whoami`
make USERNAME=username && echo "Installed YouPlay into $username's account"
