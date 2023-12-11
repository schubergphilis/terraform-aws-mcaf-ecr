provider "aws" {
  region = "eu-west-1"
}

module "ecr" {
  source = "../.."

  repository_names = ["image-x", "namespace/image-y"]
}
