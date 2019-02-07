# Gitlab omnibus all-in-one container
These objects help to deploy the gitlab omnibus docker container in OpenShift. More information about the container can be found here: https://docs.gitlab.com/omnibus/docker/

## Warning: this is a quick and dirty way to get gitlab running
This is an all in one container with over 60 processes inside it. (Even postgres and redis all in one container. Container, not Pod....)
This is so far away from any best practices for containers that I'm ashamed to use it - but its quick.
If you consider to use gitlab in a somewhat serious way there are tutorial from gitlab. They are also providing helm charts. But at the time of writing these were still work in progress and pretty sketchy.

Another way that looks very promising could be to use these images: https://github.com/sameersbn/docker-gitlab
Components like redis and postgres are in a seperate container and you can also use external services. There is also a lot of good documentation and environment variables to configure your gitlab instance. In the kubernetes/ directory are even some replication controller and services.

## Installation
### ServiceAccount and Permissions
Saidly this guide starts with creating a ServiceAccount which needs the anyuid scc. For some reason Gitlab still requires this. Maybe someday....
So switch to the project where you want to install Gitlab and type the following:
```
oc create sa gitlab-any
oc adm policy add-scc-to-user anyuid -z gitlab-any
```
This needs cluster-admin permissions. If you are only a project admin ask your cluster admin to to this. This is the only step where you need ClusterAdmin permissions. (If you don't delete the ServiceAccount!)

### Storage
I'm not a fan of ephemeral images - at least not for databases and source code repos. Somebody always misunderstands ephemeral and cries afterwards. So this one comes with PersistentVolumeClaims.
Before you create this you can edit the file and change the desired sizes.
```
oc create -f pvc.gitlab.yml
```

### Deployment
Please change the domain of gitlab inside the route.gitlab.yaml and inside dc.gitlab-omnibus.yaml. For more details about the configuration please read the section Usage > Config.
After that create your DeploymentConfig, Service and Route with the following commands:
```
oc create -f dc.gitlab-omnibus.yaml
oc create -f svc.gitlab.yaml
oc create -f route.gitlab.yaml
```

## Usage

### Labels
All components are labeld with app=gitlab. So you can remove everything like that:
```
oc delete --all pvc,dc,svc,route -l app=gitlab
```
*WARNING:* This also removes the PersistentVolumeClaims which contain your data.

### Config
You can edit the configuration files which are created inside the PersistentVolume for config files. But since this is a quick and dirty method: I suggest you add your configuration to this environment variable:
```
GITLAB_OMNIBUS_CONFIG
```
With this varaible you can overwrite all the gitlab.rb settings (for example see https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/files/gitlab-config-template/gitlab.rb.template)

For OpenShift I recommend to set at least the external_url to your https route. (See https://docs.gitlab.com/omnibus/settings/configuration.html#configuring-the-external-url-for-gitlab)

Gitlab also comes with his own prometheus. I suggest to disable the kubernetes function with the following:
```
prometheus['monitor_kubernetes'] = false;
```
Otherwise prometheus complains constantly that it can't read a list of nodes - and there is no way that this "container" gets cluster wide rights :D
If you ever switch to a propper installation of Gitlab you should think about integrating this into your Prometheus which already monitors your OpenShift. The file dc.gitlab-omnibus-prometheus.yaml shows the annotations you need to let OpenShift collect the metrics from Gitlab. You need to get the metrics token from Gitlab once its running here: https://gitlab.example.com/admin/health_check

If you want to use an edge terminating https route in OpenShift you need to specify an external_url with https and configure nginx to listen without https.
```
nginx['listen_port'] = 80; 
nginx['listen_https'] = false; 
```

Complete example:
```
env:
- name: GITLAB_OMNIBUS_CONFIG
    value: "external_url 'https://gitlab.example.com/'; prometheus['monitor_kubernetes'] = false; nginx['listen_port'] = 80; nginx['listen_https'] = false; "

```

## Day 2 Operations & High Availability
💥 There is no such thing - this is a **quick and dirty** *all in one* container. Go away and search for a propper installation of gitlab 😛 
