install
helm install --set name=test-ui-1 ui ./ui

check
helm ls

output
NAME	NAMESPACE	REVISION	UPDATED                               	STATUS  	CHART   	APP VERSION
ui  	default  	1       	2021-10-08 22:31:40.53375941 +0300 MSK	deployed	ui-1.0.0	1

templating file and add values.yaml

install new version of ui (test-ui-3)
helm install test-ui-3 ./ui

get ingress list
kubectl get ingress
test-ui-2-ui   <none>   *                 80      3m54s
test-ui-3-ui   <none>   *                 80      3m17s

helm repo add mongodb https://mongodb.github.io/helm-charts
