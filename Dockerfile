FROM docker.listcloud.cn:5000/nginx-php7
COPY . /var/www/html
COPY ./devops/config/default.conf /etc/nginx/conf.d/www.diy2015.com.8100.conf
COPY ./devops/config/vhost.conf /opt/docker/etc/nginx/vhost.conf
WORKDIR /var/www/html
RUN ./timer/start.sh
