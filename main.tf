#####################################################################
#
# Data source, build block statement 
# for Assume Role Policy
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
#####################################################################
#
# IAM Role
resource "aws_iam_role" "main" {
    count = var.create ? 1 : 0

    name        = var.name
    path        = var.path
    description = var.description

    assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
    force_detach_policies = var.force_detach_policies
    max_session_duration  = var.max_session_duration

    tags    = var.default_tags
}
#####################################################################
#
# IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "main" {
  count = var.create ? length(var.import_managed_policies) : 0

  role       = aws_iam_role.main.0.id
  policy_arn = lookup(var.import_managed_policies[count.index], "policies_arn", null)
}
#####################################################################
#
# Data source, build block statement 
# for IAM Policy
data "aws_iam_policy_document" "policy_document" {
    count   = var.create ? length(var.iam_policy) : 0

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
#####################################################################
#
# IAM Role Policy
resource "aws_iam_role_policy" "main" {
    count   = var.create ? 1 : 0

    name      = length(var.iam_policy) > 1 || var.use_num_suffix ? format("%s-%d", "${var.name}-Policy", count.index + 1) : "${var.name}-Policy"
    role      = aws_iam_role.main.0.id
    policy    = element(data.aws_iam_policy_document.policy_document[*].json, count.index)
}