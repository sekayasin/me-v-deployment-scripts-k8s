# Kubernetes deployment

## **Setup and utilization**
Follow the steps below as a guide to setup kubernetes deployment using the terraform scripts created in this repo

1. Clone this repository from [`Github`](https://github.com/andela/vof-deployment-scripts.git) into your local machine.

2. Edit the `main.tf` in the root directory and pass in the values for each modules. 

3.  Copy the `terraform-init.example` file to `terraform-init` and pass in your values
    ```
    cp terraform-init.example terraform-init
    ```
4. Initialize terraform
   ```
   terraform init -backend-config=terraform-init 
   ```
5. Run `terraform apply -target=module.gke` to create the cluster

6. Run `gcloud container clusters get-credentials NAME_OF_YOUR_CLUSTER` to get the credentials of your cluster

7. Run `terraform apply -target=module.k8s` to create the kubernetes deployment.