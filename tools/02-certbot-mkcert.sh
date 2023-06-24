
my_domain=''
read -p 'Input your domain name: ' my_domain

function do_setup() {
    if [ -z "$my_domain" ]; then
        echo "No domain name provided, exit ..."
        return
    fi
    ping $my_domain -c3 | grep '[0-9]\+ received' || {
        echo "Not a valid domain name: $my_domain, exit ..."
        return
    }

    sudo ufw allow 22
    sudo ufw allow 80
    sudo ufw allow 443
    sudo ufw status

    sudo apt install -y nginx snapd
    sudo snap install core
    sudo snap refresh core
    sudo snap install certbot --classic

    sudo certbot --nginx certonly -d $my_domain
    sudo certbot certificates
}

do_setup
