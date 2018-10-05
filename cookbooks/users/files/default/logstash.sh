chef-client -o recipe[yum-epel]
yum install java-1.7.0-openjdk -y
mkdir /etc/logstash
mkdir /opt/logstash
cd /opt/logstash
wget wget https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar
mv logstash-1.3.3-flatjar.jar logstash.jar
cd /var/tmp
cp agent.conf /etc/logstash/agent.conf
cp logstash-shipper  /etc/init.d/logstash-shipper
chmod +x /etc/init.d/logstash-shipper
chkconfig --level 345 logstash-shipper on
pkill -f logstash.jar
service logstash-shipper stop
service logstash-shipper start
