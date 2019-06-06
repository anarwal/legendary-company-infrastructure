variable "cidr" {
  description = "The CIDR block for the VPC."
  default = "10.30.0.0/16"
}

variable "aws_region" {
  description = "Region for AWS account"
  default = "us-east-1"
}

variable "vpc_name" {
  description = "VPC name"
  default     = "legendary-infra"
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = "list"
  default     = ["10.30.0.0/19", "10.30.64.0/19"]
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = "list"
  default     =  ["10.30.32.0/20", "10.30.96.0/20"]
}

variable "environment" {
  description = "Environment tag, e.g prod"
  default     = "dev"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = "list"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "name" {
  description = "Name tag, e.g stack"
  default     = "legendary-infra-stack"
}

variable "use_nat_instances" {
  description = "If true, use EC2 NAT instances instead of the AWS NAT gateway service."
  default     = false
}

variable "nat_instance_type" {
  description = "Only if use_nat_instances is true, which EC2 instance type to use for the NAT instances."
  default     = "t2.nano"
}

variable "use_eip_with_nat_instances" {
  description = "Only if use_nat_instances is true, whether to assign Elastic IPs to the NAT instances. IF this is set to false, NAT instances use dynamically assigned IPs."
  default     = false
}

variable "tags" {
  type        = "map"
  description = "A map of tags to add to all resources"
  default     =  { Name = "Legendary" }
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  default     = "Infra"
}

variable "public_subnet_tags" {
  type        = "map"
  description = "Additional tags for the public subnets"
  default     = { Name = "" }
}

variable "private_subnet_tags" {
  type        = "map"
  description = "Additional tags for the private subnets"
  default     = { Name = "" }
}

variable "public_route_table_tags" {
  type        = "map"
  description = "Additional tags for the public route tables"
  default     = { Name = "" }
}

variable "private_route_table_tags" {
  type        = "map"
  description = "Additional tags for the private route tables"
  default     = { Name = "" }
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Instance type, see a list at: https://aws.amazon.com/ec2/instance-types/"
}

variable "nexus_instance_type" {
  default     = "m5.large"
  description = "Instance type, see a list at: https://aws.amazon.com/ec2/instance-types/"
}

variable "ami" {
  default     = ""
  description = "AMI for the bastion host"
}

data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }

  owners = ["aws-marketplace"]
}

variable "gitlab_postgres_password" {
  default = ""
}

variable "rds_password" {
  default = ""
}

variable "key_name" {}

variable "ssh_private_key" {}

variable "gitlab_application_ami" {
  default = ""
}

variable "s3_bucket_name" {
  description = "S3 bucket to be used with the project"
  default     = ""
}

variable "nexus_s3_bucket_name" {
  description = "S3 bucket to be used with nexus"
  default     = ""
}


variable "force_destroy" {
  default = "false"
}

variable "server_side_encryption" {
  default = "true"
}

variable "versioning_enabled" {
  default = "false"
}

variable "lifecycle_infrequent_storage_transition_enabled" {
  description = "Specifies infrequent storage transition lifecycle rule status."
  default     = "true"
}

variable "lifecycle_infrequent_storage_object_prefix" {
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
  default     = "cp_infrequent"
}

variable "lifecycle_days_to_infrequent_storage_transition" {
  description = "Specifies the number of days after object creation when it will be moved to standard infrequent access storage."
  default     = "90"
}

variable "lifecycle_glacier_transition_enabled" {
  description = "Specifies Glacier transition lifecycle rule status."
  default     = "true"
}

variable "lifecycle_glacier_object_prefix" {
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
  default     = "cp_glacier"
}

variable "lifecycle_days_to_glacier_transition" {
  description = "Specifies the number of days after object creation when it will be moved to Glacier storage."
  default     = "180"
}

variable "lifecycle_expiration_enabled" {
  description = "Specifies expiration lifecycle rule status."
  default     = "true"
}

variable "lifecycle_expiration_object_prefix" {
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
  default     = "cp_expired"
}

variable "lifecycle_days_to_expiration" {
  description = "Specifies the number of days after object creation when the object expires."
  default     = "365"
}

variable "BucketSizeBytes" {
  default = "100000"
}

variable "NumberOfObjects" {
  default = "100"
}

variable "user_name" {
  default = ""
}

variable "nexus_user_name" {
  default = ""
}

data "aws_caller_identity" "current" {}

variable "rotation_status" {
  default = "1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }


  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

variable amazon_linux_ami {
  type        = "string"
  description = "AMI for AWS EC2 instance resources."
  default     = "ami-0ff8a91507f77f867" # Amazon Linux AMI
}
variable gitlab_runner_aws_instance_name {
  type        = "string"
  description = "AWS EC2 instance name."
  default     = ""
}
variable gitlab_runner_aws_instance_type {
  type        = "string"
  description = "AWS EC2 instance type resources."
  default     = "t2.nano"
}

################################################################################################################
## Gitlab Runner Settings
################################################################################################################
variable gitlab_runner_name {
  type = "string"
  description = "Gitlab Runner Instance Name."
  default = ""
}
variable gitlab_runner_url {
  type = "string"
  description = "Gitlab CI coordinator URL."
  default = ""
}
variable gitlab_runner_token {
  type = "string"
  description = "Gitlab Runner registration token."
  default = ""
}
variable gitlab_runner_tags {
  type = "string"
  description = "Gitlab Runner tag list (comma separated)."
  default = "specific,docker"
}
variable gitlab_runner_docker_image {
  type = "string"
  description = "Gitlab Runner default docker image."
  default = "java:latest"
}
variable gitlab_concurrent_job {
  type = "string"
  description = "Number of Gitlab CI concurent job to run."
  default = "4"
}
variable gitlab_check_interval {
  type = "string"
  description = "Gitlab CI check interval value."
  default = "0"
}

################################################################################################################
## GitLab Runner Cleanup Tool Setting
################################################################################################################
variable gitlab_rct_low_free_space {
  type = "string"
  description = "Gitlab Runner Cleanup Tool - LOW_FREE_SPACE (When trigger the cache and image removal)"
  default = "1G"
}
variable gitlab_rct_expected_free_space {
  type = "string"
  description = "Gitlab Runner Cleanup Tool - EXPECTED_FREE_SPACE (How much the free space to cleanup)"
  default = "2G"
}
variable gitlab_rct_low_free_files_count {
  type = "string"
  description = "Gitlab Runner Cleanup Tool - LOW_FREE_FILES_COUNT (When the number of free files (i-nodes) runs below this value trigger the cache and image removal)"
  default = "131072"
}
variable gitlab_rct_expected_free_files_count {
  type = "string"
  description = "Gitlab Runner Cleanup Tool - EXPECTED_FREE_FILES_COUNT (How many free files (i-nodes) to cleanup)"
  default = "262144"
}
variable gitlab_rct_default_ttl {
  type = "string"
  description = "Gitlab Runner Cleanup Tool - DEFAULT_TTL (Minimum time to preserve a newly downloaded images or created caches)"
  default = "1m"
}
variable gitlab_rct_use_df {
  description = "Gitlab Runner Cleanup Tool - USE_DF (Use a command line df tool to check disk space)"
  default = "1"
}

variable "nexus_dns_name" {
  default = ""
}

variable "example_application_dns_name" {
  default = ""
}

variable "dns_zone_id" {
  default = ""
}

variable application_aws_instance_type {
  type        = "string"
  description = "AWS EC2 instance type resources."
  default     = "t2.nano"
}