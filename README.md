## Theia IDE on OpenShift

Beefy Image containing tooling used by the Red Hat Open Innovation Labs Enablement session.
* Ansible
* OpenShift CLI - v3.11
* NodeJS (nvm install) - v6, v8, v10
* Python
* Angular CLI
* jq

## Theia Extensions

Check all available Theia extensions [here](https://www.npmjs.com/search?q=keywords:theia-extension).

To deploy VSCode extensions, you can use the command *"Deploy plugin by id"* from the command palette. When asked for a parameter, enter the following: *"vscode:extension/"*. " stands for the "Unique Identifier" from the extension homepage in the VS Code Marketplace.


## Build and deploy
1. `oc login`.
2. `./deploy-theia.sh <NAMESPACE> <GITHUB_TOKEN>`.
   
   Two params are required to run this script; the first is the namespace to create an put the IDE and the second is your github token for building the theia image (required for npm dependencies resolution).
3. Open the url in your broswer and login using OpenShift authentication.
