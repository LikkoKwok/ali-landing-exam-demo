output "raw_bucket"     { value = alicloud_oss_bucket.raw_zone.bucket }
output "curated_bucket" { value = alicloud_oss_bucket.curated_zone.bucket }
output "dsc_project"    { value = alicloud_data_works_project.dsc_pipeline.id }
