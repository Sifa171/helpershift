# Gitlab runner
This example shows how to setup a simple Gitlab runner in your OpenShift to use the CI features of Gitlab. You can use this runner with any recent version of Gitlab. TIf you don't have a Gitlab server there is also a quick and dirty example in this repository to setup a Gitlab server.

## Setup
To setup the Runner (with caching!) thewre is a good guide with template here: https://github.com/oprudkyi/openshift-templates/tree/master/gitlab-runner

To seperate the runner from anything else on your cluster you should create a new project for your runners.
Example:
```
oc new-project gitlab-runner --description='Project to execute Gitlab Runners' --display-name='Gitlab Runner'
```
Next you need to create ServiceAccounts inside the project and grant once again anyuid SCCs: (You need clsuter-admin rights to do this)
```
oc project gitlab-runner
oc create sa sa-gitlab-runner
oc create sa sa-minio
oc adm policy add-scc-to-user anyuid -z sa-gitlab-runner
oc adm policy add-scc-to-user anyuid -z sa-minio
```
Now you can use the tempalte to create a gitlab runner. You can create the template inside the project and use the Webconsole to create the runner. But you can also use the cmd ;)
This downloads the template and shows all available parameters:
```
wget https://gitlab.com/oprudkyi/openshift-templates/raw/master/gitlab-runner/gitlab-runner.yaml
oc process -f gitlab-runner.yaml  --parameters=true
```

If you have the token you can instanciate a basic runner inside your OpenShift project with the following commands:
```
oc process -f gitlab-runner.yaml \
    -p GITLAB_RUNNER_CI_URL=https://gitlab.example.com/ \
    -p GITLAB_RUNNER_TOKEN=YourTokenHere \
    -p GITLAB_RUNNER_NAMESPACE=gitlab-runner | oc create -f -
```
**INFO:** You need to run gitlab-runner register inside the runner to get the token. Not sure why, but it is very impractical. My first setup was with a wrong token to get the container running and run gitlab-runner register to get a token. After that i put the token inside the config.
You can manage all runners here https://gitlab.example.com/admin/runners/

If you want your minio cache to persist you should swap the empty dir for a PersistentVolumeClaim. If you are in a cloud platform with a S3 compatible storage you can use that one instead. 
If your minio cache restart frequently you should check the resource limtis, liveness probe and readiness probe. I had to change the probe from /minio/login to /minio/health/live to get it working

## Advanced
This section describes ways for more advanced builds
### kaniko
You can build images inside the gitlab runner with kaniko. 
See: https://docs.gitlab.com/ee/ci/docker/using_kaniko.html
This example creates another Gitlab Runner for kaniko. It would be possible to use kaniko inside the simple Runenr we just created, but it is much nicer to create a special kaniko runner which is already configured with credentials for the image registry to push images.
The ConfigMap ```cm.docker-config.yaml``` is an example with credentials for two registries. This should contain the credentials for registries you want pull images from or push images to. You can use docker login on your machine to create such a config. After the login it is normally stored in ~/.docker/config.json
```
oc create -f cm.docker-config.yaml
```

TODO: template for gitlab kaniko runner!!

More information on kubernetes runner configuration: https://docs.gitlab.com/runner/executors/kubernetes.html and https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runners-kubernetes-section
