## Connecting to API via kubectl port forwarding

Once you're in the k8s dev-vegbank context, you can find the name of the API pod via the following command: 


` kubectl get pods `

The API pod is the one with the werid alphanumeric name. After that, all you need is this command: 

` kubectl port-forward <API pod name> <desired port on your machine>:80 `

Then you can access the API on localhost via the port you specified. 