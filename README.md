# Terraform module to AWS IAM Role
Criando uma role, com relação de confiaça para uma conta externa. Por exemplo, CloudHealth.

O codigo irá prover os seguintes recursos
* [IAM role](https://www.terraform.io/docs/providers/aws/r/iam_role.html)
* [IAM policy](https://www.terraform.io/docs/providers/aws/r/iam_policy.html)
* [IAM role policy Attachment](https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html)

## Usage
Example de criação usando o module.

```hcl
module "role_account_external" {
    source = "git@gitlab.uoldiveo.intranet:ump/devtools/terraform-aws-modules/terraform-aws-iam_role-account-external.git?ref=v1.2"

    name        = "CompassoUOL-MGMT-Cost"
    description = "CloudHealth Compasso UOL"

    policy  = data.aws_iam_policy_document.policy_doc.json
    path    = "/"
    #force_detach_policies   =
    #max_session_duration    = 

    # Specify accounts that can use this role
    account_id  = "454464851268"
    external_id = "8745c229b2d2f7e2d0b6444b0d390f"

    # Tags
    default_tags = {
        ApplicationRole = "CloudHealth Cost Management"
        Owner           = "COMPASSO UOL"
        Customer        = "PagSeguro"
    }
}

```

Para o `data.aws_iam_policy_document.policy_doc.json` é esperado o bloco com o conteudo das politicas.

Exemplo
```hcl
data "aws_iam_policy_document" "policy_doc" {
    statement {
        sid = "AllowIAM"
        effect = "Allow"
        actions = [
            "iam:List*",
            "iam:Get*",
            "iam:GenerateCredentialReport",
        ]
        resources = [
            "*"
        ]
    }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Variables Inputs
| Name | Description | Required | Type | Default |
| ---- | ----------- | --------- | ---- | ------- |
| name | The name of the role and policy | yes | `string` | `" "` |
| description | The description of the role | yes | `string` | `" "` |
| path | The path to the role. See IAM Identifiers for more information.  | no | `string` | `/` |
| force_detach_policies | Specifies to force detaching any policies the role has before destroying it | no | `bool` | `false` |
| max_session_duration | The maximum session duration (in seconds) that you want to set for the specified role | no | `number` | `3600` |
| account_id | The Account ID External   | yes | `string` | `" "` |
| external_id | The ID external condition for permission | yes | `string` | `" "` |
| default_tags | Key-value mapping of tags for the IAM role | yes | `map(string)` | `{ }` |

## Variable Outputs
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
| Name | Description |
| ---- | ----------- |
| role_arn | The ARN Role created |