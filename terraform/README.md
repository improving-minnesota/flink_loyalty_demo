## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Repo Structure](#repo-structure)
3. [Getting Started](#getting-started)

## Prerequisites

1. [Sign up for Confluent Cloud](https://confluent.cloud/home) with your email.

2. [Create a Confluent Cloud API Key](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/guides/sample-project#create-a-cloud-api-key)

    > To solve the 🐥 🥚 problem, we need the initial API Key created manually that Terraform can leverage

   1. Open the Confluent Cloud Console and navigate to "API keys"
   2. Select "+ Add API key"
   3. To keep things simple, select "My account" to create a key that has all of your access permissions
      1. NOTE: In production, you would create a service account with specific permissions and generate the key from that
   4. Select "Cloud resource management" for your resource scope, click "Next"
   5. Enter Name: "Terraform API Key" and Description: "Used by Terraform to provision Cloud Resources", click "Create API key"  
   6. Click "Download API Key" (you'll these this when provisioning the cluster)

3. [Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform)

## Getting Started

The [Confluent Terraform Provider](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs) needs your Confluent Cloud API Key/Secret to connect to the Organization you provisioned in the prereqs.

There are two [Terraform variables](https://developer.hashicorp.com/terraform/language/values/variables) for these --> `confluent_cloud_api_key` && `confluent_cloud_api_secret`

When running `terraform plan/apply`, Terraform will prompt you for any variables that aren't set via defaults or environment variables.

To avoid the repetitive prompt, copy, paste game - set the environment variables below and Terraform will leverage them on each run.

```shell
export TF_VAR_confluent_cloud_api_key="<cloud_api_key>"
export TF_VAR_confluent_cloud_api_secret="<cloud_api_secret>"
```

### Provisioning Confluent Cloud **Environments**
First, provision your environments from the `demo-infrastructure` repo (folder).

1. `cd terraform/demo-infrastructure`
2. `terraform init`
3. `terraform apply` # approve after review, this may take a few minutes to complete
4. Confirm the Environments are created in your [Confluent Cloud](https://confluent.cloud/home) account

### Produce Sample Product Data
There is a [python script](./data/loadProducts.py) that will produce all the `product` [data](./data/product-data.json) to the `raw_products` topic.  

----

End of environment setup, continue with [Workshop](./workshop/README.md).