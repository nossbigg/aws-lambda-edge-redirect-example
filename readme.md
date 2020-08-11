# aws-lambda-edge-redirect-example

This repository is a barebones example of using Terraform to provision an AWS Lambda@Edge deployment that performs a redirect and adds `CloudFront-Viewer-Country` to the redirected URL.

## Prerequisites

### 1. AWS

- AWS CLI 
  - Install CLI: [guide](https://aws.amazon.com/cli/)
  - Configure CLI with API Keys and Profile: [guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
  - Change `provider.profile` in `terraform/provider.tf` to match the name of your own profile

### 2. Terraform

- Terraform CLI
  - Install CLI: [guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)
  - Configure with API Token: [guide](https://www.terraform.io/docs/commands/login.html)
- Terraform Organization + Workspace
  - Create own organization: [guide](https://www.terraform.io/docs/cloud/users-teams-organizations/organizations.html)
  - Update `organization` value in `terraform/state.tf` to own organization name
  - Create workspace with name `aws-lambda-edge-redirect-example`: [guide](https://www.terraform.io/docs/cloud/workspaces/creating.html)
  - Set workspace Execution Mode to `Local`: [guide](https://www.terraform.io/docs/cloud/workspaces/settings.html)

## Usage

- (Optional) You can change the URL to redirect to by changing the `redirectUrl` declared in `lambda_edge_logic/index.js`
- Go to `terraform/` and do `terraform apply` to provision the Lambda@Edge infrastructure
- Use `aws cloudfront list-distributions` to list all existing distributions
- Copy the `Item.DomainName` of the newly-provisioned CloudFront distribution
- Make a request to the URL using a browser
- You should be redirected to a webpage with a `countryCode` query parameter appended to the end of the URL

## References

- [Customizing Content at the Edge with Lambda@Edge - Amazon CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-at-the-edge.html)
- [Setting IAM Permissions and Roles for Lambda@Edge - Amazon CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-edge-permissions.html)
- [lambda_function | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)
- [cloudfront_distribution | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution)
- [AWS Policy Generator](https://awspolicygen.s3.amazonaws.com/policygen.html)