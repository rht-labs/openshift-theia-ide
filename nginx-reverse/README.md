### nginx reverse example

nginx reverse proxy with basic auth

See:
- http://keyangxiang.com/2018/06/01/Openshift/how-to-run-nginx-as-reverse-proxy/
- https://www.tecmint.com/setup-nginx-basic-http-authentication/

```
-- build image
oc new-project nginx-reverse
oc new-app registry.access.redhat.com/rhscl/nginx-112-rhel7~/home/mike/git/nginx-reverse --name=nginxbase
oc start-build nginxbase --from-dir=/home/mike/git/nginx-reverse

-- delete
oc delete bc/nginxbase
oc delete dc/nginxbase
oc delete svc/nginxbase
oc delete route/nginxbase

cd /home/mike/git/nginx-reverse/docker

cat << 'EOF' > nginx-proxy.conf
location /pfly {
  proxy_set_header  Host $host;
  proxy_set_header  X-Real-IP $remote_addr;
  proxy_set_header  X-Forwarded-Proto https;
  proxy_set_header  X-Forwarded-For $remote_addr;
  proxy_set_header  X-Forwarded-Host $remote_addr;
  proxy_pass http://pfly:8080;
}
location /node_modules {
  proxy_set_header  Host $host;
  proxy_set_header  X-Real-IP $remote_addr;
  proxy_set_header  X-Forwarded-Proto https;
  proxy_set_header  X-Forwarded-For $remote_addr;
  proxy_set_header  X-Forwarded-Host $remote_addr;
  proxy_pass http://pfly:8080;
}
EOF

-- modify nginx.conf

    auth_basic           "Restricted Access!";
    auth_basic_user_file /opt/app-root/etc/nginx.default.d/.htpasswd;

htpasswd -cb htpasswd developer developer

cat << EOF > Dockerfile
FROM nginxbase:latest
ADD nginx-proxy.conf /opt/app-root/etc/nginx.default.d/nginx-proxy.conf
ADD htpasswd /opt/app-root/etc/nginx.default.d/.htpasswd
ADD nginx.conf /etc/opt/rh/rh-nginx112/nginx/nginx.conf
EOF

-- create reverse proxy
oc new-app --strategy=docker nginxbase~/home/mike/git/nginx-reverse/docker --name=myreverseproxy
oc start-build myreverseproxy --from-dir=/home/mike/git/nginx-reverse/docker
oc expose svc/myreverseproxy

-- add app to test proxy against

cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" type="text/css" href="/node_modules/patternfly/dist/css/patternfly.css">
  <link rel="stylesheet" type="text/css" href="/node_modules/patternfly/dist/css/patternfly-additions.css">
</head>
<body>
  <div class="container">
    <!-- Just enjoy various PatternFly components -->
    <div class="alert alert-success">
      <span class="pficon pficon-ok"></span>
      <strong>Great job!</strong> This Patternfly is really working out <a href="#" class="alert-link">great for us</a>.
    </div>
  </div>
  <script src="/node_modules/jquery/dist/jquery.js"></script>
  <script src="/node_modules/bootstrap/dist/js/bootstrap.js"></script>
</body>
</html>
EOF

cat <<EOF > server.js
const port = 8080
const express = require('express')
const path = require('path')
const app = express()
app.use(
  express.static(__dirname)
);
app.get('*/', function(req, res) {
  console.log('OK')
  res.sendFile(__dirname + '/index.html');
});
app.listen(port)
EOF

npm init -f
npm i express patternfly --save

--
oc new-build --binary --name=pfly -i nodejs
oc start-build pfly --from-dir=. --follow
oc new-app pfly
oc expose svc pfly

-- test
http://myreverseproxy-nginx-reverse.apps.melbourne-930a.openshiftworkshop.com/pfly/

# use developer/developer to login
# should see patternfly
```