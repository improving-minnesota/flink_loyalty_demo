# Confluent Cloud

This repository contains a Terraform template to provision Confluent Cloud environments, clusters, topics, stream processing, and more.

## Table of Contents

1. [Environment Overview](#environment-overview)
2. [Prerequisites](#prerequisites)
3. [Repo Structure](#repo-structure)
4. [Getting Started](#getting-started)

## Environment Overview

![env-overview](./assets/demo-env.png)

> Image Source: [./assets/demo-env.excalidraw](./assets/demo-env.excalidraw)

## Prerequisites

1. [Sign up for Confluent Cloud](https://confluent.cloud/home) with your email.

    > NOTE: Each trial is only good for 30 days, so if you've done this before you can add a +1, +2, etc suffix to the email to create "unique" accounts
    > * ex) `matthew.schroeder+1@improving.com`
    > * ex) `matthew.schroeder+2@improving.com`

   - [ ] Verify email
   - [ ] Boost free trial credits to $750 with additional promo codes (_codes subject to change_)
     - $400 is given by default
     - $50 -> `C50INTEG`
     - $200 -> `DEVOPS200`
     - $100 -> `CLOUD100`

> ⚠️️ Although you're now rolling in $750 of lush credits, be sure to tear your environment(s) down after each use.

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

    > We don't click buttons around here. Everything will be provisioned through Terraform.

## Repo Structure

The `./template` folder contains a few key subfolders - in a real env, these would likely be separate repos. 

```txt
./template
├── kafka-ops-team  
│   └── main.tf                     # environment resources
├── kafka-product-team-{domain}
│   ├── development
│   │   ├── flink-statements
│   │   │   └── ... flink .sql files
│   │   ├── schemas
│   │   │   └── ... schema files
│   │   ├── main.tf                 # environment data sources
│   │   └── cluster-{name}.tf       # provision cluster ${name} & cluster resources
│   ├── staging
│   │   └── ... mirrors development
│   └── production
│   │   └── ... mirrors staging
├── modules
│   ├── confluent_cloud_environment # shared module to provision environments
│   ├── product_team_avro_topic     # shared module to provision topics tied to an Avro schema
│   └── product_team_basic_cluster  # shared module to provision clusters & flink compute pools
├── observability
│   └── grafana-cloud.md            # guide on configuring grafana cloud to scrape confluent cloud Metrics API
└── shadowtraffic
    ├── license.env                 # shadowtraffic license details
    └── {domain}
        ├── config                  # holds generators, stages, connections, and other configurations
        ├── start-std-out.sh        # script to run shadowtraffic, dumping results to std out (for testing)
        └── start-kafka.sh          # script to run shadowtraffic, producing results to Kafka (configs required)
```

### kafka-ops-team

This repo (folder) holds the shared [Environment](https://docs.confluent.io/cloud/current/access-management/hierarchy/cloud-environments.html#environments-on-ccloud) configurations (think `development`, `staging`, `production`). All environments should be configured within this central ops-team space.

> A Confluent Cloud environment contains Kafka clusters and deployed components, such as Connect, ksqlDB, and Schema Registry. You can define multiple environments in an organization, and there is no charge for creating or using additional environments. Different departments or teams can use separate environments to avoid interfering with each other.

### kafka-product-team-{domain}

In organizations with domain-aligned teams, each team would have their own repo that manages their resources.

Product Team Resources (things they can create) Include -

* Clusters
* Topics
* Schemas
* Flink Compute Pools
* Service Accounts / ACLs
* ... and more

With an Environment in place, Product Teams are empowered to create their own systems.

### modules

This repo (folder) holds shared modules that are leveraged by both ops & product teams.

> Review each module's variables.tf for insight into the various knobs that are exposed on the resources.

Modules -

* `confluent_cloud_environment`: Provisions Confluent Cloud Environments & Stream Governance (Schema Registry)
* `product_team_avro_topic`: Provisions Avro Schema & Topic within a Cluster.
* `product_team_basic_cluster`: Provisions `basic` level Confluent Cloud Clusters within an Environment.

### Observability

Confluent Cloud provides a variety of tools to observe your pipelines but most teams will also leverage a third party tool that aggregates telemetry
across a wide variety of sources. This folder holds guides on setting up observability of the Confluent Cloud Metrics API from third party tools.

- ex. [Grafana Cloud](./template/observability/grafana-cloud.md)

### shadowtraffic

https://shadowtraffic.io/ enables rapid simulation of data into various data technologies.

Additional details on running shadowtraffic can be found in the [README](./template/shadowtraffic/README.md).

## Getting Started

The [Confluent Terraform Provider](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs) needs your Confluent Cloud API Key/Secret to connect to the Organization you provisioned in the prereqs.

> Need an API Key/Secret? See the [Prerequisites Section](#prerequisites) at the top of this README.

There are two [Terraform variables](https://developer.hashicorp.com/terraform/language/values/variables) for these --> `confluent_cloud_api_key` && `confluent_cloud_api_secret`

When running `terraform plan/apply`, Terraform will prompt you for any variables that aren't set via defaults or environment variables.

To avoid the repetitive prompt, copy, paste game - set the environment variables below and Terraform will leverage them on each run.

```shell
export TF_VAR_confluent_cloud_api_key="<cloud_api_key>"
export TF_VAR_confluent_cloud_api_secret="<cloud_api_secret>"
```

### Provisioning Confluent Cloud **Environments**

First, provision your environments from the `kafka-ops-team` repo (folder).

1. `cd template/kafka-ops-team`
2. `terraform init`
3. `terraform apply` # approve after review, this may take a few minutes to complete
   - As of V1.80.0 of the Confluent Provider, you will receive a "Warning: Deprecated Resource" around Schema Registry. Ignore this.
   - As of V2.0.0 of the Confluent Provider, this Warning should be gone.
4. Confirm the Environments are created in your [Confluent Cloud](https://confluent.cloud/home) account

If needed, the `kafka-ops-team/outputs.tf/staging-resource-ids` will emit a variety of useful identifiers, keys, & urls.

```bash
> terraform output staging-resource-ids
            
<<EOT

====

Staging Environment ID:   env-123456
Staging Schema Registry ID:   lsrc-123456
Staging Schema Registry Rest Endpoint:   https://psrc-123456.us-east1.gcp.confluent.cloud
Staging MetricsViewer API Key: xxxxx:xxxxxxxx
Staging EnvironmentAdmin/AccountAdmin API Key:  xxxxx:xxxxxxxx
```

### Provisioning Product Team Resources (Staging Environment)

Next, provision your clusters, Flink compute pools, topics, and more via the product team repo (folder).

> ⚠️ This is a 2-step process due to the use of a cluster-specific [aliased `provider`](https://developer.hashicorp.com/terraform/language/providers/configuration#alias-multiple-provider-configurations) to simplify the configuration of resources for the cluster. With the cluster-specific provider, you can just pass the entire aliased `provider` on the resources rather than repeating all the configurations.

Provision the cluster, Flink compute pool (optional), and cluster API Keys -

> Note: Make sure the aliased provider and kafka topic resources are commented out.

1. `cd template/kafka-product-team-inventory/staging`
2. `terraform init`
3. `terraform apply` # approve after review

The cluster-specific [aliased `provider`](https://developer.hashicorp.com/terraform/language/providers/configuration#alias-multiple-provider-configurations) can't be created until the cluster exists.

4. Uncomment the aliased provider as well as all other resources that leverage the provider (topics, flink statements, etc).
5. Run `terraform apply` # approve after review

⚠️ There is no data in the cluster in this point. The following section will get data into the cluster via ShadowTraffic.

> Copy `/staging` into `/production` and repeat the above steps if you'd like to provision a cluster in another environment. Modify the `display_name` value on the `/main.tf/confluent_environment` data source.

### Producing Data with ShadowTraffic

To hydrate data into the topics, follow the instructions in the ShadowTraffic folder's [README](./template/shadowtraffic/README.md).

## Additional Confluent Cloud Terraform Examples: terraform-provider-confluent/examples/configurations

Confluent has gathered a variety of relevant Terraform examples. Some have been leveraged in this repo and some have not.

1. `git clone https://github.com/confluentinc/terraform-provider-confluent.git`
2. `cd terraform-provider-confluent/examples/configurations`
3. Browse Configurations!