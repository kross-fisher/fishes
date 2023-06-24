
if [ ! -d ~/kross-fisher ]; then
    git clone https://github.com/kross-fisher/kross-fisher.github.io.git kross-fisher
    cd ~/kross-fisher/tools
fi

sudo apt update
sudo apt install snapd
sudo snap install core
sudo snap refresh core
sudo snap install certbot --classic

