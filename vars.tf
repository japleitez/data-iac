############################################################
#       Variables to support new environments              #
############################################################

variable "vpc_cidr" {
  description = "The VPC cidr"
  type        = map(string)
  default = {
    mr          = "10.20.0.0/16"
    development = "10.21.0.0/16"
    test        = "10.22.0.0/16"
    pre         = "10.23.0.0/16"
    prod        = "10.24.0.0/16"
  }
}

variable "enable_vpc_peering_connection" {
  description = "Enable VPC peering connection"
  type        = map(string)
  default = {
    mr          = 0
    development = 0
    test        = 1
    pre         = 0
    prod        = 1
  }
}

variable "vpc_peering_connection_id" {
  description = "The VPC peering connection id"
  type        = map(string)
  default = {
    mr          = ""
    development = ""
    test        = "pcx-06ddb41bb70650328"
    pre         = ""
    prod        = "pcx-0bf98c22b5f3be973"
  }
}

variable "storm_log_group_name" {
  description = "The name for Storm Cluster AWS Cloudwatch group name"
  default     = "/ecs/data-collection/storm-cluster"
}

variable "storm_log_stream_prefix" {
  description = "The prefix for Storm Cluster stream"
  default     = "stormcluster"
}

variable "bastion_ssh_public_key_merge_request" {
  description = "Public key for Bastion host in merge_request"
  default     = ""
}

variable "bastion_ssh_public_key_development" {
  description = "Public key for Bastion host in development"
  default     = ""
}

variable "bastion_ssh_public_key_test" {
  description = "Public key for Bastion host in test"
  default     = ""
}

variable "bastion_ssh_public_key_pre" {
  description = "Public key for Bastion host in pre-production"
  default     = ""
}

variable "bastion_ssh_public_key_prod" {
  description = "Public key for Bastion host in production"
  default     = ""
}

#TF_VAR_access_ips
variable "access_ips" {
  description = "The list of IPs that can access the infrastructure"
  default = [
    "217.31.72.50/32",  #Arhs
    "99.80.223.121/32", #Gitlab Runner
    "158.169.150.0/27", #Bruxelles Proxies
    "158.169.40.0/27"   #Luxembourg Proxies
  ]
}

variable "vpn_ip" {
  description = "The VPN IP to access prod env"
  default     = "3.65.191.44/32"
}

variable "oauth_auth_domain" {
  description = "The Cognito domain"
  type        = map(string)
  default = {
    # MR is using Dev Cognito because we reached the limit of custom domain Cognito pools
    mr          = "auth-development.wihp.ecdp.tech.ec.europa.eu"
    development = "auth-development.wihp.ecdp.tech.ec.europa.eu"
    test        = "auth-test.wihp.ecdp.tech.ec.europa.eu"
    pre         = "auth-pre.wihp.ecdp.tech.ec.europa.eu"
    prod        = "auth-prod.wihp.ecdp.tech.ec.europa.eu"
  }
}
variable "oauth_dashboard_client_id" {
  description = "The OAuth2 client id for Dashboard"
  type        = map(string)
  default = {
    # MR is using Dev Cognito because we reached the limit of custom domain Cognito pools
    # You can find the values in AWS->Cognito pool -> wihp-user-pool-$ENV -> General settings -> App clients
    # The value change only if we delete and create a new pool.
    mr          = "6tk1r9rj3lb2sqpp42shgfljsl"
    development = "6tk1r9rj3lb2sqpp42shgfljsl"
    test        = "7r00h1e1lc6hn8ao7aejoqku2o"
    pre         = "2t49q2m4r9ksbcp8eogj6un0l4"
    prod        = "1ip53ipgk8mrd295shpdgar4kn"
  }
}
variable "oauth_data_acquisition_service_client_id" {
  description = "The OAuth2 client id for Data Acquisition Service"
  type        = map(string)
  default = {
    # MR is using Dev Cognito because we reached the limit of custom domain Cognito pools
    # You can find the values in AWS->Cognito pool -> wihp-user-pool-$ENV -> General settings -> App clients
    # The value change only if we delete and create a new pool.
    mr          = "dv9pcgqava8b6du311jikf9aj"
    development = "dv9pcgqava8b6du311jikf9aj"
    test        = "1qov2v6nka52i5qdbp4obmc0d6"
    pre         = "2mbr4dp5bkhui1q95hgmveltjv"
    prod        = "g9q3jifsviatsqs1usok6jkjr"
  }
}
variable "oauth_data_acquisition_service_client_secret" {
  description = "The OAuth2 client secret for Data Acquisition Service"
  type        = map(string)
  default = {
    # MR is using Dev Cognito because we reached the limit of custom domain Cognito pools
    # You can find the values in AWS->Cognito pool -> wihp-user-pool-$ENV -> General settings -> App clients
    # The value change only if we delete and create a new pool.
    mr          = "6h8gfrai17as73h6i377na42b15m7j8m45c4uv4hld6m046fp54"
    development = "6h8gfrai17as73h6i377na42b15m7j8m45c4uv4hld6m046fp54"
    test        = "k6jvfmhvohrm6c33ljc6764kabch152hcq77lbtim687av3fi7"
    pre         = "g15udei2no51ut6bs61ia0idon69750o1uo9gdreqdr59ebkhth"
    prod        = "8sd2c07ovr39onf6ap841u6q55u19np0te4lpugqdbp8gpu0k1"
  }
}

