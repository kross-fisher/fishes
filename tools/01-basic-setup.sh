
if [ ! -d ~/fishes ]; then
    cd; git clone git@github.com:kross-fisher/fishes.git; cd -
fi
if [ ! -d ~/kross-fisher ]; then
    cd; git clone git@github.com:kross-fisher/kross-fisher.github.io.git kross-fisher; cd -
fi

sudo apt update
sudo apt install vim git gcc g++ nginx -y

cp /usr/share/vim/vim*/vimrc_example.vim ~/.vimrc
cat ~/fishes/vimrc.txt | tail -n22 >> ~/.vimrc

git config --global core.editor vim
git config --global user.name feixy
git config --global user.email kross.fisher@gmail.com
