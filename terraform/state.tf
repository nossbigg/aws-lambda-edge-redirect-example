terraform {
  backend "remote" {
    organization = "nossbigg"

    workspaces {
      name = "aws-lambda-edge-redirect-example"
    }
  }
}
