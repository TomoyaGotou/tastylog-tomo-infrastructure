# ALB Module

## 概要

Amazon ECRリポジトリを作成し、Dockerイメージを管理するモジュールです。

## 作成リソース

- ECR Repository

## 入力変数

| 変数名 | 説明 |
|---------|---------|
| project | プロジェクト名 |
| environment | 環境名(dev/prod) |

## 出力値

| Output | 説明 |
|---------|---------|
| repository_name | ECRリポジトリ名 |
| repository_url | ECRリポジトリURI |
| repository_arn | ECRリポジトリARN |

## 備考

- Dockerイメージの保存先として利用
- CodeBuildでビルドしたイメージをPush
- ECS FargateがイメージをPullしてコンテナを起動