# IAM Module

## 概要

ECS Fargate、CodeBuild、CodePipelineで利用するIAMロールおよびIAMポリシーを作成するモジュールです。

## 作成リソース

- ECS Task Execution Role
- ECS Task Role
- ECS Exec Policy
- CodeBuild Role
- CodeBuild Policy
- CodePipeline Role
- CodePipeline Policy
- SSM Parameter Store Access Policy
- IAM Policy Attachment

## 入力変数

| 変数名 | 説明 |
|---------|---------|
| project | プロジェクト名 |
| environment | 環境名(dev/prod) |

## 出力値

| Output | 説明 |
|---------|---------|
| fargate_task_execution_role_arn | ECSタスク実行ロールARN |
| fargate_task_role_arn | ECSタスクロールARN |
| codebuild_role_arn | CodeBuildロールARN |
| codepipeline_role_arn | CodePipelineロールARN |

## 備考

- ECSタスク実行ロールはECRからのイメージ取得およびCloudWatch Logsへの出力に利用
- ECSタスクロールはECS Exec実行時に利用
- CodeBuildはECR、CloudWatch Logs、SSM Parameter Store、S3へのアクセス権限を保持
- CodePipelineはCodeBuildおよびECSデプロイ実行権限を保持
- ECSタスク起動時にSSM Parameter Storeから設定値を取得可能