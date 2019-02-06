# Grafana with OpenShift OAuth Proxy

## NOTE
You have to be cluster-admin to install the Grafana template.

## Usage

You need 'jq' installed on your machine. 

For MAC:
```
brew install jq
```
For RHEL/CentOS:
```
yum install jq
```
For Fedora:
```
dnf install jq
```

```
chmod +x installTemplate.sh
./install.sh $YOUR_OCP_USER $YOUR_OCP_MASTER_URL
```

## Dashboards

6873, 6876, 6879 (Billing)
