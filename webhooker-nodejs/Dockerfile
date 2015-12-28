# Centos based container with node js
From centos:6
MAINTAINER 7rack

# Install prepare infrastructure

RUN yum  -y update && \
	yum -y install openssh-server tar python-setuptools git
RUN easy_install supervisor

# Create dev user

RUN useradd -c "dev user" devops && \
	mkdir -p /var/run/sshd &&  \
	mkdir -p /var/log/supervisor && \
	mkdir /home/devops/.ssh

RUN echo 'devops:password' | chpasswd
RUN echo 'root:password' | chpasswd

# Prepare environment

ENV TZ Asia/Shanghai

# add personal repo SSH keys
ADD devops.pem /home/devops/.ssh/id_rsa
RUN chmod 700 /home/devops/.ssh && \
	chmod 600 /home/devops/.ssh/id_rsa && \
	echo -e "Host 10.0.0.4\n\tStrictHostKeyChecking no\n" >> /home/devops/.ssh/config

RUN rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key && \
	ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
	ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
	sed -i \
	-e 's/^UsePAM yes/#UsePAM yes/g' \
	-e 's/^#UsePAM no/UsePAM no/g' \
	-e 's/^#PermitRootLogin yes/PermitRootLogin no/g' \
	-e 's/^#UseDNS yes/UseDNS no/g' \
	/etc/ssh/sshd_config

# Install node js
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 4.2.3

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc

RUN npm install -g cnpm --registry=http://registry.npm.taobao.org
RUN cnpm install -g pm2 webpack orangebox

ENV NODE_PATH /usr/local/lib/node_modules

COPY supervisord.conf /etc/supervisord.conf
ADD deploy.sh /home/devops/
ADD deploy.js /home/devops/

RUN chmod +x /home/devops/deploy.sh  && \
	cd /home/devops && \
	chown -R devops. . && \
        echo "NODE_PATH=${NODE_PATH}" >> /etc/profile && \
        echo "export NODE_PATH " >> /etc/profile
	
EXPOSE 3000 4400 22 

CMD ["/usr/bin/supervisord"]
