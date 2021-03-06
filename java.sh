#Download and install OPENJDK
yum install unzip wget tar net-tools -y
cd . 
if [[ ! -f "./jdk-8u131-linux-x64.rpm" ]]
	then wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"
yum install jdk-8u131-linux-x64.rpm -y
else
	echo "File jdk-8u131-linux-x64.rpm exists and is installed"
fi
#Adding specific user and group for tomcat service
mkdir -p /var/lib/tomcat
groupadd tomcat
useradd -M -s /bin/nologin -g tomcat -d /var/lib/tomcat tomcat
#Download and install TOMCAT
wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.40/bin/apache-tomcat-8.5.40.zip
unzip apache-tomcat-8.5.40.zip
cp -rf ./apache-tomcat-8.5.40/* /var/lib/tomcat/
chmod +x /var/lib/tomcat/bin/*.sh
chown tomcat: -R /var/lib/tomcat/
#Relocate our app into tomcat/webapps to do it executable
cp /opt/TestApp.war /var/lib/tomcat/webapps/
sleep 5
chown tomcat: /var/lib/tomcat/webapps/TestApp.war
/var/lib/tomcat/bin/startup.sh
sleep 2
chown tomcat: -R /var/lib/tomcat/webapps/TestApp
sleep 2
#Resolve 2 errors 
#1st error
cp /opt/gson-2_8_1.jar /var/lib/tomcat/webapps/TestApp/WEB-INF/lib
cp /opt/jstl-1_2.jar /var/lib/tomcat/webapps/TestApp/WEB-INF/lib
chown tomcat: -R /var/lib/tomcat/webapps/TestApp/WEB-INF/lib
chown tomcat: -R /var/lib/tomcat/
/var/lib/tomcat/bin/startup.sh
if [ -f "/var/lib/tomcat/bin/setenv.sh"  ]
	then rm -rf /var/lib/tomcat/bin/setenv.sh
else
chown tomcat: -R /var/lib/tomcat/logs/*
bash -c 'cat<< EOF > /var/lib/tomcat/bin/setenv.sh
export JAVA_OPTS="-Xss1024k \
-Xms256m \
-Xmx512m \
-verbose:gc \
-Xloggc:/var/lib/tomcat/logs/gc.log \
-XX:+HeapDumpOnOutOfMemoryError \
-XX:HeapDumpPath=/var/lib/tomcat/logs \
-Dcom.sun.management.jmxremote=true \
-Dcom.sun.management.jmxremote.port=12831 \
-Dcom.sun.management.jmxremote.ssl=false \
-Dcom.sun.management.jmxremote.authenticate=false \
-Djava.rmi.server.hostname=172.17.0.2"
EOF'
fi
sleep 2
sed -i '/<servlet-class>com.epam.nix.java.testapp.servlet.MemoryLeakServlet<\/servlet-class>/a<multipart-config>\n<location>\/tmp<\/location>\n<max-file-size>20848820</\max-file-size>\n<max-request-size>418018841<\/max-request-size>\n<file-size-threshold>1048576<\/file-size-threshold>\n</\multipart-config>' /var/lib/tomcat/webapps/TestApp/WEB-INF/web.xml
sleep 3
chmod +x /var/lib/tomcat/bin/setenv.sh
chown tomcat: /var/lib/tomcat/bin/setenv.sh
/var/lib/tomcat/bin/shutdown.sh
/var/lib/tomcat/bin/startup.sh

