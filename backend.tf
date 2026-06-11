terraform {
  backend "oss" {
    bucket = "lz-tfstate-bucket-hk"
    prefix = "landing-zone/state"
    key    = "terraform.tfstate"
    region = "cn-hongkong"        # data residency
  }
}
