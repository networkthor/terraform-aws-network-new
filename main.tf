// Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block

  tags = merge({
    Name = "${var.environment}-vpc"
    Type = "production"
  }, var.tags)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = merge({
    Name = "${var.environment}-igw"
    Type = "production"
  }, var.tags)
}

// Create Public Subnets
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnets)

  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = "${var.environment}-public-subnet-${count.index}"
    Type = "production"
  }, var.tags)
}


// Create Private Subnets
resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnets)

  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = "${var.environment}-private-subnet-${count.index}"
    Type = "production"
  }, var.tags)
}

// Create NAT GW
resource "aws_eip" "eip1" {
  tags = merge({
    Name = "${var.environment}-eip1"
    Type = "production"
  }, var.tags)
}

resource "aws_nat_gateway" "natgw1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = merge({
    Name = "${var.environment}-natgw1"
    Type = "production"
  }, var.tags)

  depends_on = [aws_internet_gateway.igw]
}

// Create Route tables
resource "aws_route_table" "public_rt1" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge({
    Name = "${var.environment}-public_rt1"
    Type = "production"
  }, var.tags)
}

resource "aws_route_table" "private_rt1" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw1.id
  }

  tags = merge({
    Name = "${var.environment}-private_rt1"
    Type = "production"
  }, var.tags)
}

resource "aws_route_table_association" "public_rt1_ass1" {
  count = length(var.public_subnets)
   
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt1.id
}

resource "aws_route_table_association" "private_rt1_ass1" {
  count = length(var.private_subnets)
   
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_rt1.id
}
