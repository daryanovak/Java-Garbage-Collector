yum install unzip  -y 
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"
yum install jdk-8u131-linux-x64.rpm -y

wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.zip
unzip apache-tomcat-8.5.37.zip
mkdir -p /var/lib/tomcat/
cp -rf ./apache-tomcat-8.5.37/* /var/lib/tomcat/
#Give needed permissions to start apache server
chmod +x /var/lib/tomcat/bin/*.sh
chown vargant: -R /var/lib/tomcat/
#Relocate our app into tomcat/webapps to do it executable
sudo cp /vagrant/TestApp.war /var/lib/tomcat/webapps/
#Make some waiting pause
sleep 5

chown vagrant: /var/lib/tomcat/webapps/TestApp.war
/var/lib/tomcat/bin/startup.sh
sleep 2
chown vagrant: -R /var/lib/tomcat/webapps/TestApp
sleep 2
sudo cp /vagrant/error.jpg /var/lib/tomcat/webapps/TestApp

sudo cp /vagrant/gson-2.8.1.jar /var/lib/tomcat/webapps/TestApp/WEB-INF/lib
sudo cp /vagrant/jstl-1.2.jar /var/lib/tomcat/webapps/TestApp/WEB-INF/lib
chown vagrant: -R /var/lib/tomcat/webapps/TestApp/WEB-INF/lib
chown vagrant: -R /var/lib/tomcat/
sudo /var/lib/tomcat/bin/startup.sh

if [ -f "/var/lib/tomcat/bin/setenv.sh"  ]
	then rm -rf /var/lib/tomcat/bin/setenv.sh
else
chown vagrant: -R /var/lib/tomcat/logs/*
bash -c 'cat<< EOF > /var/lib/tomcat/bin/setenv.sh
export JAVA_OPTS="-Xss1024k \
-Xms256m \
-Xmx512m \
-verbose:gc \
-Xloggc:/var/lib/tomcat/logs/gc.log \
-XX:+HeapDumpOnOutOfMemoryError \
-XX:HeapDumpPath=/var/lib/tomcat/logs \
-Dcom.sun.management.jmxremote=true \
-Dcom.sun.management.jmxremote.port=9999 \
-Dcom.sun.management.jmxremote.ssl=false \
-Dcom.sun.management.jmxremote.authenticate=false \
-Djava.rmi.server.hostname=192.168.56.112"
EOF'
fi
sleep 2
