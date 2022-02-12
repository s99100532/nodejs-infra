# Nodejs Application infrastucture

This is the documentation decribing the infrastucture.

![alt text](da52993d-035b-4c64-afb7-2f668f1caa05.png "Overview")

## Checklist

- [x] Application must be public on the internet and accessible on port 80.
- [x] fault tolerance with high availability.
- [x] Use AWS as the cloud provider, but only free-tier resources are allowed.
- [x] The solution should be easy to manage/maintain.
  - [x] preconfigured autoscaling
  - [x] terraform managed configuration
  - [x] optional to use fargate (serverless)
- [x] Deliver all code/documentation required to deploy the infrastructure and the application in compressed file.

### Optional

- [x] Provide a repository of a Control Version System like Github/Gitlab/Bitbucket instead of the previous compressed file
- [x] Application logs are centralised on a different service (cloudwatch)
- [x] The solution can be up and running by executing a single command/script
- [x] Management access (SSH or RDP) to the servers are allowed only for restricted IPs
- [x] Design and implement a process for deploying new application versions with no downtime

## Provision the infrascture

## Prerequisites

Terraform is the CI/CD for infrastructure in which there are still some steps for first time setup.

1. create your own ssh key and then generate the public key and replace file `public.pub`

3. Intall `terraform` and `aws-cli` according to [here](https://learn.hashicorp.com/tutorials/terraform/install-cli) and [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

4. (Optional if use default AWS profile) Create a named AWS profile for terraform to provision the infrastructure.

```sh
# configure the AWS credential
aws configure --profile $YOUR_PROFILE_NAME
# setup default profile for current session
export AWS_PROFILE=$YOUR_PROFILE_NAME
```

3. RUN

```sh
# initialize the dependency
terraform init
# review the infrastructure change
terraform plan
# provision the infrastructure
terraform apply
```

## Test autoscaling

1. Install k6 ([tutorial](https://k6.io/docs/getting-started/installation/))

2. go to `load_test` directory from repository root and run the script

```sh
# assume you are in repository root.
cd load_test
k6 run script.js
```

3. the cluster will be scaled in 3 minutes.
