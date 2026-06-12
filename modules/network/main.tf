#--------------
#VPC Configuration
#--------------
#DNSサポートとDNSホスト名を有効、VPC内のリソースがDNSを使用して通信できるようにするため。
resource "aws_vpc" "vpc" {
  cidr_block                       = var.vpc_cidr_block
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name        = "${var.project}-${var.environment}-vpc"
    project     = var.project
    environment = var.environment
  }
}

#--------------
#Subnet
#--------------
#パブリックサブネットはインターネットアクセスが必要なリソースに使用、プライベートサブネットはインターネットアクセスが不要なリソースに使用。
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_1a_cidr_block
  availability_zone       = var.public_subnet_1a_availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project}-${var.environment}-public-subnet-1a"
    project     = var.project
    environment = var.environment
    type        = "public"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_1c_cidr_block
  availability_zone       = var.public_subnet_1c_availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project}-${var.environment}-public-subnet-1c"
    project     = var.project
    environment = var.environment
    type        = "public"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_1a_cidr_block
  availability_zone       = var.private_subnet_1a_availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project}-${var.environment}-private-subnet-1a"
    project     = var.project
    environment = var.environment
    type        = "private"
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_1c_cidr_block
  availability_zone       = var.private_subnet_1c_availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project}-${var.environment}-private-subnet-1c"
    project     = var.project
    environment = var.environment
    type        = "private"
  }
}

#--------------
#route table
#--------------
#パブリックサブネットはインターネットゲートウェイへのルートを持ち、プライベートサブネットはNATゲートウェイへのルートを持つように設定。
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project}-${var.environment}-public-rt"
    project     = var.project
    environment = var.environment
  }
}

resource "aws_route_table_association" "public_rt_1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_1c" {
  subnet_id      = aws_subnet.public_subnet_1c.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt_1a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project}-${var.environment}-private-rt-1a"
    project     = var.project
    environment = var.environment
  }
}

resource "aws_route_table" "private_rt_1c" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project}-${var.environment}-private-rt-1c"
    project     = var.project
    environment = var.environment
  }
}

resource "aws_route_table_association" "private_rt_1a" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.private_rt_1a.id
}

resource "aws_route_table_association" "private_rt_1c" {
  subnet_id      = aws_subnet.private_subnet_1c.id
  route_table_id = aws_route_table.private_rt_1c.id
}


#--------------
#internet gateway
#--------------
#パブリックサブネットのルートテーブルにデフォルトルートを追加。
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project}-${var.environment}-igw"
    project     = var.project
    environment = var.environment
  }
}

#internet gatewayへのルートを追加
resource "aws_route" "public_rt_igw_r" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#--------------
#Nat gateway
#--------------
#プライベートサブネットのルートテーブルにNATゲートウェイへのデフォルトルートを追加。AZごとにNATゲートウェイを配置して冗長性を確保。
resource "aws_eip" "nat_gw_1a" {

  tags = {
    Name        = "${var.project}-${var.environment}-nat-gw-eip"
    project     = var.project
    environment = var.environment
  }
}

resource "aws_eip" "nat_gw_1c" {

  tags = {
    Name        = "${var.project}-${var.environment}-nat-gw-eip"
    project     = var.project
    environment = var.environment
  }
}

resource "aws_nat_gateway" "nat_gw_1a" {
  allocation_id = aws_eip.nat_gw_1a.id
  subnet_id     = aws_subnet.public_subnet_1a.id

  tags = {
    Name        = "${var.project}-${var.environment}-nat-gw-1a"
    project     = var.project
    environment = var.environment
  }
}

resource "aws_nat_gateway" "nat_gw_1c" {
  allocation_id = aws_eip.nat_gw_1c.id
  subnet_id     = aws_subnet.public_subnet_1c.id

  tags = {
    Name        = "${var.project}-${var.environment}-nat-gw-1c"
    project     = var.project
    environment = var.environment
  }
}

#--------------
#Nat Gatway Root
#--------------
resource "aws_route" "private_rt_1a_nat_r" {
  route_table_id         = aws_route_table.private_rt_1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_1a.id
}

resource "aws_route" "private_rt_1c_nat_r" {
  route_table_id         = aws_route_table.private_rt_1c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_1c.id
}

#--------------
#VPC endpoint
#--------------
# natなしの場合、こちらの方が安価
# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id            = aws_vpc.vpc.id
#   service_name      = "com.amazonaws.${var.region}.ecr.api"
#   vpc_endpoint_type = "interface"

#   subnet_ids = [
#     aws_subnet.private_subnet_1a_id,
#     aws_subnet.private_subnet_1c_id
#   ]

#   security_group_ids = [var.vpc_endpoint_sg_id]

#   private_dns_enabled = true

#   tags = {
#     Name        = "${var.project}-${var.environment}-vpce-ecr-api"
#     project     = var.project
#     environment = var.environment
#   }
# }
