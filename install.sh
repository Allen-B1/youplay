cd `mktemp -d`
git clone https://github.com/allen-b1/youplay.git
cd youplay
if [ "$1" = "" ] ; then
	read -p "What's your username? " username
else
	username=$1
fi
make USERNAME=$username
echo "Installed YouPlay into $username's account"
