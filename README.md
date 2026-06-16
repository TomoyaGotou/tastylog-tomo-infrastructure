## tastylog-tomo-infrastructure
　後藤作成の terraform による　AWSインフラ構築リポジトリです。
- LaravelアプリケーションをAWS上で動作させるためのインフラをdev/prodの2環境で管理している。

- 本リポジトリは、Laravel製の食べログ風アプリケーションを題材として、
- AWS上に本番・開発環境をTerraformで構築した学習プロジェクトです。

- 公開ドメインには個人取得ドメイン gotomo-lab.click を利用しています。

- [Laravelアプリケーションリポジトリ](https://github.com/TomoyaGotou/tastylog-tomo-app.git)

### 食べログサイトURL
* 本番環境：https://gotomo-lab.click
* 開発環境：https://dev.gotomo-lab.click

### 使用技術
* Terraform
* AWS ECS Fargate
* AWS RDS MySQL
* AWS ALB
* AWS CloudFront
* AWS WAF
* AWS Route53
* AWS ACM
* AWS CodePipeline
* AWS CodeBuild
* AWS CloudWatch

### 構成
```text
CloudFront
  ↓
WAF
  ↓
ALB
  ↓
ECS Fargate
  ↓
RDS MySQL
```

### 主な機能
* TerraformによるIaC
* dev / prod 環境管理
* GitHub連携によるCI/CD
* CloudFront + WAFによるアクセス制御
* ECS Fargateによるコンテナ運用
* CloudWatchによる監視

### Terraform State管理

Terraform State は AWS S3 バケットで管理しています。

```text
S3 Backend
└── tastylog-tomo-terraform-state
```

### 関連ドキュメント

- [CloudFront + ALB + Laravel URL生成不具合](https://docs.google.com/document/d/1RpTqLKa1qt8gVxgdOfURsgoXc4_92z9stxx2DgKG88k/edit?usp=drive_link)

### 設計資料

- [Terraform設計方針](https://docs.google.com/document/d/1M232RBtb_-XtN_cxNb9_KZwLFJNfdFE8U2dBrKMnLQE/edit?usp=sharing)
- [パラメータシート](https://docs.google.com/spreadsheets/d/1YIZ4AjGhH6x8bDoH70tJwgyxuNQrpL4ajbEnY9nWE4g/edit?usp=sharing)

### セキュリティ

- [セキュリティ対応](https://docs.google.com/document/d/1De7v0sUUWmNMNtgJ2iOeyjUxeSflQeSiFcGOq78RmBE/edit?usp=sharing)

### 障害対応

- [障害調査手順](https://docs.google.com/document/d/1VxNxnVhOepGsuj7djwbpXl1FfITc-gg4cxKJcT-_0IE/edit?usp=sharing)
- [ECS Execによるコンテナ接続](https://docs.google.com/document/d/1hKMdnIgZpUKb_grlfZT7WC1OQl_MNikKS62lGpU-i0A/edit?usp=sharing)

### 運用

- [運用手順](https://docs.google.com/document/d/1IEIYpmqytT7T8EdLLGsay34vg47iIcNR2JJqOHqU7i4/edit?usp=sharing)

### 検証結果

- [CI/CD検証結果](https://docs.google.com/document/d/1z5w4uEqm-nnbHBDIAd4u2XmsB8MWwlpyao8-JXLU7wU/edit?usp=sharing)
- [構築・動作確認結果](https://docs.google.com/document/d/1Ze3OI-ELNGMfegtMpp3irBEiKyz-DVR600VwVGHSR98/edit?usp=sharing)


### 今後実施したい改善項目

- [改善項目一覧](https://docs.google.com/document/d/1KSEl_4KImq9Qq_PHnhbpAYJwnK1Q_LyKXKefhjDLdh4/edit?usp=sharing)

### ディレクトリ構成
```text
envs/
├── dev
└── prod

modules/
├── network
├── security_group
├── alb
├── cloudfront
├── waf
├── fargate
├── rds
├── cloudwatch
└── ...
```