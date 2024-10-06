resource "aws_subnet" "public-subnet-1a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "handson-public-subnet-1a"
  }
}

resource "aws_subnet" "public-subnet-1c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "handson-public-subnet-1c"
  }
}

resource "aws_subnet" "public-subnet-1d" {  
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-1d"

  tags = {
    Name = "handson-public-subnet-1d"
  }
}

resource "aws_subnet" "private-subnet-1a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "handson-private-subnet-1a"
  }
}

resource "aws_subnet" "private-subnet-1c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.20.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "handson-private-subnet-1c"
  }
}

resource "aws_subnet" "private-subnet-1d" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.30.0/24"
  availability_zone = "ap-northeast-1d"

  tags = {
    Name = "handson-private-subnet-1d"
  }
}
