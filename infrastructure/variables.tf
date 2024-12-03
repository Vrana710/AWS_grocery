# variables.tf

variable "instance_type" {
  description = "Allowed EC2 instance types"
  type        = string
  default     = "t2.micro"
  validation {
    condition     = contains(["t2.micro", "t2.small", "t3.micro", "t3.small"], var.instance_type)
    error_message = "Only t2.micro, t2.small, t3.micro, and t3.small instances are allowed."
  }
}

variable "db_instance_class" {
  description = "Allowed RDS instance types"
  type        = string
  default     = "db.t2.micro"
  validation {
    condition     = contains(["db.t2.micro", "db.t2.small", "db.t3.micro", "db.t3.small"], var.db_instance_class)
    error_message = "Only db.t2.micro, db.t2.small, db.t3.micro, and db.t3.small RDS instances are allowed."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
}