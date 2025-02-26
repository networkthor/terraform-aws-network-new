variable "environment" {
    type = string
    default = "dev"
}

variable "region" {
    type = string
    default = "eu-west-1"
}

variable "cidr_block" {
    type = string
}

variable "public_subnets" {
    type = list
}

variable "private_subnets" {
    type = list
}

variable "tags" {
  type    = map(string)
  default = {}
}