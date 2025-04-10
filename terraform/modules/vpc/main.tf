resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr, 8, count.index)
  availability_zone       = "${var.region}${var.azs[count.index]}"
  map_public_ip_on_launch = true
  tags = merge(
    {
      Name = "${var.name}-public-${var.azs[count.index]}"
      "kubernetes.io/role/elb" = "1"
    },
    var.cluster_name != "" ? {
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    } : {}
  )
}

resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.cidr, 8, count.index + length(var.azs))
  availability_zone = "${var.region}${var.azs[count.index]}"
  tags = {
    Name = "${var.name}-private-${var.azs[count.index]}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_eip" "nat" {
  count = length(var.azs)
  vpc   = true
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count         = length(var.azs) 
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id 

  tags = {
    Name = "${var.name}-nat-${var.azs[count.index]}"
  }

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" {
  count  = length(var.azs) 
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = {
    Name = "${var.name}-private-rt-${var.azs[count.index]}"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}