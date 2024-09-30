resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "handson-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "handson"
  }
}

resource "aws_eip" "nat-gateway-1a" {
  domain = "vpc"

  tags = {
    Name = "handson"
  }
}

resource "aws_nat_gateway" "nat-gateway-1a" {
  subnet_id = aws_subnet.public-subnet-1a.id
  allocation_id = aws_eip.nat-gateway-1a.id

  tags = {
    Name = "handson-1a"
  }
}

resource "aws_eip" "nat-gateway-1c" {
  domain = "vpc"

  tags = {
    Name = "handson-1c"
  }
}

resource "aws_nat_gateway" "nat-gateway-1c" {
  subnet_id = aws_subnet.public-subnet-1c.id
  allocation_id = aws_eip.nat-gateway-1c.id

  tags = {
    Name = "handson-1c"
  }
}

resource "aws_eip" "nat-gateway-1d" {
  domain = "vpc"

  tags = {
    Name = "handson-1d"
  }
}

resource "aws_nat_gateway" "nat-gateway-1d" {
  subnet_id = aws_subnet.public-subnet-1d.id
  allocation_id = aws_eip.nat-gateway-1d.id

  tags = {
    Name = "handson-1d"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "handson-public"
  }
}

resource "aws_route" "public-route" {
  route_table_id = aws_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public-subnet-1a" {
  subnet_id = aws_subnet.public-subnet-1a.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-subnet-1c" {
  subnet_id = aws_subnet.public-subnet-1c.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-subnet-1d" {
  subnet_id = aws_subnet.public-subnet-1d.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table" "private-route-table-1a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "handson-private-1a"
  }
}

resource "aws_route_table" "private-route-table-1c" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "handson-private-1c"
  }
}

resource "aws_route_table" "private-route-table-1d" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "handson-private-1d"
  }
}

resource "aws_route" "private-route-1a" {
  route_table_id = aws_route_table.private-route-table-1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat-gateway-1a.id
}

resource "aws_route" "private-route-1c" {   
  route_table_id = aws_route_table.private-route-table-1c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat-gateway-1c.id
}

resource "aws_route" "private-route-1d" {
  route_table_id = aws_route_table.private-route-table-1d.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat-gateway-1d.id
}

resource "aws_route_table_association" "private-subnet-1a" {
  subnet_id = aws_subnet.private-subnet-1a.id
  route_table_id = aws_route_table.private-route-table-1a.id
}

resource "aws_route_table_association" "private-subnet-1c" {
  subnet_id = aws_subnet.private-subnet-1c.id
  route_table_id = aws_route_table.private-route-table-1c.id
}

resource "aws_route_table_association" "private-subnet-1d" {
  subnet_id = aws_subnet.private-subnet-1d.id
  route_table_id = aws_route_table.private-route-table-1d.id
}
