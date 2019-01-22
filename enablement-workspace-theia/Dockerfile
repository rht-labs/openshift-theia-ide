FROM centos:centos7
# USER root

# MongoDB stuff / ansible / OC client
RUN touch 'mongodb-org-4.0.repo' && \
    echo $'[mongodb-org-4.0] \n\
name=MongoDB \n\
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.0/x86_64/ \n\
gpgcheck=1 \n\
enabled=1 \n\
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc' >  mongodb-org-4.0.repo  && \
    mv mongodb-org-4.0.repo /etc/yum.repos.d/  && \
    curl -sL https://rpm.nodesource.com/setup_8.x | bash && \
    yum install -y mongodb-org ansible zsh git curl gcc-c++ g++ automake python build-essential wget sudo nodejs java-1.8.0-openjdk-devel psmisc epel-release && \
    yum clean all

# Install jq
# http://stedolan.github.io/jq/
RUN curl -o /usr/local/bin/jq -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
  chmod +x /usr/local/bin/jq

# Set the JAVA_HOME variable to make it clear where Java is located
ENV JAVA_HOME /usr/lib/jvm/java

# Add Let's Encrypt CA to OS trsuted store
RUN curl -o /etc/pki/ca-trust/source/anchors/lets-encrypt-x3-cross-signed.crt https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem.txt && \
    update-ca-trust extract

# Install OpenShift Client
RUN curl https://mirror.openshift.com/pub/openshift-v3/clients/3.11.66/linux/oc.tar.gz | tar -C /usr/local/bin/ -xzf -

## User account
RUN useradd -ms /bin/bash -d /home/theia theia && \
  chmod g+rw /home && \
  mkdir -p /home/theia/project && \
  mkdir -p /home/theia/ide && \
  chown -R theia:theia /home/theia

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
  nvm install v10 && \
  nvm install v8 && \
  nvm install v6 && \
  nvm alias default v8  && \
  npm install -g @angular/cli yarn

# Theia IDE install stuff 
ARG GITHUB_TOKEN
ENV GITHUB_TOKEN=${GITHUB_TOKEN}
WORKDIR $HOME/ide
RUN source $HOME/.bashrc && \
#   echo '{"private":true,"dependencies":{"@theia/application-package":"next","@theia/typescript":"next","typescript":"latest","@theia/navigator":"next","@theia/terminal":"next","@theia/plugin-ext-vscode":"next","@theia/monaco":"next","@theia/editorconfig":"next","@theia/outline-view":"next","@theia/preferences":"next","@theia/messages":"next","@theia/git":"next","@theia/file-search":"next","@theia/markers":"next","@theia/preview":"next","@theia/callhierarchy":"next","@theia/merge-conflicts":"next","@theia/search-in-workspace":"next","@theia/json":"next","@theia/textmate-grammars":"next","@theia/mini-browser":"next","@theia/plugin-ext":"next", "@theia/extension-manager":"next"},"devDependencies":{"@theia/cli":"next"}}' > package.json && \
  echo '{"private":true,"dependencies":{"@theia/application-package":"0.4.0-next.f69caeba","@theia/typescript":"0.4.0-next.f69caeba","typescript":"latest","@theia/navigator":"0.4.0-next.f69caeba","@theia/terminal":"0.4.0-next.f69caeba","@theia/plugin-ext-vscode":"0.4.0-next.f69caeba","@theia/monaco":"0.4.0-next.f69caeba","@theia/editorconfig":"0.4.0-next.f69caeba","@theia/outline-view":"0.4.0-next.f69caeba","@theia/preferences":"0.4.0-next.f69caeba","@theia/messages":"0.4.0-next.f69caeba","@theia/git":"0.4.0-next.f69caeba","@theia/file-search":"0.4.0-next.f69caeba","@theia/markers":"0.4.0-next.f69caeba","@theia/preview":"0.4.0-next.f69caeba","@theia/callhierarchy":"0.4.0-next.f69caeba","@theia/merge-conflicts":"0.4.0-next.f69caeba","@theia/search-in-workspace":"0.4.0-next.f69caeba","@theia/json":"0.4.0-next.f69caeba","@theia/textmate-grammars":"0.4.0-next.f69caeba","@theia/mini-browser":"0.4.0-next.f69caeba","@theia/plugin-ext":"0.4.0-next.f69caeba", "@theia/extension-manager":"0.4.0-next.f69caeba", "@theia/yaml":"0.2.0-next.13bf0365","@theia/docker":"0.2.0-next.87a212ec"},"devDependencies":{"@theia/cli":"0.4.0-next.f69caeba"}}' > package.json && \
  npm install -g yarn && \
  yarn install --force  
RUN source $HOME/.bashrc && \
  ls -la  && \
  yarn theia build

WORKDIR /home/theia/project
# generic server ports
EXPOSE 4200 4444 8080 9000 3000 8081 8082 8083 8084 3000

ADD https://raw.githubusercontent.com/rht-labs/openshift-theia-ide/master/enablement-workspace-theia/entrypoint /home/theia
USER root
RUN chgrp -R 0 /home/theia && \
  chmod a+x /home/theia/entrypoint && \
  chmod -R g=u /home/theia && \
  chmod g=u /etc/passwd
USER 10001
ENTRYPOINT ["/home/theia/entrypoint"]
CMD source $HOME/.bashrc && cd /home/theia/ide && yarn theia start /home/project --hostname 0.0.0.0 --port 8080
