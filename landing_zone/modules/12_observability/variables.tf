variable "environment"           { type = string }
variable "sls_project"           { type = string }
variable "metric_retention_days" { 
    type = number 
    default = 90 
    }

variable "tags"                  { 
    type = map(string)
    default = {} 
    }
