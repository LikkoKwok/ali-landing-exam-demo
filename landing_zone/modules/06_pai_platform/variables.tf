variable "environment"       { type = string }
variable "gpu_instance_type" { type = string }
variable "vpc_cidr"          { type = string }
variable "kms_key_id"        { type = string }
variable "gpu_max_nodes"     { 
    type = number
    default = 4 
    }

variable "tags"              { 
    type = map(string)
    default = {} 
    }
