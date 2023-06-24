
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw status

sudo apt install -y nginx snapd
sudo snap install core
sudo snap refresh core
sudo snap install certbot --classic

sudo certbot --nginx certonly # -d your.domain.xyz
sudo certbot certificates

