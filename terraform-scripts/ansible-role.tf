resource "null_resource" "nfs_server_bootstrap" {
  triggers {
    nfs_server_id = "${aws_instance.nfs_server.id}"
  }

  provisioner "remote-exec" {
    inline = [
      <<EOF
        while [ ! -f /var/lib/cloud/instance/boot-finished ]; do
          echo -e "\033[1;36mWaiting for cloud-init..."
          sleep 1
        done
      EOF
    ,
    ]

    connection {
      user         = "centos"
      host         = "${aws_instance.nfs_server.private_ip}"
      private_key  = "${file(pathexpand(var.ssh_private_key))}"
      bastion_host = "${aws_instance.bastion.public_ip}"
      bastion_user = "centos"
    }
  }

  provisioner "local-exec" {
    command = <<EOF
      ansible-playbook ../ansible/nfs-servers.yml -i "${aws_instance.nfs_server.private_ip}," \
      -e nfs_server_hosts="${aws_instance.nfs_server.private_ip}" \
      -e bastion_user=centos \
      -e bastion_host=${aws_instance.bastion.public_ip} \
      -e instance_id=${aws_instance.nfs_server.id} \
      -e '{ "volumes": ${jsonencode(aws_ebs_volume.gitlab_nfs.*.id)} }' \
      -e '{ "devices": ${jsonencode(local.device_names)} }' \
      -e region=us-east-1 \
      -e cidr=${aws_vpc.legendary-infra.cidr_block}
    EOF
  }
}