1. Create virtual machine
```bash
cd terraform
   terraform init
   terraform plan 
   terraform apply --auto-approve
```  
external_ip_address=51.250.6.171

2. create docker machine
```bash
docker-machine create monitoringHost --driver generic --generic-ip-address 51.250.6.171 --generic-ssh-user ubuntu  --generic-ssh-key ~/.ssh/appuser
```
3. connect to docker-machine
```bash
eval $(docker-machine env monitoringHost)
```
4. run prometeus in docker container
docker run --rm -p 9090:9090 -d --name prometheus  prom/prometheus 
5. connect to prometeus
http://51.250.6.171:9090/graph
![img/img.png](img.png)
6. Expose metrics prometheus_build_info
get - prometheus_build_info{branch="HEAD", goversion="go1.17.3", instance="localhost:9090", job="prometheus", revision="411021ada9ab41095923b8d2df9365b632fd40c3", version="2.31.1"}
7. see prometheus metrics
http://51.250.6.171:9090/metrics
```text
# HELP go_gc_duration_seconds A summary of the pause duration of garbage collection cycles.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 6.4253e-05
go_gc_duration_seconds{quantile="0.25"} 8.1281e-05
....
```
8.stop container
```bash
docker stop prometheus
```