# ACM Module

## 概要

ALBおよびCloudFrontで利用するACM証明書を作成し、Route53によるDNS検証を実施するモジュールです。

## 作成リソース

- ACM Certificate（東京リージョン）
- ACM Certificate（バージニアリージョン）
- Route53 DNS Validation Record
- ACM Certificate Validation

## 入力変数

| 変数名 | 説明 |
|---------|---------|
| project | プロジェクト名 |
| environment | 環境名(dev/prod) |
| record_domain | 証明書を発行するドメイン名 |
| zone_domain | Route53ホストゾーン名 |

## 出力値

| Output | 説明 |
|---------|---------|
| certificate_arn | ALB用ACM証明書ARN |
| cloudfront_certificate_arn | CloudFront用ACM証明書ARN |

## 備考

- ALB用証明書は東京リージョン(ap-northeast-1)で発行
- CloudFront用証明書はバージニアリージョン(us-east-1)で発行
- DNS検証はRoute53のCNAMEレコードを利用
- 証明書更新時の停止を防ぐため `create_before_destroy` を設定
