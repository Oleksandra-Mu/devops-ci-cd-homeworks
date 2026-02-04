locals {
  public  = zipmap(var.availability_zones, var.public_subnets)
  private = zipmap(var.availability_zones, var.private_subnets)
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({
    Name        = var.vpc_name
    Environment = "lesson-5"
  }, var.tags)
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_subnet" "public" {
  for_each = local.public

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge({
    Name = "${var.vpc_name}-public-${each.key}"
  }, var.tags)
}

resource "aws_subnet" "private" {
  for_each = local.private

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = each.key
  map_public_ip_on_launch = false

  tags = merge({
    Name = "${var.vpc_name}-private-${each.key}"
  }, var.tags)
}
