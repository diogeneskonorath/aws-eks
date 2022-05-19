resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.dev_cluster.arn

  vpc_config {
    subnet_ids = [var.private_subnet[0], var.private_subnet[1], var.private_subnet[2], var.private_subnet[3]]
  }

  depends_on = [
    aws_iam_role_policy_attachment.dev-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.dev-AmazonEKSVPCResourceController,
  ]
}

resource "aws_iam_role" "dev_cluster" {
  name = "dev-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "dev-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.dev_cluster.name
}

resource "aws_iam_role_policy_attachment" "dev-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.dev_cluster.name
}