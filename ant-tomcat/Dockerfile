# Centos based container with java and tomcat
From centos:6
MAINTAINER 7rack

# Install prepare infrastructure

RUN yum -y update && \
	yum -y install openssh-server wget tar python-setuptools && \
	easy_install supervisor

# Prepare environment

ENV TZ Asia/Shanghai
ENV JAVA_HOME /opt/java
ENV CATALINA_HOME /opt/tomcat
ENV ANT_HOME /opt/ant
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$ANT_HOME/bin

# Install Oracle Java7 \ Tomcat7 \ ANT

COPY jdk-7u45-linux-x64.tar.gz /home/jdk-7u45-linux-x64.tar.gz
COPY apache-tomcat-7.0.65.tar.gz /home/apache-tomcat-7.0.65.tar.gz
COPY apache-ant-1.9.6-bin.tar.gz /home/apache-ant-1.9.6-bin.tar.gz
COPY supervisord.conf /etc/supervisord.conf

#RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
#	http://download.oracle.com/otn/java/jdk/7u45-b18/jdk-7u45-linux-x64.tar.gz && \
RUN cd /home && \
        tar -xzf jdk-7u45-linux-x64.tar.gz && \
        rm jdk-7u45-linux-x64.tar.gz && \
        mv jdk* ${JAVA_HOME}

#RUN wget http://mirrors.hust.edu.cn/apache/ant/binaries/apache-ant-1.9.6-bin.tar.gz && \
# add svnant and package by yourself
RUN cd /home && \
	tar -xzf apache-ant-1.9.6-bin.tar.gz && \
	rm apache-ant-1.9.6-bin.tar.gz && \
	mv apache-ant* ${ANT_HOME} 
	
#RUN wget http://mirrors.hust.edu.cn/apache/tomcat/tomcat-7/v7.0.65/bin/apache-tomcat-7.0.65.tar.gz && \
RUN cd /home && \
        tar -xzf apache-tomcat-7.0.65.tar.gz && \
        rm apache-tomcat*.tar.gz && \
        mv apache-tomcat* ${CATALINA_HOME}
RUN chmod +x ${CATALINA_HOME}/bin/*.sh


# Create tomcat admin user
#ADD create_admin_user.sh $CATALINA_HOME/scripts/create_admin_user.sh
#ADD tomcat.sh $CATALINA_HOME/scripts/tomcat.sh
#RUN chmod +x $CATALINA_HOME/scripts/*.sh

RUN echo "JAVA_HOME=${JAVA_HOME}" >> /etc/profile && \
	echo "JRE_HOME=${JAVA_HOME}/jre" >> /etc/profile && \
	echo "ANT_HOME=${ANT_HOME}" >> /etc/profile && \
	echo "PATH=${PATH}" >> /etc/profile && \
	echo "export JAVA_HOME JRE_HOME PATH " >> /etc/profile


# Create dev user
RUN useradd -c "Tomcat user" devops && \
	mkdir -p /var/run/sshd &&  \
	mkdir -p /var/log/supervisor && \
        chown -R devops. ${CATALINA_HOME} && \
	chown -R root. ${JAVA_HOME} ${ANT_HOME}


# add deploy scripts
ADD deploy.sh /home/devops/
# add ant config file,and project config file
ADD config.tgz /home/devops/

RUN chmod +x /home/devops/deploy.sh  && \
	mkdir -p /home/devops/workspace/websource && \
	chown -R devops. /home/devops/* 
	
RUN echo 'devops:password' | chpasswd
RUN echo 'root:password' | chpasswd

RUN rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key && \
	ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
	ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
	sed -i \
	-e 's/^UsePAM yes/#UsePAM yes/g' \
	-e 's/^#UsePAM no/UsePAM no/g' \
	-e 's/^#PermitRootLogin yes/PermitRootLogin no/g' \
	-e 's/^#UseDNS yes/UseDNS no/g' \
	/etc/ssh/sshd_config	


#WORKDIR /opt/tomcat

EXPOSE 8080 22 

CMD ["/usr/bin/supervisord"]
