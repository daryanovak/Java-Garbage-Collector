yum install unzip  -y 
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"
yum install jdk-8u131-linux-x64.rpm -y

wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.zip
unzip apache-tomcat-8.5.37.zip
mkdir -p /var/lib/tomcat/
cp -rf ./apache-tomcat-8.5.37/* /var/lib/tomcat/
#Give needed permissions to start apache server
chmod 654 /var/lib/tomcat/bin/*.sh
chown vagrant: -R /var/lib/tomcat/
#Relocate our app into tomcat/webapps to do it executable
sudo cp /vagrant/TestApp.war /var/lib/tomcat/webapps/
#Make some waiting pause
sleep 5

