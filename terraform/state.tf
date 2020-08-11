terraform {
  backend "remote" {
    # CHANGEME to own organization
    organization = "nossbigg"

    workspaces {
      name = "aws-lambda-edge-redirect-example"
    }
  }
}
