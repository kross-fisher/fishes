
which certbot | grep '/certbot$' -q && \
    sudo certbot certificates

function do_setup() {
    local my_domain=''; echo
    read -p 'Input your domain name: ' my_domain

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

    # Modify the nginx web root dir
    local web_root_key='root /var/www/html;'
    local web_config_file='/etc/nginx/sites-available/default'
    grep "$web_root_key" $web_config_file -q && \
        sudo sed -i "s:$web_root_key:root $HOME/kross-fisher; #feixy:" $web_config_file

    # Modify the nginx user to root
    sudo sed -i 's/^user www-data;/user root; #&/' /etc/nginx/nginx.conf

    sudo nginx -s reload  # Reload nginx
}
do_setup
