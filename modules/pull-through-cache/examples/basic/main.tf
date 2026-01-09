module "ecr_pull_through_cache" {
  source                            = "../pull-through-cache"
  create_registry_policy            = true
  ecr_creation_template_role_arn    = "arn:aws:iam::123456789012:role/rolename"
  ecr_readonly_principals           = ["1234567890"]
  kms_key_arn                       = "arn:aws:kms:us-west-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
  registry_pull_through_cache_rules = {ecrpub = {
    ecr_repository_prefix = "ecr-public"
    upstream_registry_url = "public.ecr.aws"
    }
  }
