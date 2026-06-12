terraform {
  required_providers {
    alicloud = {
      source                = "aliyun/alicloud"
      configuration_aliases = [alicloud.singapore]
    }
  }
}
