#!/bin/bash

yum install -y wget;

# Aliyun mirror, fatest in China
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo;

wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo;

sudo yum makecache fast

# Install docker
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

sudo yum makecache fast

sudo yum -y install docker-ce

sudo systemctl enable docker

sudo service docker start

# Install basic tools
yum install -y net-tools telnet iftop nmap-ncat lsof

# Install mysql docker
docker pull registry.docker-cn.com/library/mysql:5.7

docker run --name mysql -e MYSQL_ROOT_PASSWORD=passw0rd -d registry.docker-cn.com/library/mysql:5.7

cat >/usr/bin/mysql_client <<EOL
#!/bin/bash

docker run -it --link mysql:mysql --rm registry.docker-cn.com/library/mysql:5.7 sh -c 'exec mysql -h"mysql" -P3306 -uroot -p"passw0rd"'
EOL

chmod +x /usr/bin/mysql_client

# Install redis docker
docker pull registry.docker-cn.com/library/redis

docker run --name redis -d registry.docker-cn.com/library/redis

cat >/usr/bin/redis_client <<EOL
#!/bin/sh

docker run -it --link redis:redis --rm registry.docker-cn.com/library/redis redis-cli -h redis -p 6379
EOL

chmod +x /usr/bin/redis_client

echo "172.17.0.2 mysql" >> /etc/hosts
echo "172.17.0.3 redis" >> /etc/hosts

# Install golang
wget -O go1.9.tar.gz https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz

tar -C /usr/local -xzf go1.9.tar.gz

rm -f go1.9.tar.gz

echo export PATH='$PATH:/usr/local/go/bin'>/etc/profile.d/go.sh

chmod 0755 /etc/profile.d/go.sh

# Clean up
yum clean all

cat /dev/null > ~/.bash_history && history -c && exit
