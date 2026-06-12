resource "alicloud_oss_bucket" "tf_state_bucket" {
  bucket        = "oss-alicloud-sso-demo-tfstate-01" # Must be globally unique across Alibaba Cloud
  storage_class = "Standard"
}

resource "alicloud_oss_bucket_versioning" "tf_state_bucket_versioning" {
  bucket = alicloud_oss_bucket.tf_state_bucket.id
  status = "Enabled" # Protects state history from corruption
}