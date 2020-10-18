terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

variable "domain" {
  default = "parking-sensor"
}

data "aws_region" "current" {}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.domain
  elasticsearch_version = "7.7"

  cluster_config {
    instance_type = "t3.small.elasticsearch"
    instance_count = 1
    dedicated_master_enabled = false
    zone_awareness_enabled = false
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }
}
