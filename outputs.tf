output "elb_dns" {
  value = "${aws_elb.nazmurelbweb.dns_name}"
}
