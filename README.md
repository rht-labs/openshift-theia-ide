## Theia IDE on OpenShift

Beefy Image containing tooling used by the Red Hat Open Innovation Labs Enablement session. 
* Ansible
* OpenShift CLI - v3.11
* NodeJS (nvm install) - v6, v8, v10
* Python
* Angular CLI


## Build and deploy
1. `oc login`.
2. `./deploy-theia.sh <NAMESPACE> <GITHUB_TOKEN>`. Two params are required to run this script; the first is the namespace to create an put the IDE and the second is your github token for building the theia image (required for npm dependencies resolution).
3. Open the url in your broswer and login using OpenShift authentication.