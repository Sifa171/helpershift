# analyze-adv
quick and dirty anylze/debug container with some network tools, based on rhel

## Installation
Use the buildconfig and deploymentconfig. You need to create an ImageStream
```
oc create is analyze-adv
```
and change the address or ip in the deploymentconfig
