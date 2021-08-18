# panthrashkov_microservices
panthrashkov microservices repository
1. create vm
   yc compute instance create \
     --name docker-host \
     --zone ru-central1-a \
     --network-interface subnet-name=ru-central1-a-reddit-app-ru-central1-a,nat-ip-version=ipv4 \
     --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15 \
     --ssh-key ~/.ssh/appuser.pub
2. create docker-machine
   docker-machine create \
     --driver generic \
     --generic-ip-address=130.193.50.40 \
     --generic-ssh-user yc-user \
     --generic-ssh-key ~/.ssh/appuser \
     docker-host

3. connect to docker-machine
   eval $(docker-machine env docker-host)

4. Understand docker network
use joffotron/docker-net-tools image
5. run  docker run -ti --rm --network none joffotron/docker-net-tools -c ifconfig
output only loopback
lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

6. run docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig
use network host
output
docker0   Link encap:Ethernet  HWaddr 02:42:46:37:CA:E2
          inet addr:172.17.0.1  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

eth0      Link encap:Ethernet  HWaddr D0:0D:1D:84:A9:E4
          inet addr:10.128.0.24  Bcast:10.128.0.255  Mask:255.255.255.0
          inet6 addr: fe80::d20d:1dff:fe84:a9e4%32702/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:42678 errors:0 dropped:0 overruns:0 frame:0
          TX packets:33625 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:120658507 (115.0 MiB)  TX bytes:2890737 (2.7 MiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1%32702/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:282 errors:0 dropped:0 overruns:0 frame:0
          TX packets:282 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:25622 (25.0 KiB)  TX bytes:25622 (25.0 KiB)

7. connect docker-machine ssh docker-host
sudo apt install net-tools
check ifconfig
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:46:37:ca:e2  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.128.0.24  netmask 255.255.255.0  broadcast 10.128.0.255
        inet6 fe80::d20d:1dff:fe84:a9e4  prefixlen 64  scopeid 0x20<link>
        ether d0:0d:1d:84:a9:e4  txqueuelen 1000  (Ethernet)
        RX packets 44453  bytes 121106282 (121.1 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 35125  bytes 3165416 (3.1 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 289  bytes 26224 (26.2 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 289  bytes 26224 (26.2 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

8. output 6 and 7 the same

9. run two four times
docker run --network host -d nginx
10. run docker ps
a6874317a1fb   nginx     "/docker-entrypoint.…"   About a minute ago   Up About a minute             pedantic_visvesvaraya
only one running container
answer limitation https://docs.docker.com/network/host/  -
This creates some extra limitations. For instance, if a service container binds to port 80, only one service container can run on a given swarm node.
11. kill running containers
docker kill $(docker ps -q)
12. On docker host run
sudo ln -s /var/run/docker/netns /var/run/netns
now can use
sudo ip netns
output
default
13. run docker run --network none -d nginx
and then sudo ip netns
output
1f8e531a99de
default
14. run docker run --network host -d nginx
    and then sudo ip netns
    output
    default
15. Create network with bridge driver
docker network create reddit --driver bridge
run containers
docker run -d --network=reddit mongo:latest
docker run -d --network=reddit panthrashkov/post:1.0
docker run -d --network=reddit panthrashkov/comment:1.0
docker run -d --network=reddit -p 9292:9292 panthrashkov/ui:1.0

16. open http://178.154.220.242:9292/
get error Can't show blog posts, some problems with the post service. Refresh?
17. set network alias to microservices
docker kill $(docker ps -q)

docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post panthrashkov/post:1.0
docker run -d --network=reddit --network-alias=comment  panthrashkov/comment:1.0
docker run -d --network=reddit -p 9292:9292 panthrashkov/ui:1.0
18. open http://178.154.220.242:9292/ - OK
19. Try create two bridge networks
stop containers
docker kill $(docker ps -q)
20. create first network
docker network create back_net --subnet=10.0.2.0/24
and second
docker network create front_net --subnet=10.0.1.0/24
21. run containers
docker run -d --network=front_net -p 9292:9292 --name ui  panthrashkov/ui:1.0
docker run -d --network=back_net --name comment  panthrashkov/comment:1.0
docker run -d --network=back_net --name post  panthrashkov/post:1.0
docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest

22. open http://178.154.220.242:9292/
    get error Can't show blog posts, some problems with the post service. Refresh?

23. need connect containers post and comment to both network
docker network connect front_net post
docker network connect front_net comment

24. open http://178.154.220.242:9292/ - OK
25. connect to docker host
docker-machine ssh docker-host
and install
sudo apt-get update && sudo apt-get install bridge-utils
run
docker network ls
f760326cd4a7   back_net    bridge    local
77b0a5b81592   bridge      bridge    local
69667df48dca   front_net   bridge    local
988de0f31b36   host        host      local
884d2a6e7868   none        null      local
f4410e43c4f6   reddit      bridge    local
run
ifconfig | grep br
and then
brctl show br-69667df48dca
output
br-69667df48dca		8000.0242041837f4	no		veth150b5ed
							veth4aaac14
							veth8eec3ac
run
sudo iptables -nL -t nat
output
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
MASQUERADE  all  --  10.0.1.0/24          0.0.0.0/0
MASQUERADE  all  --  10.0.2.0/24          0.0.0.0/0
MASQUERADE  all  --  172.18.0.0/16        0.0.0.0/0
MASQUERADE  all  --  172.17.0.0/16        0.0.0.0/0
MASQUERADE  tcp  --  10.0.1.2             10.0.1.2             tcp dpt:9292

run
ps ax | grep docker-proxy
output
17232 ?        Sl     0:00 /usr/bin/docker-proxy -proto tcp -host-ip 0.0.0.0 -host-port 9292 -container-ip 10.0.1.2 -container-port 9292
17238 ?        Sl     0:00 /usr/bin/docker-proxy -proto tcp -host-ip :: -host-port 9292 -container-ip 10.0.1.2 -container-port 9292
24813 pts/0    S+     0:00 grep --color=auto docker-proxy

26. Docker-compose
create docker-compose.yml
27. run docker compose
docker-compose up -d
output
Creating src_comment_1 ... done
Creating src_post_1    ... done
Creating src_post_db_1 ... done
Creating src_ui_1      ... done
28. docker-compose ps
        Name                  Command             State                    Ports
    ----------------------------------------------------------------------------------------------
    src_comment_1   puma                          Up
    src_post_1      python3 post_app.py           Up
    src_post_db_1   docker-entrypoint.sh mongod   Up      27017/tcp
    src_ui_1        puma                          Up      0.0.0.0:9292->9292/tcp,:::9292->9292/tcp
29. http://130.193.50.40:9292/ - ok
30. change docker-compose
move environment variable to .env file
use multiple networks
rerun
docker-compose up -d
31. http://130.193.50.40:9292/ - ok
32. How to fix docker compose base name
https://stackoverflow.com/questions/32100820/how-to-fix-basename-of-containers-when-using-docker-compose/32112835
use
export COMPOSE_PROJECT_NAME=foo
docker-compose -p foo up


