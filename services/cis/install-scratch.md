# cis scratch

kubectl create secret generic bigip-login -n kube-system --from-literal=username=admin --from-literal=password=<SOMEPASSWORD>
kubectl create serviceaccount bigip-ctlr -n kube-system
kubectl apply -f https://raw.githubusercontent.com/F5Networks/k8s-bigip-ctlr/master/docs/config_examples/rbac/clusterrole.yaml
kubectl apply -f https://raw.githubusercontent.com/F5Networks/k8s-bigip-ctlr/master/docs/config_examples/customResourceDefinitions/customresourcedefinitions.yaml