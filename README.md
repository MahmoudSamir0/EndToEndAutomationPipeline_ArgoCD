[![LinkedIn](https://raw.githubusercontent.com/terrytangyuan/terrytangyuan/f6cd62c/imgs/linkedin.svg)](https://www.linkedin.com/in/mahmoudra/)
 [![Slack](https://img.shields.io/badge/slack-argoproj-brightgreen.svg?logo=slack)](https://argoproj.github.io/community/join-slack)
# EndToEndAutomationPipeline_ArgoCD
 ![](Project-documentation/project-overview.png)

# Project Overview

## Objective
This project is dedicated to establishing a robust DevOps pipeline that emphasizes comprehensive testing, code quality analysis, and effective monitoring.

### Key Objectives
1. **Testing Strategies:**
   - **Unit Testing:**
     - Implement thorough unit testing to ensure the correctness and reliability of individual components.
     - Utilize automated testing frameworks for efficient and consistent testing practices.

   - **Integration Testing:**
     - Develop and execute comprehensive integration tests to validate seamless interactions between system components.
     - Include realistic scenarios to simulate end-to-end application behavior.

2. **Code Quality Analysis:**
   - **SonarQube Analysis:**
     - Integrate SonarQube into the CI/CD pipeline for continuous code quality assessment.
     - Monitor and address code smells, security vulnerabilities, and maintainability issues.

3. **Monitoring and Observability:**
   - **Prometheus and Grafana for AKS:**
     - Implement Prometheus and Grafana to monitor and visualize key metrics in the Azure Kubernetes Service (AKS) environment.
     - Ensure real-time visibility into AKS clusters for performance optimization and issue detection.
    - **Monitoring ArgoCD Applications:**
      - Implement monitoring for ArgoCD applications to track deployment status and changes.
  
      - Utilize Prometheus and Grafana to create dashboards for ArgoCD application metrics.
   - **ArgoCD Application Monitoring via Slack:**
     - Integrate ArgoCD with Slack for streamlined notifications.
     - Receive real-time updates on application deployments, GitOps workflow changes, and status reports directly in Slack.

   - **Jenkins Monitoring via Slack:**
     - Configure Jenkins integration with Slack for real-time notifications.
     - Receive alerts on build status, failures, and important pipeline events directly in Slack.

   - **ArgoCD Application Monitoring via Slack:**
     - Set up monitoring for ArgoCD applications via Slack for timely notifications on deployment statuses and workflow changes.
### Workflow:

1. **Developer Workflow:**

   Developers work on the Java application code locally and push changes to a designated private Git repository.

2. **Continuous Integration (CI) Workflow:**

   - **Slack notification:** A notification is sent to the DevOps engineer indicating that the Jenkins pipeline has started.

   - Jenkins, configured with webhooks or periodic polling, detects changes in the private Git repository.
   - Upon detecting changes, Jenkins triggers a CI build, fetching the latest Java code, running unit tests, and building a Docker image.

3. **Unit Testing:**

   - Unit tests are an integral part of the CI process, ensuring that individual components of the Java application function correctly in isolation.

4. **Integration Testing:**

   - Integration tests are conducted before the SonarQube analysis to validate the interaction between different components of the Java application.

5. **SonarQube Analysis:**

   - SonarQube analyzes the code for quality and code coverage.
   - If the code coverage is less than 80%, the pipeline aborts and sends a **Slack notification** to developers.
   - If the code coverage is 80% or higher, the pipeline continues to the next step and sends a **Slack notification** indicating successful SonarQube analysis.

6. **Maven Build:**

   - The pipeline uses Maven to build a JAR file from the Java application.

7. **Continuous Deployment (CD) Workflow:**

   - Successfully built Docker images, containing the Java application, are tagged and pushed to Azure Container Registry (ACR) by Jenkins.
   
   - **ArgoCD Manifest Update:**
       - Jenkins pulls the ArgoCD manifests from the private Git repository.
       - Edits the image tag in the Kubernetes manifests to reflect the newly built Docker image tag.
       - Jenkins commits and pushes the changes back to the private Git repository on GitHub.

   - ArgoCD continuously monitors the private Git repository for changes in Kubernetes manifests.
   - Upon detecting changes, ArgoCD automatically syncs the manifests with the desired state, deploying the updated Java application to the Amazon EKS cluster.

8. **Slack Notifications:**
   - **Success Notification:** If the pipeline completes successfully, send a **Slack notification** to the DevOps engineer indicating that the entire pipeline has succeeded.

   - **Failure Notification:** If any step in the pipeline fails, send a **Slack notification** to the DevOps engineer indicating that the pipeline has failed.

9. **Application Status Monitoring with Slack Notifications:**
   - Integrate a monitoring script or tool that checks the status of the deployed application in ArgoCD every minute.
   - If the application status is healthy, send a **Slack notification** to the DevOps engineer indicating the success status.
   - If the application status is not healthy, send a **Slack notification** to the DevOps engineer indicating the failure status.

10. **Monitoring with Prometheus and Grafana:**

   - Prometheus is configured to scrape metrics from the ArgoCD applications and the Azure AKS cluster.
   - Grafana is set up to visualize and monitor the collected metrics.
## Getting Started

### Setup tools
#### install helm 
you will use Helm to install Argocd  with a stable _chart_.  Helm
is a package manager that makes it easy to configure and deploy Kubernetes
applications.

you have two way to install helm.

##### 1) From the Binary Releases 
1. Download and install the helm binary

    ```shell
    wget https://get.helm.sh/helm-v3.2.1-linux-amd64.tar.gz
    ```

1. Unzip the file to your local system:

    ```shell
    tar zxfv helm-v3.2.1-linux-amd64.tar.gz
    cp linux-amd64/helm .
    ```

1. Add the official stable repository.

    ```shell
    ./helm repo add stable https://kubernetes-charts.storage.googleapis.com
    ```

1. Ensure Helm is properly installed by running the following command. You
   should see version `v3.2.1` appear:

    ```shell
    ./helm version
    ```

    Output (do not copy):

    ```output
    version.BuildInfo{Version:"v3.2.1", GitCommit:"fe51cd1e31e6a202cba7dead9552a6d418ded79a", GitTreeState:"clean", GoVersion:"go1.13.10"}
    ```

##### 2) From Script
You can fetch that script, and then execute it locally. It's well documented so that you can read through it and understand what it is doing before you run it.

```shell
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

    chmod 700 get_helm.sh
    ./get_helm.sh   
```
#### Configure and Install argocd

```shell
    kubectl create namespace argo
    kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.8.4/manifests/install.yaml

```
> [!NOTE]  
> metrics of argocd using above is enabled by default 

```shell
kubectl get all -n argocd
```


Output (do not copy):
    
```output
NAME                                                   READY   STATUS    RESTARTS   AGE
pod/argocd-application-controller-0                    1/1     Running   0          40h
pod/argocd-applicationset-controller-d7dd6fdc8-ffqs7   1/1     Running   0          40h
pod/argocd-dex-server-58c858b64b-5mzqv                 1/1     Running   0          40h
pod/argocd-notifications-controller-59649d4865-fcwlc   1/1     Running   0          40h
pod/argocd-redis-866b65b684-fmz7g                      1/1     Running   0          40h
pod/argocd-repo-server-6797bf9cb8-cpzkk                1/1     Running   0          40h
pod/argocd-server-768d6db45f-vd5zv                     1/1     Running   0          40h

NAME                                               TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)                      AGE
service/argocd-application-controller-metrics      ClusterIP      10.0.76.246    <none>         8082/TCP                     40h
service/argocd-applicationset-controller           ClusterIP      10.0.114.127   <none>         7000/TCP                     40h
service/argocd-applicationset-controller-metrics   ClusterIP      10.0.146.63    <none>         8080/TCP                     40h
service/argocd-dex-server                          ClusterIP      10.0.150.138   <none>         5556/TCP,5557/TCP,5558/TCP   40h
service/argocd-notifications-controller-metrics    ClusterIP      10.0.95.230    <none>         9001/TCP                     40h
service/argocd-redis                               ClusterIP      10.0.114.99    <none>         6379/TCP                     40h
service/argocd-redis-metrics                       ClusterIP      None           <none>         9121/TCP                     40h
service/argocd-repo-server                         ClusterIP      10.0.224.240   <none>         8081/TCP                     40h
service/argocd-repo-server-metrics                 ClusterIP      10.0.131.9     <none>         8084/TCP                     40h
service/argocd-server                              LoadBalancer   10.0.69.65     20.12.141.60   80:31606/TCP,443:32692/TCP   40h
service/argocd-server-metrics                      ClusterIP      10.0.255.134   <none>         8083/TCP                     40h

NAME                                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/argocd-applicationset-controller   1/1     1            1           40h
deployment.apps/argocd-dex-server                  1/1     1            1           40h
deployment.apps/argocd-notifications-controller    1/1     1            1           40h
deployment.apps/argocd-redis                       1/1     1            1           40h
deployment.apps/argocd-repo-server                 1/1     1            1           40h
deployment.apps/argocd-server                      1/1     1            1           40h

NAME                                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/argocd-applicationset-controller-d7dd6fdc8   1         1         1       40h
replicaset.apps/argocd-dex-server-58c858b64b                 1         1         1       40h
replicaset.apps/argocd-notifications-controller-59649d4865   1         1         1       40h
replicaset.apps/argocd-redis-866b65b684                      1         1         1       40h
replicaset.apps/argocd-repo-server-6797bf9cb8                1         1         1       40h
replicaset.apps/argocd-server-768d6db45f                     1         1         1       40h

NAME                                             READY   AGE
statefulset.apps/argocd-application-controller   1/1     40h

```
```shell
kubectl  get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"  -n argo| base64 -d
```

You should now be able to log in with username `admin` and your auto generated
password.

![](Project-documentation/argo_ui.png)

> [!WARNING]
> if you face **ComparisonError while try to deploy k8s resource** in argocd you will need to delete all resource  of argocd and install using helm chart  .

> [!NOTE]  
> metrics of argocd using  helm chart you need to enable all metrics i am just prepere it for  you can found  in [argoccd](tools/argo-cd) you need edit something in [argoccd](tools/argo-cd/values.yaml)
 

 ```yaml
       type: ClusterIP
      # -- Metrics service clusterIP. `None` makes a "headless service" (no virtual IP)
      clusterIP: ""
      # -- Metrics service annotations
      annotations: {}
      # -- Metrics service labels
      labels: {}
      # -- Metrics service port
      servicePort: 8082
      # -- Metrics service port name
      portName: http-metrics
    serviceMonitor:
      # -- Enable a prometheus ServiceMonitor
      enabled: true
      # -- Prometheus ServiceMonitor interval
      interval: 30s
      # -- Prometheus [RelabelConfigs] to apply to samples before scraping
      relabelings: []
      # -- Prometheus [MetricRelabelConfigs] to apply to samples before ingestion
      metricRelabelings: []
      # -- Prometheus ServiceMonitor selector
      selector: 
        release: prometheus-operator
 ```
 you need to edit all **release:prometheus-operator**  to your  release  name of prometheus  


#### Configure and Install Jenkins

1. you can use helm to install Jenkins

   1. using cli
```shell
helm repo add myjenkins https://charts.jenkins.io
helm repo update    
```
```shell
helm install my-jenkins jenkins/jenkins --version 4.6.5 --set controller.serviceType=LoadBalancer    
-n < namespace >
```


```shell
printf $(kubectl get secret --namespace < namespace > jenkns-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo

```
2.  or You can use the Jenkins Kubernetes manifest that I prepared for you [jenkins](tools/jenkins)


```shell

kubectl apply -f . -n < namespace >

```


```shell
kubectl exec -it jenkins-6496bfd479-jhxl7 cat /var/jenkins_home/secrets/initialAdminPassword -n < namespace >
```


#### Configure and Install jenkins agent 
Dockerfile for jenkins [agent](jenkins-agents/agent) 

```dockerfile
FROM ubuntu
USER root
# create user
RUN useradd -m jenkins
RUN mkdir -p /var/jenkins_home
RUN chown -R jenkins:jenkins /var/jenkins_home
WORKDIR /home/jenkins
RUN apt update && apt dist-upgrade -y
# Install required packages
RUN apt install -y \
    git \
    apt-transport-https \
    curl \
    software-properties-common \
    unzip \
    openssh-server openssh-client \
    vim \
    ca-certificates \
    gnupg \
    lsb-release
# Add the HashiCorp GPG key
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -

# Add the HashiCorp official Debian repository
RUN add-apt-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Install Terraform
RUN apt-get update && \
    apt-get install -y terraform
# Install AZURE CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb |  bash
# install java
RUN apt install -y openjdk-17-jdk
# expose port
# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
EXPOSE 22
# running process
ENTRYPOINT ["tail"]
CMD ["-f", "/dev/null"]
```
agent terraform  yaml [files](jenkins-agents/terraform_agent) 

Dockerfile for jenkins [agent](jenkins-agents/terraform_agent) for  Azure  and  

```dockerfile
FROM ubuntu
USER root
# create user
RUN useradd -m jenkins
RUN mkdir -p /var/jenkins_home
RUN chown -R jenkins:jenkins /var/jenkins_home
WORKDIR /home/jenkins
RUN apt update && apt dist-upgrade -y
# Install required packages
RUN apt install -y \
    git \
    apt-transport-https \
    curl \
    software-properties-common \
    unzip \
    openssh-server openssh-client \
    vim \
    ca-certificates \
    gnupg \
    lsb-release
# install docker
RUN mkdir -m 0755 -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Install AZURE CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb |  bash
# install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs
# install java
RUN apt install -y openjdk-17-jdk
# install maven
RUN apt-get install -y maven
# expose port
# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
EXPOSE 22
# running process
ENTRYPOINT ["tail"]
CMD ["-f", "/dev/null"]
```
agent  yaml [files](jenkins-agents/agent) 


#### Connect agents to jenkins to run pipeline 

1. you need to define agent node  in jenkins  
The Jenkins master communicates with the agent node, directing specific tasks for execution. Utilizing agent nodes in Jenkins enables task parallelization, optimizing resource use and expediting job execution.


1. open Manage Jenkins 
2. Manage nodes and clouds
3. new node
4. enter any name 
5. enter name
6. Remote root directory  copy this (/var/jenkins_home)
> [!IMPORTANT]  
> 7. **important** Labels copy this (agent)


8.  Launch method-----------> via ssh
9.  hosts ----------------------> service name  you can find it by  run kubectl get service -n < namespace >
10.  Credentials
      1. Choose  **Add**
      2. Enter the username **jenkins**
      3. Enter the password of the agent  **12345**
      4. Enter any ID.
      5. Choose **Save** 
 11. from Credentials choose the Credentials you create 
 12. Host Key Verification Strategy --------------> no virify
 13. save 
## your agents are ready
#### Configure and Install sonarqube 
To install the chart:

```bash
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update
kubectl create namespace sonarqube
helm upgrade --install -n sonarqube sonarqube sonarqube/sonarqube
```


The default login is **admin/admin.**

#### Configure and Install prometheus and Grafana 

```console
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

_See [`helm repo`](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install Helm Chart

```console
helm install [RELEASE_NAME] prometheus-community/kube-prometheus-stack
```

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

get grafana secret 

```
kubectl get secret --namespace <namespace> grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

## before Create a pipeline
you need to create 3 repo
1.  one for our infrastructure 
2. one for our app
3. one for  argocd-Manifest

### Phase 1: Add your credentials
1. In the **Jenkins UI**, Click **Credentials** on the left
1. Click the **(global)** link
1. Click **Add Credentials** on the left

Credentials you need you add 
1. USER_EMAIL **USER_EMAIL for github**
1. ACR_REPOSITORY
1. TENANT_ID
1. GIT_USERNAME
1. GIT_PASSWORD
1. AZURE_SERVICE_PRINCIPAL_ID
1. AZURE_SERVICE_PRINCIPAL_SECRET


### Phase 2:  webhook sonarqube
1. Configure SonarQube Webhook:

In SonarQube, navigate to the project for which you want to set up the webhook.
Click on **Administration** > **Webhooks**
Add a new webhook and provide the Jenkins URL followed by /sonarqube-webhook/
Save the webhook configuration

![sonarqube-webhook0](Project-documentation/sonarqube-webhook0.png)


![sonarqube-webhook1](Project-documentation/sonarqube-webhook1.png)

![sonarqube-webhook2](Project-documentation/sonarqube-webhook2.png)

![sonarqube-webhoo3](Project-documentation/sonarqube-webhook3.png)


### Phase 3: Generate SonarQube Authentication Token for Jenkins Integration

1. **Log in to SonarQube:**
   - Open your SonarQube instance in a web browser.
   - Log in with your SonarQube administrator credentials.

2. **Navigate to User Tokens:**
   - Click on your username in the top right corner.
   - Choose **My Account** from the dropdown menu.
   - Navigate to the **Security** tab.

3. **Generate Token:**
   - Scroll down to the **Tokens** section.
   - Click on the **Generate Tokens** button.

4. **Provide Token Details:**
   - Enter a name for your token to identify its usage (e.g., **Jenkins Integration**).
   - Optionally, set an expiration date if needed.

5. **Generate Token:**
   - Click on the **Generate** button.

6. **Copy and Save the Token:**
   - Once the token is generated, copy it immediately.
   - Save the token securely, as you won't be able to see it again.

7. **Configure Jenkins with the Token:**
   - Open Jenkins and navigate to **Manage Jenkins** > **Configure System.**
   - In the **SonarQube servers** section, find the SonarQube server configuration used in your Jenkins jobs.
   - Paste the copied token into the **Token** field.
   - Save the Jenkins configuration.


![token1](Project-documentation/token.png)

![token1](Project-documentation/token2.png)

![token1](Project-documentation/token3.png)
![token1](Project-documentation/token4.png)
> [!NOTE]  
> Treat the generated token like a password; it grants access to your SonarQube account
> If the token is lost, you'll need to generate a new one.


### Phase 4: generate slack apps for jenkins and argocd 
#### argocd

1. Create a Slack App
1.  Visit the Slack App Management Page
    - Go to [Slack App Management](https://api.slack.com/apps).
1. Create a New App
    - Click on the "Create New App**button.
1. Enter App Information

   - Provide a name for your app (e.g., "ArgoCD Integration").
   - Choose the Slack workspace.
   - Click on the **Create App** button.

![slack-argo1](Project-documentation/slack-argo1.png)
![slack-argo2](Project-documentation/slack-argo2.png)
1. go to OAuth and permission
    -  in scopes section in Bot Token Scopes section choose chat.write and chat.write.customize 
    - and then choose install  in workspace 
    - Click on **Install to Workspace**and authorize the app.
    -  In the "OAuth & Permissions **section, copy the "Bot User OAuth Token**




![slack-argo3](Project-documentation/slack-argo3.png)

![slack-argo4](Project-documentation/slack-argo4.png)

![slack-argo5](Project-documentation/slack-argo5.png)


5. Store Oauth access token in **argocd-notifications-secret** secret
```shell
kubectl edit  secret argocd-notifications-secret -n < namespace >
```


```yaml
apiVersion: v1
kind: Secret
 stringData: 
  slack-token: <Oauth-access-token>
metadata:
  annotations:
    meta.helm.sh/release-name: argocd
    meta.helm.sh/release-namespace: argo
  creationTimestamp: "2024-01-15T23:18:43Z"
  labels:
    app.kubernetes.io/component: notifications-controller
    app.kubernetes.io/instance: argocd
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: argocd-notifications-controller
    app.kubernetes.io/part-of: argocd
    app.kubernetes.io/version: v2.9.3
    helm.sh/chart: argo-cd-5.52.1
  name: argocd-notifications-secret
  namespace: argo
  resourceVersion: "2736940"
  uid: 23857566-b3a6-46be-a5b0-83c762063769
type: Opaque
~             
```

6. Define service type slack in data section of **argocd-notifications-cm** configmap

```shell
kubectl edit configmap  argocd-notifications-cm -n  < namespace >
```


```yaml
apiVersion: v1
data:
  service.slack: |
    token: $slack-token
    username: argocd 
    icon: ":rocket:"
  context: |
    argocdUrl:
kind: ConfigMap
metadata:
  annotations:
    meta.helm.sh/release-name: argocd
    meta.helm.sh/release-namespace: argo
  creationTimestamp: "2024-01-15T23:18:43Z"
  labels:
    app.kubernetes.io/component: notifications-controller
    app.kubernetes.io/instance: argocd
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: argocd-notifications-controller
    app.kubernetes.io/part-of: argocd
    app.kubernetes.io/version: v2.9.3
    helm.sh/chart: argo-cd-5.52.1
  name: argocd-notifications-cm
  namespace: argo
  resourceVersion: "2736948"
  uid: fb541257-2d48-42ce-953c-54a2e502cace
~                                             
```


7. Add annotation in application yaml file to enable notifications for specific argocd app.

```shell
kubectl edit appproj default -n  < namespace >
```

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  annotations: notifications.argoproj.io/subscribe.on-sync-succeeded.slack: my_channel
  creationTimestamp: "2024-01-15T23:19:02Z"
  generation: 1
  name: default
  namespace: argo
  resourceVersion: "2737241"
  uid: dc5f4bbe-d9cd-4b3a-a49d-dd28a91f73b8
spec:
  clusterResourceWhitelist:
  - group: '*'
    kind: '*'
  destinations:
  - namespace: '*'
    server: '*'
  sourceRepos:
  - '*'
status: {}
```

8. Install Triggers and Templates from the catalog
```shell
kubectl apply -n  < namespace > -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/notifications_catalog/install.yaml
```

#### jenkins

1. Jenkins Slack Plugin:
   1. Log in to your Jenkins instance.
   2. Navigate to **Manage Jenkins** -> **Manage Plugins**
   3. Switch to the **Available** tab and search for **Slack Notification Plugin.**
   4. Install the **Slack Notification Plugin.**
   5. Restart Jenkins if prompted.


![slack-jenkins1](Project-documentation/slack-jenkins1.png)



2. Create a Slack account (if you do not have one) and then create a private/public channel. created a channel named **sample** or **jenkins Notification**.
Then Go to settings > Click on **Add an app** . 

![slack-jenkins2](Project-documentation/slack-jenkins2.png)


3. Click on View App Directory. Search for **Jenkins CI** and click add configuration.

![slack-jenkins3](Project-documentation/slack-jenkins3.png)

4. Set the channel name that you wish to integrate with Jenkins and click on **Add Jenkins CI Integration**.You will get a Team Domain name and Integration Token Credential ID after adding Jenkins CI Integration.
 
![slack-jenkins4](Project-documentation/slack-jenkins4.png)


5. After a successful installation, go to Jenkins > Click on **Manage Jenkins** > Click on **Configure System** Find the **Global Slack Notifier** Settings section and add the following values:.

    1. Enter the name of your workspace.
    2. Integration Token Credential ID as secret text
    3. Channel or Slack Id and other fields are optional
    4. Then save these settings

![slack-jenkins5](Project-documentation/slack-jenkins5.png)


 click test connection 

![slack-jenkins5](Project-documentation/slack-jenkins.png)

### Phase 5: Create a  github webhook to jenkins

1. Switch to your GitHub account.
Now, go to the `Settings` option on the right corner.
1. select the `Webhooks` option and then click on the `Add Webhook` button.
1.   It will provide you the blank fields to add the Payload URL where you will paste your Jenkins address, Content type, and other configuration.


1. The Jenkins endpoint you’ll use must be publicly available over the internet. In my case, the Jenkins URL is http:http://20.221.44.189:8080/, and I need to add github-webhook/ at the end. So, the Payload URL in my case is http://20.221.44.189:8080/github-webhook/
1.  Content type dropdown, pick application/json

1. The “Secret” field is optional. Let’s leave it blank for this Jenkins GitHub Webhook.

1. Next, choose one option under  `Which events would you like to trigger this webhook?`. The 3 options will do the following events listed below:

      1. Just the Push Event: It will only send data when someone push into the repository.

      1. Send Me Everything: It will trigger, if there is any pull or push the event into the repository.
      
      1. Let Me Select Individual Events: You can configure for what events you want your data.

1. Now, click on the “Add Webhook” button to save Jenkins GitHub Webhook configurations.

### Phase 6: Prometheus and Grafana

![prometheus-and-grafana](Project-documentation/prometheus-and-grafana.png)
Grafana provides an effortless way to monitor the health and performance of your AKS cluster. This helps you identify and resolve any issues before they affect your applications. Moreover, Prometheus and Grafana enable you to keep track of the performance and well-being of your app. Collecting metrics from all your Kubernetes nodes with Prometheus is swift while visualizing them with Grafana can be easily done. In this way, you can guarantee that things run smoothly and nip any potential problems in the bud. Furthermore, monitoring Kubernetes with these tools gives essential insights into how users are using your application so that you can make appropriate adjustments to maintain their engagement.

#### Prometheus 

1. For ArgoCD metrics, if you use this method of [instllation](https://github.com/argoproj/argo-cd/blob/master/docs/getting_started.md)

   1. you need to create [servicemonitor](https://argo-cd.readthedocs.io/en/stable/operator-manual/metrics/) files 

2. For ArgoCD metrics, if you use the Helm chart method, ServiceMonitors are enabled by default.

![Prometheus](Project-documentation/Prometheus-1.png)


#### Grafana

you need to Add Prometheus Data Source to Grafana


- In the Grafana sidebar, navigate to **connections** (gear icon) and select **Data Sources**.

![Grafana](Project-documentation/Grafana1.png)

- Click on the **Add your first data source** or the **+** button to add a new data source.
- Choose "Prometheus" from the list of available data sources.

![Grafana2](Project-documentation/Grafana2.png)

- In the "HTTP" section, set the URL to the Prometheus server within the same namespace.
  - If Prometheus is running in the same Kubernetes cluster, use a URL like `http://prometheus-service:9090`.
- Set the access method (Server or Browser) based on your setup.
- Optionally, configure other settings such as authentication if required.

![Grafana3](Project-documentation/Grafana3.png)

- Click the "Save & Test" button to verify the Prometheus data source connection.

![Grafana4](Project-documentation/Grafana4.png)

## Create a pipeline
### Phase 1:  pipeline for your infrastructure


you need frist to create service principal  with role **contributor**

> [!NOTE]
> If you assign the Contributor role to an application at the resource group scope, it can manage resources of all types in that resource group, but not other resource groups in the subscription.
```shell
az ad sp create-for-rbac --name <your-app-name> --role contributor --scopes /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>
```

save APP ID and AZURE PASSWORD you get in Credentials


1. AZURE_APP_ID
1. AZURE_TENANT_ID


```groovy
pipeline {
    agent any
    environment {
        APP_ID = credentials('AZURE_APP_ID')     
        
        PASSWORD = credentials('AZURE_PASSWORD')
        TENANT_ID = credentials('AZURE_TENANT_ID')
    }
    stages {
        stage('Run Terraform') {
            steps {
                script {
                    sh "az login --service-principal -u ${APP_ID} -p ${PASSWORD} --tenant ${TENANT_ID}"
                    dir('infrastructure') {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }
}
```

### Phase 2:  pipeline for your app
You need to first create a service principal with owner permissions to pull and push from the Azure Container Registry (ACR). You can run the script I have prepared for you
 can find it [here](acr_role.sh)  
you need to add you ACR name and SERVICE_PRINCIPAL_NAME 

```shell
ACR_NAME=containerregistrymah1 # change here
SERVICE_PRINCIPAL_NAME=jenkins-pull # change here

ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query "id" --output tsv)
echo $ACR_REGISTRY_ID


PASSWORD=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role owner --query "password" --output tsv)
USER_NAME=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME --query "[].appId" --output tsv)

# Output the service principal's credentials; use these in your services and
# applications to authenticate to the container registry.
echo "Service principal ID: $USER_NAME"
echo "Service principal password: $PASSWORD"
```

then run 
```shell
bash acr_role.sh
```

save APP ID and AZURE PASSWORD you get in Credentials

#### Phase app 1: app jenkins file
```groovy
pipeline {
    agent any

    environment {
        NAME = "petclinic"
        VERSION = "1.${env.BUILD_ID}"
        USER_EMAIL = credentials('USER_EMAIL')
        ACR_REPOSITORY = credentials('ACR_REPOSITORY')
        ACR_REPO = "${env.ACR_REPOSITORY}.azurecr.io/${env.NAME}"
        IMAGE_TAG = "1.${env.BUILD_ID}"
        TENANT_ID = credentials('TENANT_ID')
        GIT_USERNAME = credentials('GIT_USERNAME')
        GIT_PASSWORD = credentials('GIT_PASSWORD')
        GIT_ARGOCD_URL = 'https://github.com/MahmoudSamir0/argocd-petclinic.git'
        AZURE_SERVICE_PRINCIPAL_ID = credentials('AZURE_SERVICE_PRINCIPAL_ID')
        AZURE_SERVICE_PRINCIPAL_SECRET = credentials('AZURE_SERVICE_PRINCIPAL_SECRET')
        newacr="containerregistrymah1.azurecr.io/${env.NAME}"

    }

    stages {
        stage('pipeline start') {
            steps {
                slackSend(channel: "#jenkins-alarm", color: 'good', message: "PIPELINE STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' BRANCH NAME (${env.BRANCH_NAME})")
            }
        }

        
        stage('Build Artifact') {
            steps {
                sh "mvn clean -DskipTest=true"
            }
        }

        stage('Unit Tests') {
            steps {
                sh "mvn test"
            }
        }

        stage("Integration Testing") {
            steps {
                sh 'mvn verify -DskipUnitTests'
            }
        }
       
 stage('SonarQube Analysis'){

            steps {
                    script {
                   def repositoryUrl = scm.userRemoteConfigs[0].getUrl()
                    def GIT_REPO_NAME = repositoryUrl.tokenize('/').last().split("\\.")[0]
                    sh "sed -i s#{{repo_name}}#${GIT_REPO_NAME}# sonar-project.properties"

                    }
                withSonarQubeEnv('sonarqube') {
                    

                sh 'mvn clean package sonar:sonar'
            }
            }
        }

        stage('Quality Gate Condition'){

            steps {
                sleep(10)
                timeout(time: 5, unit: 'MINUTES'){
                waitForQualityGate abortPipeline: true
                            script {
                    def qualitygate = waitForQualityGate()
                    if (qualitygate.status != "OK") {
                        echo 'Slack Notifications for quality gate failure'
                        
                        slackSend (channel: '#jenkins-alarm',
                        color:'danger',
                        message: "* sonarqube Result :* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}   BRANCH NAME ${env.BRANCH_NAME}\nquality gate failure: ${qualitygate.status} ")
                        
                        error "Pipeline aborted due to a quality gate failure: ${qualitygate.status}"
                    }
                    else
                    {
                       echo 'Slack Notifications for quality gate sucsess '
                        slackSend (channel: '#jenkins-alarm',
                        color:'good',
                        message: "* sonarqube Result :* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}   BRANCH NAME ${env.BRANCH_NAME}\nquality gate result : ${qualitygate.status} ")
        
                    }
                    
                }
                }

                }
                }



        stage('Maven Build') {
            steps {
                sh "mvn clean install"
            }
        }

        stage('Build and Push Image to ACR') {
            steps {
                sh 'az login --service-principal -u $AZURE_SERVICE_PRINCIPAL_ID -p $AZURE_SERVICE_PRINCIPAL_SECRET -t $TENANT_ID'
                sh 'az acr build -t $NAME:${IMAGE_TAG} -r $ACR_REPOSITORY .'
            }
        }

stage('pull argocd manifest') {
    steps {
        script {
            deleteDir()
            def determineRepoName = { String repositoryUrl ->
                repositoryUrl.tokenize('/').last().split("\\.")[0]
            }
            def repo_name = determineRepoName(env.GIT_ARGOCD_URL)
            
            dir("${repo_name}") {
                git branch: 'main', credentialsId: 'github_jenkins', url: env.GIT_ARGOCD_URL
            }
        }
    }
}

            
        stage('Update Manifest') {
            steps {
                script {
                    def determineRepoName = { String repositoryUrl ->
                        repositoryUrl.tokenize('/').last().split("\\.")[0]
                    }
                    def argocd_repo_name = determineRepoName(env.GIT_ARGOCD_URL)
                    def path = sh(script: 'pwd', returnStdout: true).trim()
                    def directoryPath = "${path}/${argocd_repo_name}"
                    def fileName = 'petclinic.yaml'
                    def fullFilePath = "${directoryPath}/${fileName}"
                    echo "${path}"
                    sh "pwd"
                    sh "ls -l ${directoryPath}"
                    sh "chmod +x ${fullFilePath}"
                     sh """sed -i -E 's# ${newacr}:[^ ]*# ${newacr}:${VERSION}#g' ${fullFilePath}"""
                    sh "cat ${fullFilePath}"

                }
            }
        }

        stage('Push changes to GITHUB') {
            steps {
                script {
            def determineRepoName = { String repositoryUrl ->
                repositoryUrl.tokenize('/').last().split("\\.")[0]
            }
            def repo_name_push = determineRepoName(env.GIT_ARGOCD_URL)
             dir("${repo_name_push}"){
                    sh "git config --global user.email '${USER_EMAIL}'"
                    sh "git config --global user.name '${GIT_USERNAME}'"
                    sh "git add * "
                    sh "git commit -m 'change image to new VERSION ${VERSION}'"

                    withCredentials([usernamePassword(credentialsId: 'github_jenkins', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                        sh "git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/MahmoudSamir0/argocd-petclinic.git HEAD:main"
                    }
             }
                    
                }
            }
        }
    }

    post {
        always {
            script {
                def pipelineTime = currentBuild.durationString

                if (currentBuild.result == 'FAILURE') {
                    echo 'Slack Notification for pipeline failure'
                    slackSend(
                        channel: '#jenkins-alarm',
                        color: '#FF0000',
                        message: "*Pipeline Failed unknown error :* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} BRANCH NAME ${env.BRANCH_NAME}\nPipeline Result: ${currentBuild.result}\nDuration: ${pipelineTime}"
                    )
                }


else {
echo 'Slack Notification for pipeline success'
                slackSend(channel: '#jenkins-alarm',
                           color: '#00FF00',
                           message: "*Pipeline Succeeded:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} BRANCH NAME ${env.BRANCH_NAME}\nPipeline Result:success\nDuration: ${pipelineTime}")
               }
    }
}
            }
        }
```
#### Phase app 1: multi-branch pipeline 

- Open Jenkins and click on "New Item."
- Enter a name for your job (e.g., "app").
- Select "Multibranch Pipeline" as the job type.
- Click on "OK."


- In the configuration page, under "Branch Sources," add the repository details (e.g., Git URL).
- Set the credentials if your repository requires authentication.

![pipeline-webhook](Project-documentation/pipeline-webhook1.png)

- Under "Build Configuration," specify the Jenkinsfile location (e.g., `Jenkinsfile` in the root of each branch).

In Discover branches All branches

![pipeline-webhook1](Project-documentation/pipeline-webhook2.png)


- Scan Repository Triggers enable it 

![pipeline-webhook2](Project-documentation/pipeline-webhook4.png)


- Click on "Save" to save the job configuration.
- Jenkins will automatically scan the specified branches and create pipeline jobs for each branch.


- On the main Jenkins dashboard, you will see the main job ("app").
- Click on it to see the list of branches and their corresponding builds.
- Jenkins will automatically detect new branches or changes in existing branches and trigger builds accordingly.


- Each branch should contain a `Jenkinsfile` that defines the steps of the pipeline.
- The `Jenkinsfile` is typically stored in the root of your project.

#### Phase app 2: connect to argocd and prepare the app 


1. connect to argocd manfest repo
open argocd 
**Settings**>**Repositories**>**connectrepo**

    you can choose via https or ssh 
    if you choose https you can add username and token you need to genrate in git repo 

![pipeline-argo1](Project-documentation/argo_ui-app1.png)

![pipeline-argo2](Project-documentation/argo_ui-app2.png)

![pipeline-argo2](Project-documentation/argo_ui-app3.png)

2. apply app from argocd manifest repo
You need to prepare the app in ArgoCD to make the pipeline automated.

#### Phase app 3: final

Now, run the pipeline job or make changes in the app repository and push them to GitHub.

pipeline

![pipeline-final1](Project-documentation/final1.png)


slack for jenkins
![pipeline-final2](Project-documentation/final2.png)

![pipeline-final3](Project-documentation/slack-jenkins-2.png)


sonarqube
![pipeline-final4](Project-documentation/final3.png)


![pipeline-final5](Project-documentation/final4.png)



app


![pipeline-final6](Project-documentation/java-app.png)



![pipeline-final7](Project-documentation/java-app-2.png)



grafana

![pipeline-final8](Project-documentation/Grafana-1.png)

![pipeline-final9](Project-documentation/Grafana-4.png)


![pipeline-final10](Project-documentation/Grafana-7.png)

