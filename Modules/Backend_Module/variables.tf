variable "dynamodb_name" {
  description = "Name of the DynamoDB table used for Terraform state locking."
  type        = string
  default     = "statelockdb"
}

variable "bucket_name" {
  description = "Name of the S3 bucket used to store the remote Terraform state."
  type        = string
  default     = "statebucket"
}
