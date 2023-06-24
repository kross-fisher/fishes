
if [ ! -d ~/fishes ]; then
    cd && git clone git@github.com:kross-fisher/fishes.git
fi

sudo apt update
sudo apt install vim git nginx -y

cp /usr/share/vim/vim*/vimrc_example.vim ~/.vimrc
#wget --no-check-certificate https://www.melabear.cn/download/vimrc.txt -q -O - | tail -n22 >> ~/.vimrc
cat ~/fishes/vimrc.txt | tail -n22 >> ~/.vimrc
