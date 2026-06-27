# variable "ports" {
#   default = [22, 443, 80]
# }

variable "cidr_block_ip" {
  description = "CIDR block for the AWS VPC."
  type        = string
  default     = "11.0.0.0/16"
}

variable "tag" {
  description = "Name tag applied to the VPC, route table and subnet."
  type        = string
  default     = "aws_1"
}

variable "all_ips" {
  description = "CIDR used for the default route and the allow-all security group rules."
  type        = string
  default     = "0.0.0.0/0"
}

variable "subnet_ip" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "11.0.1.0/24"
}

variable "zone" {
  description = "AWS availability zone for the subnet and EC2 instance."
  type        = string
  default     = "us-east-1a"
}

variable "server_private_ip" {
  description = "Static private IP assigned to the EC2 instance network interface."
  type        = string
  default     = "11.0.1.50"
}

variable "ec2_ami" {
  description = "AMI ID used for the EC2 instance."
  type        = string
  default     = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the EC2 key pair used for SSH access."
  type        = string
  default     = "main.key"
}
