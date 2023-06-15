RED='\033[0;31m'
GREEN='\033[0;32m'
WHITE='\033[0m'
L_BLUE='\033[1;34m'
echo -e  "$L_BLUE - Giving right for docker $WHITE"
sudo chmod 777 /var/run/docker.sock
echo -e  "$L_BLUE - Deleting existing minikube cluster... $WHITE"
minikube delete 2> /dev/null
sleep 3
echo -e  "$GREEN - Deleted ! $WHITE"

echo -e  "$L_BLUE - Launch minikube cluster... $WHITE"
minikube start --vm-driver=docker
sleep 3
echo -e  "$GREEN - Minikube is running ! $WHITE"

eval $(minikube docker-env)
minikube addons enable metrics-server
minikube addons enable dashboard
echo -e  "$L_BLUE - Config metallb... $WHITE"
kubectl get configmap kube-proxy -n kube-system -o yaml | sed -e "s/strictARP: false/strictARP: true/" | kubectl diff -f - -n kube-system
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl apply -f srcs/metallb/config_metallb.yaml > /dev/null
minikube addons enable metallb
KUBE_IP="$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)"
echo -e  "$L_BLUE KUBE_IP = $KUBE_IP $WHITE"
sed -i -e "s/setminikubeip/$KUBE_IP/g" ./srcs/metallb/config_metallb.yaml
kubectl apply -f ./srcs/metallb/
sed -i -e "s/$KUBE_IP/setminikubeip/g" ./srcs/metallb/config_metallb.yaml
echo -e  "$GREEN - metallb ready ! $WHITE"

echo -e  "$L_BLUE /////////////////Docker build/////////////////$WHITE"
echo -e  "$L_BLUE - Build influxdb image... $WHITE"
docker build -t influxdb srcs/influxdb
echo -e  "$GREEN - influxdb done ! $WHITE"
echo -e  "$L_BLUE - Build mysql image... $WHITE"
docker build -t mysql --build-arg minikube_ip=$KUBE_IP srcs/mysql
echo -e  "$GREEN - mysql done ! $WHITE"
echo -e  "$L_BLUE - Build nginx image... $WHITE"
docker build -t nginx srcs/nginx
echo -e  "$GREEN - nginx done ! $WHITE"
echo -e  "$L_BLUE - Build wordpress image... $WHITE"
docker build -t wordpress srcs/wordpress
echo -e  "$GREEN - wordpress done ! $WHITE"
echo -e  "$L_BLUE - Build phpmyadmin image... $WHITE"
docker build -t phpmyadmin srcs/phpmyadmin
echo -e  "$GREEN - phpmyadmin done ! $WHITE"
echo -e  "$L_BLUE - Build ftps image... $WHITE"
docker build -t ftps --build-arg minikube_ip=$KUBE_IP srcs/ftps
echo -e  "$GREEN - ftps done ! $WHITE"
echo -e  "$L_BLUE - Build grafana image... $WHITE"
docker build -t grafana srcs/grafana
echo -e  "$GREEN - grafana done ! $WHITE"
echo -e  "$GREEN /////////////////Docker build done !/////////////////$WHITE"

echo -e  "$L_BLUE /////////////////Deployment/////////////////$WHITE"
echo -e  "$L_BLUE - Deploy influxdb... $WHITE"
kubectl create -f  srcs/influxdb.yaml
echo -e  "$GREEN - Deployed ! $WHITE"
echo -e  "$L_BLUE - Deploy mysql... $WHITE"
kubectl create -f  srcs/mysql.yaml
echo -e  "$L_BLUE - Waiting for initialisation... $WHITE"
sleep 30
echo -e  "$GREEN - Deployed ! $WHITE"
echo -e  "$L_BLUE - Deploy nginx... $WHITE"
kubectl create -f  srcs/nginx.yaml
echo -e  "$GREEN - Deployed ! $WHITE"
echo -e  "$L_BLUE - Deploy wordpress... $WHITE"
kubectl create -f  srcs/wordpress.yaml
echo -e  "$GREEN - Deployed ! $WHITE"
echo -e  "$L_BLUE - Deploy phpmyadmin... $WHITE"
kubectl create -f  srcs/phpmyadmin.yaml
echo -e  "$GREEN - Deployed ! $WHITE"
echo -e  "$L_BLUE - Deploy ftps... $WHITE"
kubectl create -f  srcs/ftps.yaml
echo -e  "$GREEN - Deployed ! $WHITE"
echo -e  "$L_BLUE - Deploy grafana... $WHITE"
kubectl create -f  srcs/grafana.yaml
echo -e  "$GREEN - Deployed ! $WHITE"
echo -e  "$GREEN /////////////////Deployment done !/////////////////$WHITE"
minikube dashboard