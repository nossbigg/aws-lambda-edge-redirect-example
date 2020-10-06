provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
  # CHANGEME to own AWS CLI profile
  profile = "nossbigg-personal"
}

provider "aws" {
  alias   = "aws_sg"
  version = "~> 3.0"
  region  = "ap-southeast-1"
  # CHANGEME to own AWS CLI profile
  profile = "nossbigg-personal"
}
