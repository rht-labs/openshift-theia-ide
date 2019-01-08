

# 0. Create project
NAMESPACE=${1:-enablement-workspace}
PASSWORD=${2:-Thisismypassw0rd}
echo "using namesapce ${NAMESPACE}"
oc new-project ${NAMESPACE}

# 1. Build and Deploy the IDE build etc
oc new-app $(pwd)/enablement-workspace-theia  --name=theia --strategy=docker
oc patch dc/theia -p '{"spec":{"strategy":{"type":"Recreate"}}}'                
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

# Persistent Volume for Workspace
oc create -f - <<EOF
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: theia-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
EOF
oc set volume dc/theia --add --overwrite -t persistentVolumeClaim --claim-name=theia-data --name=theia-data --mount-path=/home/project

# 2. Deploy the IDE build etc
oc new-app registry.access.redhat.com/rhscl/nginx-112-rhel7~$(pwd)/nginx-reverse --name=nginxbase
oc start-build nginxbase --from-dir=$(pwd)/nginx-reverse
oc delete dc/nginxbase
oc delete svc/nginxbase

oc new-app --strategy=docker nginxbase~$(pwd)/nginx-reverse --name=myreverseproxy  --allow-missing-imagestream-tags
htpasswd -cb nginx-reverse/htpasswd developer ${PASSWORD}
oc create secret generic htpasswd-secret --from-file=nginx-reverse/htpasswd
oc set volume --name=htpasswd-secret dc/myreverseproxy --add --overwrite -m /opt/app-root/etc/nginx.default.d/htpasswd -t secret --secret-name htpasswd-secret
oc start-build myreverseproxy --from-dir=$(pwd)/nginx-reverse
oc expose svc/myreverseproxy
oc create route edge ide --service=myreverseproxy
