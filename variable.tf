variable "project" {
    type = string
  
}

variable "environment" {
    type = string
  
}


variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_tags" {
    type = map(string)
    default = {
        project = "devops"
    }
}

variable "igw_tags" {
    type = map(string)
    default = {
        project = "devops"
    }
  
}

variable "public_subnet_cidrs" {
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24"]
  
}