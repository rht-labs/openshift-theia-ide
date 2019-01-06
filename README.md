## Theia IDE on OpenShift

Beefy Image containing tooling used by the Red Hat Open Innovation Labs Enablement session. 
* Ansible
* OpenShift CLI - v3.11
* NodeJS (nvm install) - v6, v8, v10
* Python
* Angular CLI


## Build and deploy
1. `oc login`.
2. Update the `enablement-workspace-theia/Dockerfile`'s `ENV GITHUB_TOKEN xxx` to be able to pull from Microsoft repos (needed to build the Theia IDE).
3. `./deploy-theia.sh`. Two params can be passed to this script; the first is the namespace to create an put the IDE and the second is the .htaccess password to be used for securing the IDE. Defaults are `enablement-workspace` and `Thisismypassw0rd`.
4. Open the url in your broswer and login.