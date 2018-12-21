FROM eclipse/che-dev:nightly
# USER root

# MongoDB stuff
RUN touch 'mongodb-org-4.0.repo' && \
    echo $'[mongodb-org-4.0] \n\
name=MongoDB \n\
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.0/x86_64/ \n\
gpgcheck=1 \n\
enabled=1 \n\
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc' >  mongodb-org-4.0.repo  && \
    sudo mv mongodb-org-4.0.repo /etc/yum.repos.d/  && \
    sudo yum install -y mongodb-org ansible zsh

# NodeJS Stuff
RUN unset NPM_CONFIG_PREFIX && \
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
    echo 'unset NPM_CONFIG_PREFIX' >> /home/user/.zshrc && \
    echo 'unset NPM_CONFIG_PREFIX' >> /home/user/.bashrc && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | sh  && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> /home/user/.zshrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> /home/user/.zshrc && \
    source /home/user/.bashrc && \
    nvm install v10 && \
    nvm install v8 && \
    nvm install v6 && \
    nvm alias default v10  && \
    echo 'zsh' >> /home/user/.bashrc && \
    npm install -g @angular/cli 

# OC client
ADD https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz .
RUN sudo tar xvf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    sudo mv openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin && \
    sudo rm -rf openshift-origin*

WORKDIR /projects

# generic server ports
EXPOSE 4200 4444 8080 9000 3000 8081 8082 8083 8084

# Java for e2e testing?