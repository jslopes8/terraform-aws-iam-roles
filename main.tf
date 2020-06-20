resource "aws_iam_role" "main" {
    
    name        = var.name
    path        = var.path
    description = var.description

    assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
    force_detach_policies = var.force_detach_policies
    max_session_duration  = var.max_session_duration

    tags    = var.default_tags
}

resource "aws_iam_role_policy_attachment" "attach_policy" {

  role       = aws_iam_role.main.id
  policy_arn = aws_iam_policy.policy_document.arn
}

resource "aws_iam_policy" "policy_document" {

    name    = "${var.name}RolePolicy"
    policy  = data.aws_iam_policy_document.policy_document.json
}

data "aws_iam_policy_document" "policy_document" {
    dynamic "statement" {
        for_each = var.iam_policy
        
        content {
            sid         = lookup(statement.value, "sid", null)
            effect      = lookup(statement.value, "effect", null)
            actions     = lookup(statement.value, "actions", null)
            not_actions = lookup(statement.value, "not_actions", null)
            resources   = lookup(statement.value, "resources", null)

        dynamic "condition" {
          for_each = length(keys(lookup(statement.value, "condition", {}))) == 0 ? [] : [lookup(statement.value, "condition", {})]
          content {
            test      = lookup(condition.value, "test", null)
            variable  = lookup(condition.value, "variable", null)
            values    = lookup(condition.value, "values", null)
            
          }
        }

        dynamic "principals" {
          for_each = length(keys(lookup(statement.value, "principals", {}))) == 0 ? [] : [lookup(statement.value, "principals", {})]
          content {
            type        = lookup(principals.value, "type", null)
            identifiers = lookup(principals.value, "identifiers", null)
          }
        }
      }
    }
}
data "aws_iam_policy_document" "assume_role_policy" {
    dynamic "statement" {
        for_each = var.assume_role_policy
        
        content {
            sid         = lookup(statement.value, "sid", null)
            effect      = lookup(statement.value, "effect", null)
            actions     = lookup(statement.value, "actions", null)
            resources   = lookup(statement.value, "resources", null)

        dynamic "condition" {
          for_each = length(keys(lookup(statement.value, "condition", {}))) == 0 ? [] : [lookup(statement.value, "condition", {})]
          content {
            test      = lookup(condition.value, "test", null)
            variable  = lookup(condition.value, "variable", null)
            values    = lookup(condition.value, "values", null)
            
          }
        }

        dynamic "principals" {
          for_each = length(keys(lookup(statement.value, "principals", {}))) == 0 ? [] : [lookup(statement.value, "principals", {})]
          content {
            type        = lookup(principals.value, "type", null)
            identifiers = lookup(principals.value, "identifiers", null)
          }
        }
      }
    }
}