variable "oauth_playground_service_client_id" {
  description = "The OAuth2 client id for Playground Service"
  type        = map(string)
  default = {
    # MR is using Dev Cognito because we reached the limit of custom domain Cognito pools
    # You can find the values in AWS->Cognito pool -> wihp-user-pool-$ENV -> General settings -> App clients
    # in the new interface : Amazon Cognito > User pools > wihp-user-pool-$ENV > App client: playground_service
    # The value change only if we delete and create a new pool.
    mr          = "6826bhi6jpn28ikkirijmle6as"
    development = "6826bhi6jpn28ikkirijmle6as"
    test        = "3lttq10nqfr5ihkrfdiemj7q0g"
    pre         = "43joeaafjjctdnc7696svu7oqj"
    prod        = "73mjsk3ba03hamr27o6qn3ja70"
  }
}
variable "oauth_playground_service_client_secret" {
  description = "The OAuth2 client secret for Playground Service"
  type        = map(string)
  default = {
    # MR is using Dev Cognito because we reached the limit of custom domain Cognito pools
    # You can find the values in AWS->Cognito pool -> wihp-user-pool-$ENV -> General settings -> App clients
    # in the new interface : Amazon Cognito > User pools > wihp-user-pool-$ENV > App client: playground_service
    # The value change only if we delete and create a new pool.
    mr          = "lfdqo73ikm9qi5q8b4140dg05hj7l77ub042di5i2qff05n93u6"
    development = "lfdqo73ikm9qi5q8b4140dg05hj7l77ub042di5i2qff05n93u6"
    test        = "1cglotl5jbbm94n7o8t96a06dq98ehp5h7o4o8bq07695oiq1ot6"
    pre         = "1aj4gb1tlhlc9ggfl9k5vm6n36vrq0s2r6buogn7gla2nueqp5bc"
    prod        = "1i2uf70b6imbae1t2andi4snm1tcf3i7a53mpddfh4ea4oahulas"
  }
}

variable "oauth_pool_id" {
  description = "The Cognito pool id"
  type        = map(string)
  default = {
    # MR is using Dev Cognito because we reached the limit of custom domain Cognito pools
    # You can find the values in AWS->Cognito pool -> wihp-user-pool-$ENV -> General settings
    # The value change only if we delete and create a new pool.
    mr          = "eu-central-1_VvHFyT8zK"
    development = "eu-central-1_VvHFyT8zK"
    test        = "eu-central-1_YvHxpIqYW"
    pre         = "eu-central-1_9YQrQxKtc"
    prod        = "eu-central-1_T3U4BY8IX"
  }
}

variable "mwaa_client_ids" {
  description = "The list of client ids for MWAA per environment"
  type        = map(string)
  default = {
    mr          = "25ubrqf1ch8p1n3t5s5pf8pvne"
    development = "25ubrqf1ch8p1n3t5s5pf8pvne"
    test        = "1hm539753833f9te1b2uelf9a6"
    pre         = "43a878s52ukfsnej4leqbibgnp"
    prod        = "50rr4i5jt9nk2157nl6tjb95hs"
  }
}

variable "mwaa_client_secrets" {
  description = "The list of client secrets for MWAA per environment"
  type        = map(string)
  default = {
    mr          = "15dff0q3l69g2vbor1mreblmpr5gth467iabn597k8v3sdbae2fs"
    development = "15dff0q3l69g2vbor1mreblmpr5gth467iabn597k8v3sdbae2fs"
    test        = "rghubg2lebse0do0h124nq1m994oh9t4kng4fa27rhr2gea1rvo"
    pre         = "tej7n3ogt838nhg0fgv1emvgpf6ogqbv3eh64kuj8vm67s7jbsd"
    prod        = "3dvpb754ok3nt9sr9jauqv4apbsrd51nevr32dij8f1fj3d2gsd"
  }
}

