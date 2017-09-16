cd `mktemp -d`
git clone https://github.com/allen-b1/youplay.git
cd youplay
make all NAME=`whoami`
echo "Installed YouPlay into `whoami`'s account"
