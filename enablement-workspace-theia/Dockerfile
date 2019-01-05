FROM centos:centos7
# USER root

# MongoDB stuff
RUN touch 'mongodb-org-4.0.repo' && \
    echo $'[mongodb-org-4.0] \n\
name=MongoDB \n\
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.0/x86_64/ \n\
gpgcheck=1 \n\
enabled=1 \n\
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc' >  mongodb-org-4.0.repo  && \
    mv mongodb-org-4.0.repo /etc/yum.repos.d/  && \
    yum install -y mongodb-org ansible zsh git curl gcc-c++ g++ automake python build-essential wget sudo

## User account
RUN useradd -ms /bin/bash -d /home/theia theia

RUN chmod g+rw /home && \
  mkdir -p /home/project && \
  chown -R theia:theia /home/theia && \
  chown -R theia:theia /home/project

ENV HOME /home/theia
USER theia
# NodeJS Stuff
RUN unset NPM_CONFIG_PREFIX && \
    git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh && \
    cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc && \
    echo 'unset NPM_CONFIG_PREFIX' >> $HOME/.zshrc && \
    echo 'unset NPM_CONFIG_PREFIX' >> $HOME/.bashrc && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | sh  && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.zshrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> $HOME/.zshrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> $HOME/.bashrc && \
    source $HOME/.bashrc && \
    nvm install v8 && \
    nvm install v6 && \
    nvm alias default v8  && \
    npm install -g @angular/cli yarn

# OC client
WORKDIR /home/theia

ADD https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz .
USER root

RUN tar xvf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    mv openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin && \
    rm -rf openshift-origin*

USER theia
ENV GITHUB_TOKEN "THIS_HAS_TO_BE_SET"

# IDEIA 
RUN source $HOME/.bashrc && \
    echo '{"private":true,"dependencies":{"typescript":"latest", "@theia/plugin-ext":"next", "@theia/extension-manager":"next", "@theia/plugin-ext-vscode":"next","@theia/monaco":"next","@theia/editorconfig":"next",   "@theia/typescript":"next","@theia/navigator":"next","@theia/terminal":"next","@theia/outline-view":"next","@theia/preferences":"next","@theia/messages":"next","@theia/git":"next","@theia/file-search":"next","@theia/markers":"next","@theia/preview":"next","@theia/callhierarchy":"next","@theia/merge-conflicts":"next","@theia/search-in-workspace":"next","@theia/json":"next","@theia/textmate-grammars":"next","@theia/mini-browser":"next"},"devDependencies":{"@theia/cli":"next"}}' > package.json && \
    npm install -g yarn && \
    yarn install
RUN source $HOME/.bashrc && \
    ls -la  && \
    yarn theia build

# generic server ports
EXPOSE 4200 4444 8080 9000 3000 8081 8082 8083 8084 3000

CMD source $HOME/.bashrc && yarn theia start /home/project --hostname 0.0.0.0 --port 8080