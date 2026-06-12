variable "environment" { type = string }

variable "project_budgets" {
  description = "Per-AI-project monthly budget caps"
  type = map(object({
    amount = number
  }))
  default = {
    claims    = { amount = 5000 }
    actuarial = { amount = 8000 }
  }
}

variable "tags" { 
  type = map(string)
  default = {} 
  }
