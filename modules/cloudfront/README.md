# ALB Module

## 概要

Application Load Balancer (ALB) を作成し、HTTPS通信の終端およびECS Fargateへの負荷分散を行うモジュールです。

## 作成リソース

- Application Load Balancer
- Target Group
- Health Check
- HTTPS Listener
- HTTP Listener


## 入力変数

| 変数名 | 説明 |
|---------|---------|
| project | プロジェクト名 |
| environment | 環境名(dev/prod) |
| vpc_id | VPC ID |
| alb_sg_id | ALB用セキュリティグループID |
| public_subnet_ids | Public Subnet ID一覧 |
| acm_certificate_arn | ACM証明書ARN |

## 出力値

| Output | 説明 |
|---------|---------|
| alb_id | ALB ID |
| alb_arn | ALB ARN |
| alb_dns_name | ALB DNS名 |
| alb_zone_id | ALB Hosted Zone ID |
| target_group_arn | Target Group ARN |

## ヘルスチェック

| 項目 | 値 |
|---------|---------|
| Path | /health |
| Protocol | HTTP |
| Success Code | 200 |
| Interval | 10秒 |
| Timeout | 5秒 |
| Healthy Threshold | 2 |
| Unhealthy Threshold | 2 |

ALBは `/health` に対してHTTPリクエストを送信し、HTTPステータスコード `200` が返却された場合に正常と判定します。


## 備考

- CloudFrontからのHTTPSリクエストを受信
- ACM証明書を利用してSSL/TLS通信を提供
- HTTP(80)アクセスはHTTPS(443)へリダイレクト
- ECS FargateをTarget GroupへIPターゲットとして登録
- SSL Policyは `ELBSecurityPolicy-TLS13-1-2-2021-06` を利用
- Deregistration Delayは60秒に設定