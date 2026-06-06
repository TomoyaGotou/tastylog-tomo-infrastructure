# tastylog-tomo-dev-infrastructure
　後藤作成　terraform構築
- prodとdev
- 本番サイトと開発サイトの作成
- インフラ構築まで

## サイトURL
- 本番（
- 開発（
　
### 監視項目

### 対応方

### terraform管理場所

### 

’’’.
├── README.md
├── .gitignore
├── tastylog_tomo
│   └── /envs
│        ├── dev
│        │   ├── main.tf
│        │   ├── outputs.tf
│        │   └── locals.tf
│        └── prod
│            ├── main.tf
│            ├── outputs.tf
│            └── locals.tf
└── modules/
    ├── /acm
    │   ├── README.md
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── versions.tf
    │   └── variables.tf
    ├── /alb
    │   ├── 
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── /cloudfront
    │   ├── 
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── /ecr
    │   ├── 
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── /fargate
    │   ├── 
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── /iam
    │   ├── 
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── /network
    │   ├── 
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── /rds
    │   ├── 
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── /route53
    │   ├── 
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── /route53_record
    │   ├── README.md
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── /security_group
    │   ├── 
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── /waf
    │   ├── 
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── versions.tf
    │   └── variables.tf
’’’