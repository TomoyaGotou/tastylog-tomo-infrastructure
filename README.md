# tastylog-tomo-infrastructure
　後藤作成の terraform による　AWSインフラ構築リポジトリです。
- prodとdev
- 本番サイトと開発サイトの作成
- インフラ構築まで

## サイトURL
- 本番（
- 開発（[testylog-tomo](https://dev.gotomo-lab.click/)）
　
### 監視項目

### 対応方

### terraform管理場所

### 

## ディレクトリ構成

```text
.
├── README.md
├── .gitignore
├── backend
│   ├── main.tf
│   └── .terraform.lock.hcl
├── envs
│   ├── dev
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── locals.tf
│   │   └── outputs.tf
│   └── prod
│       ├── backend.tf
│       ├── main.tf
│       ├── variables.tf
│       ├── locals.tf
│       └── outputs.tf
└── modules
    ├── ACM
    ├── alb
    ├── cloudfront
    ├── cloudwatch
    ├── codebuild
    ├── codepipeline
    ├── ecr
    ├── fargate
    ├── iam
    ├── network
    ├── rds
    ├── Route53
    ├── route53_record
    ├── s3
    ├── security_group
    ├── ssm
    └── waf
```