#--------------------------
#ACMモジュールのバージョン管理
#--------------------------
#cloudfront用のACM証明書はバージニアリージョンで発行するため、プロバイダを切り替えるための設定を追加した
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
