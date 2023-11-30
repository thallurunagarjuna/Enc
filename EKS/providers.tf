#
# Provider Configuration
#

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAUIN3TDLRMJDFVDO4"
  secret_key = "wZUuIsej7XE/16HsSxEuLu94UXyE73EgCS7RbPf6"


}

provider "kubernetes" {
  config_path = "~/.kube/config" # Path to your Kubernetes config file
}


