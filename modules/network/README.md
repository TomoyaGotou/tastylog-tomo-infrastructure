# Network Module

## 概要

VPC、サブネット、ルートテーブル、インターネットゲートウェイ、NAT Gatewayを作成するモジュール。
Public Subnet と Private Subnet を 2AZ に配置し、AZ冗長構成としています。

## 作成リソース

- VPC
- Public Subnet 1a / 1c
- Private Subnet 1a / 1c
- Route Table
- Internet Gateway
- NAT Gateway
- Elastic IP

## ルーティング

| サブネット | ルート |
|---|---|
| Public Subnet | 0.0.0.0/0 → Internet Gateway |
| Private Subnet 1a | 0.0.0.0/0 → NAT Gateway 1a |
| Private Subnet 1c | 0.0.0.0/0 → NAT Gateway 1c |

## 入力変数

| 変数名 | 説明 |
|---------|---------|
| project | プロジェクト名 |
| environment | 環境名(dev/prod) |
| region | AWSリージョン |
| vpc_cidr_block | VPCのCIDRブロック |
| public_subnet_1a_cidr_block | Public Subnet(1a)のCIDR |
| public_subnet_1c_cidr_block | Public Subnet(1c)のCIDR |
| private_subnet_1a_cidr_block | Private Subnet(1a)のCIDR |
| private_subnet_1c_cidr_block | Private Subnet(1c)のCIDR |
| public_subnet_1a_availability_zone | Public Subnet(1a)のAZ |
| public_subnet_1c_availability_zone | Public Subnet(1c)のAZ |
| private_subnet_1a_availability_zone | Private Subnet(1a)のAZ |
| private_subnet_1c_availability_zone | Private Subnet(1c)のAZ |

## 出力値

| Output | 説明 |
|---------|---------|
| vpc_id | VPC ID |
| public_subnet_1a_id | Public Subnet(1a) ID |
| public_subnet_1c_id | Public Subnet(1c) ID |
| private_subnet_1a_id | Private Subnet(1a) ID |
| private_subnet_1c_id | Private Subnet(1c) ID |
| public_subnet_ids | Public Subnet ID一覧 |
| private_subnet_ids | Private Subnet ID一覧 |
| public_route_table_id | Public Route Table ID |
| private_route_table_1a_id | Private Route Table(1a) ID |
| private_route_table_1c_id | Private Route Table(1c) ID |
| nat_gateway_1a_id | NAT Gateway(1a) ID |
| nat_gateway_1c_id | NAT Gateway(1c) ID |

## 構成概要

- Public SubnetにALBおよびNAT Gatewayを配置
- Private SubnetにECSおよびRDSを配置
- NAT GatewayをAZごとに配置し冗長化
- Internet Gateway経由でインターネット接続