1. Получить иинформацию о кластере в облаке и записать ее в ~/.kube/config
yc managed-kubernetes cluster get-credentials k8s-stage --external
2. Проверить что информация записалась
kubectl config current-context
3. Создать dev namespace
kubectl apply -f ./kubernetes/reddit/dev-namespace.yml
4. Задеплоить приложения
kubectl apply -f ./kubernetes/reddit/ -n dev
5. Получить ip кластера
kubectl get nodes -o wide
6. Получить порт приложения ui
kubectl describe service ui -n dev | grep NodePort
