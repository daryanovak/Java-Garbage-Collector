yum install unzip wget tar net-tools -y
cd . 
if [[ ! -f "./jdk-8u131-linux-x64.rpm" ]]
	then wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"
yum install jdk-8u131-linux-x64.rpm -y
else
	echo "File jdk-8u131-linux-x64.rpm exists and is installed"
fi

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
sed -i '/<servlet-class>com.epam.nix.java.testapp.servlet.MemoryLeakServlet<\/servlet-class>/a<multipart-config>\n<location>\/tmp<\/location>\n<max-file-size>20848820</\max-file-size>\n<max-request-size>418018841<\/max-request-size>\n<file-size-threshold>1048576<\/file-size-threshold>\n</\multipart-config>' /var/lib/tomcat/webapps/TestApp/WEB-INF/web.xml
sleep 3
chmod +x /var/lib/tomcat/bin/setenv.sh
chown vagrant: /var/lib/tomcat/bin/setenv.sh
sudo /var/lib/tomcat/bin/shutdown.sh
sudo /var/lib/tomcat/bin/startup.sh