locals {

  datalab_cidr_block = "10.0.0.0/16"

  elastic_search_ssh_cidr_block = {
    mr          = [module.wihp_vpc.vpc_cidr_block]
    development = [module.wihp_vpc.vpc_cidr_block]
    test        = [module.wihp_vpc.vpc_cidr_block, local.datalab_cidr_block]
    pre         = [module.wihp_vpc.vpc_cidr_block]
    prod        = [module.wihp_vpc.vpc_cidr_block, local.datalab_cidr_block]
  }

  elastic_search_https_cidr_block = {
    mr          = [module.wihp_vpc.vpc_cidr_block]
    development = [module.wihp_vpc.vpc_cidr_block]
    test        = [module.wihp_vpc.vpc_cidr_block, local.datalab_cidr_block]
    pre         = [module.wihp_vpc.vpc_cidr_block]
    prod        = [module.wihp_vpc.vpc_cidr_block, local.datalab_cidr_block]
  }

  default_tags = {
    Project     = "Eurostat-WIHP"
    Environment = var.environment
    Terraform   = "true"
  }

  bastions_key = {
    mr          = var.bastion_ssh_public_key_merge_request
    development = var.bastion_ssh_public_key_development
    test        = var.bastion_ssh_public_key_test
    pre         = var.bastion_ssh_public_key_pre
    prod        = var.bastion_ssh_public_key_prod
  }

  postgres_secrets_tf = {
    mr          = var.postgres_secret_mr
    development = var.postgres_secret_development
    test        = var.postgres_secret_test
    pre         = var.postgres_secret_pre
    prod        = var.postgres_secret_prod
  }

  access_ips = {
    mr          = var.access_ips
    development = var.access_ips
    test        = var.access_ips
    pre         = var.access_ips
    prod        = concat(var.access_ips, [var.vpn_ip]) #VPN
  }

  available_subnet = length(var.availability_zones) * length(var.unique_private_subnet_zones)
}
############################################################

#TF_VAR_environment
variable "environment" {
  description = "The environment name"
  default     = "mr"
}

variable "vpc_name" {
  description = "The name for Data Collection VPC"
  default     = "Data Collection VPC"
}

variable "availability_zones" {
  description = "Availability zones"
  default     = ["eu-central-1a", "eu-central-1b"]
  type        = list(string)
}

variable "unique_private_subnet_zones" {
  description = "Subnets needed per zone"
  default     = ["ecs", "rds"]
  type        = list(string)
}

#TF_VAR_postgres_secret_mr
variable "postgres_secret_mr" {
  description = "PostgrestSQL password environment MR"
  default     = "QCM4CNpBmEC8GEZy"
}

#TF_VAR_postgres_secret_development
variable "postgres_secret_development" {
  description = "PostgrestSQL password environment DEVELOPMENT"
  default     = "QCM4CNpBmEC8GEZy"
}

#TF_VAR_postgres_secret_test
variable "postgres_secret_test" {
  description = "PostgrestSQL password environment TEST"
  default     = "QCM4CNpBmEC8GEZy"
}

#TF_VAR_postgres_secret_pre
variable "postgres_secret_pre" {
  description = "PostgrestSQL password environment PRE"
  default     = "QCM4CNpBmEC8GEZy"
}

#TF_VAR_postgres_secret_prod
variable "postgres_secret_prod" {
  description = "PostgrestSQL password environment PROD"
  default     = "QCM4CNpBmEC8GEZy"
}


#TF_VAR_db_snapshot_identifier
variable "db_snapshot_identifier" {
  description = "DB' snapshot to recover the current PostgrestSQL"
  default     = null
}

#TF_VAR_data_acquisition_dashboard_tag
variable "data_acquisition_dashboard_tag" {
  description = "Tag name for the  Data Acquisition Dashboard Docker image"
  default     = "feature_wih_1539_0.0.2"
}

#TF_VAR_data_acquisition_service_tag
variable "data_acquisition_service_tag" {
  description = "Tag name for the Data Acquisition Service' Docker image"
  default     = "feature_wih_1554_0.0.7"
}

#TF_VAR_playground_service_tag
variable "playground_service_tag" {
  description = "Tag name for the Playground Service' Docker image"
  default     = "2.0.4"
}

