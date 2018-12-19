FROM eclipse/che-dev:nightly
# USER root

# NodeJS Stuff
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | sh  && \
    source /home/user/.bash_profile && \
    unset NPM_CONFIG_PREFIX && \
    nvm install v10 && \
    nvm install v8 && \
    nvm install v6 && \
    nvm alias default v10  && \
    npm install -g @angular/cli


# MongoDB stuff
RUN touch 'mongodb-org-4.0.repo' && \
    echo $'[mongodb-org-4.0] \n\
name=MongoDB \n\
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.0/x86_64/ \n\
gpgcheck=1 \n\
enabled=1 \n\
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc' >  mongodb-org-4.0.repo  && \
    sudo mv mongodb-org-4.0.repo /etc/yum.repos.d/  && \
    sudo yum install -y mongodb-org ansible

# Ansible / OC clients
ADD https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz .
RUN sudo tar xvf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    sudo mv openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin


WORKDIR /projects

# generic server ports
EXPOSE 4200 4444 8080 9000 3000 8081 8082 8083 8084

# Java for e2e testing?