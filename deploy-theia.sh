

# 0. Create project
NAMESPACE=${1:-enablement-workspace}
echo "using namesapce ${NAMESPACE}"
oc new-project ${NAMESPACE}

# 1. Build and Deploy the IDE build etc
oc new-app $(pwd)/enablement-workspace-theia  --name=theia --strategy=docker                 
oc start-build theia --from-dir=$(pwd)/enablement-workspace-theia
# oc expose svc/theia
PORT_LIST=$(oc get svc/theia -o json --no-headers  | jq -r '.spec.ports[] | "\(.port)"')
for port in $PORT_LIST; do
    # if port 8080 probs shouldn't open it....
    if [ "$port" -ne "8080" ]; then
      echo "Exposing apps for ports ${port}"
      oc expose service theia --name=ide-${port} --port=${port}
    fi;
done;

# 2. Deploy the IDE build etc
oc new-app registry.access.redhat.com/rhscl/nginx-112-rhel7~$(pwd)/nginx-reverse --name=nginxbase
oc start-build nginxbase --from-dir=$(pwd)/nginx-reverse
oc delete dc/nginxbase
oc delete svc/nginxbase

oc new-app --strategy=docker nginxbase~$(pwd)/nginx-reverse --name=myreverseproxy  --allow-missing-imagestream-tags
htpasswd -cb nginx-reverse/htpasswd developer this-is-a-test
oc start-build myreverseproxy --from-dir=$(pwd)/nginx-reverse
oc expose svc/myreverseproxy
oc create route edge ide --service=myreverseproxy
