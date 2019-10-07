data "template_file" "instance_profile" {
  count    = var.enable_cloudwatch_logging ? 1 : 0
  template = file("${path.module}/policies/instance-logging-policy.json")
}

resource "aws_iam_role_policy" "instance" {
  count  = var.enable_cloudwatch_logging ? 1 : 0
  name   = "gitlab-runner-instance-role"
  role   = aws_iam_role.instance.name
  policy = data.template_file.instance_profile[0].rendered
}

resource "aws_cloudwatch_log_group" "environment" {
  count = var.enable_cloudwatch_logging ? 1 : 0
  name  = "gitlab-runner-log-group"

  tags = local.tags
}
