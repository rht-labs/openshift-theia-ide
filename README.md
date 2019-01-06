## Theia IDE on OpenShift

Beefy Image containing tooling used by the Red Hat Open Innovation Labs Enablement session. 
* Ansible
* OpenShift CLI - v3.11
* NodeJS (nvm install) - v6, v8, v10
* Python
* Angular CLI


## Build and deploy
1. `oc login`.
2. `./deploy-theia.sh`. Two params can be passed to this script; the first is the namespace to create an put the IDE and the second is the .htaccess password to be used for securing the IDE. Defaults are `enablement-workspace` and `Thisismypassw0rd`.
3. Open the url in your broswer and login.