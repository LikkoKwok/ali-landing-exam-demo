provider "alicloud" {
  alias  = "master"
  region = var.region
}

provider "alicloud" {
  alias  = "singapore"
  region = var.secondary_region
}

provider "alicloud" {
  alias  = "hub"
  region = var.region
  assume_role {
    role_arn = "acs:ram::${var.hub_account_id}:role/ResourceDirectoryAccountAccessRole"
  }
}

provider "alicloud" {
  alias  = "log"
  region = var.region
  assume_role {
    role_arn = "acs:ram::${var.log_account_id}:role/ResourceDirectoryAccountAccessRole"
  }
}

provider "alicloud" {
  alias  = "app"
  region = var.region
  assume_role {
    role_arn = "acs:ram::${var.app_account_id}:role/ResourceDirectoryAccountAccessRole"
  }
}

provider "alicloud" {
  alias  = "ai"
  region = var.region
  assume_role {
    role_arn = "acs:ram::${var.ai_account_id}:role/ResourceDirectoryAccountAccessRole"
  }
}
