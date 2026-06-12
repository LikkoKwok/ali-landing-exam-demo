variable "vpc_id"           { type = string }
variable "ops_vswitch_id"   { type = string }

variable "instance_type"    {
    type = string
    default = "ecs.g6.large"
    }

variable "image_id"         { 
    type = string
    default = "aliyun_3_x64_20G_alibase_20240528.vhd"
    }

variable "admin_source_cidr" { 
    type = string
    default = "10.0.0.0/8"
    }

variable "tags"             { 
    type = map(string)
    default = {}
    }
