# Terraform module to AWS IAM Role
Criando uma role, com relação de confiaça para uma conta externa. Por exemplo, CloudHealth.

O codigo irá prover os seguintes recursos
* [IAM role](https://www.terraform.io/docs/providers/aws/r/iam_role.html)
* [IAM policy](https://www.terraform.io/docs/providers/aws/r/iam_policy.html)
* [IAM role policy Attachment](https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html)

## Usage
Example de uso do module

```hcl
module "iam_role" {
    source = "git@github.com:jslopes8/terraform-aws-iam-roles.git?ref=v1.0"

    name        = "test_role"
    description = "role test "

    assume_role_policy = [
        {
            sid = "1"
            actions = [
                "sts:AssumeRole"
            ]
            principals   = {
                type        = "Service"
                identifiers = [ 
                    "ec2.amazonaws.com"
                ]
            }
        } 
    ]

    # Tags
    default_tags = {
        ApplicationRole = "CloudHealth Cost Management"
        Owner           = "COMPASSO UOL"
        Customer        = "PagSeguro"
    }
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Variables Inputs
| Name | Description | Required | Type | Default |
| ---- | ----------- | -------- | ---- | ------- |
| name | The name of the role and policy | `yes` | `string` | ` ` |
| description | The description of the role | `yes` | `string` | ` ` |
| path | The path to the role. See IAM Identifiers for more information.  | `no` | `string` | `/` |
| force_detach_policies | Specifies to force detaching any policies the role has before destroying it | `no` | `bool` | `false` |
| max_session_duration | The maximum session duration (in seconds) that you want to set for the specified role | `no` | `number` | `3600` |
| assume_role_policy | The policy that grants an entity permission to assume the role. | `yes` | `map` | `[ ]` |
| iam_policy | The policy document. | `yes` | `map` | `[ ]` |
| default_tags | Key-value mapping of tags for the IAM role | yes | `map(string)` | `{ }` |

## Variable Outputs
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
| Name | Description |
| ---- | ----------- |
| role_arn | The ARN Role created |