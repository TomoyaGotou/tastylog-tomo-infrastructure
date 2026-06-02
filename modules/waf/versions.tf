#--------------------------
#wafのバージョン管理
#--------------------------
#wafはバージニアリージョンで使用、プロバイダを切り替えるための設定を追加した
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      configuration_aliases = [
        aws.virginia
      ]
    }
  }
}
