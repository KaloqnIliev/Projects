data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "kube-node" {
  count         = var.counts
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id                   = aws_subnet.kube-sub.id
  vpc_security_group_ids      = [aws_security_group.clust-sg.id]
  key_name                    = aws_key_pair.kube-key.key_name

  user_data = <<-EOF
              #!/bin/bash
              # Update the package index
              sudo apt-get update
              # Update packages required for HTTPS package repository access
              sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release
              # Load br_netfilter module
              sudo modprobe overlay
              sudo modprobe br_netfilter
              # Create /etc/modules-load.d/k8s.conf
              echo -e "overlay\nbr_netfilter" | sudo tee /etc/modules-load.d/k8s.conf
              # Create /etc/sysctl.d/99-kubernetes-cri.conf
              echo -e "net.bridge.bridge-nf-call-iptables  = 1\nnet.ipv4.ip_forward                 = 1\nnet.bridge.bridge-nf-call-ip6tables = 1" | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
              # Apply sysctl params without reboot
              sudo sysctl --system
              # Add Docker’s official GPG key
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
              # Set up the repository
              echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              # Update the package index
              sudo apt-get update
              # Install containerd
              sudo apt-get install -y containerd.io=$CONTAINERD_VERSION
              # Add the Google Cloud packages GPG key
              curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
              # Add the Kubernetes release repository
              sudo add-apt-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
              # Update the package index to include the Kubernetes repository
              sudo apt-get update
              # Install the packages
              sudo apt-get install -y kubeadm=$KUBEADM_VERSION kubelet=$KUBELET_VERSION kubectl=$KUBECTL_VERSION
              # Query kubeadm
              kubeadm
              EOF

  tags = {
    Name = count.index == 0 ? "ControlPlane" : "Workernode${count.index}"
  }
}

