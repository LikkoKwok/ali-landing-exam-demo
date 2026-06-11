variable "environment"      { type = string }
variable "vpc_cidr"         { type = string }
variable "az_count"         { type = number, default = 2 }
variable "transit_router"   { type = string }
variable "cen_id"           { type = string, default = "" }
variable "kms_key_id"       { type = string }
variable "db_instance_class" { type = string, default = "rds.mssql.s2.large" }
variable "db_storage_gb"    { type = number, default = 50 }
variable "tags"             { type = map(string), default = {} }
