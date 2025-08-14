resource "aws_route53_zone" "vanith_online" {
	name = "vanith.online"
	comment = "Simple private DNS Hosted Zone managed by terraform"
#	private_zone = true
	vpc {
		vpc_id = data.aws_vpc.default.id
	}
	
	
	tags = {
		Name = "vanith.online"
		Environment = "staging"
	}
}

