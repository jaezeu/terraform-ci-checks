terraform {
    backend "s3" {
        bucket = "sctp-ce12-tfstate-bucket"
        key    = "terraform-cichecks.tfstate"
        region = "ap-southeast-1"
    }
}