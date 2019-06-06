# HA Infrastructure for Version Control, Artifact Repository, Code Analysis, Cloud Resources

This repo has terraform scripts to deploy infrastructure on AWS which includes 
- Highly Available (HA) Gitlab ( which runs with following AWS resources VPC, Internet-Gateway, Subnet, Security-groups, Route-tables, Jump Boxes, Postgres, Redis, NFS)
- Nexus (Docker Registry, Maven Registry, NPM Registry)
- GitLab CI Runners (Slave machines to run pipeline jobs)
- MySQL RDS (To provide DB for application users)
- IAM users (Users to allow access to AWS resources)
- EC2 instances (Instances running application as docker images)
- S3 buckets (File system storage)

*NOTE: I am still in process of fully automating all the steps, until then please run the steps given below in sequence.*

## Standing up the stack

1. Create IAM user manually which will be used for performing AWS deployments.
2. Copy access key and secret into the provider block in `remote-state/main.tf`.
3. Run `terraform init` (this creates the first initial state file that is only used for standing up the resources that the later TF process will use).
4. Run `terraform plan` and `terraform apply` inside `./remote-state/` to create the DynamoDB table and S3 bucket for state files (Use unique S3 Bucket name). 
5. Manually create AWS key pair (under AWS console/EC2/Network and Security/Key Pairs)which will be used later in process.
6. Navigate to `terraform-scripts/variables.tf` and add default values for *gitlab_postgres_password, rds_password, nexus_docker_password*.
7. Navigate to `./setup`
8. In `step1.sh` add value of S3-bucket-name, DynamoDB-table-name, IAM-access-key, IAM-secret-key and then run `./step1.sh` which will be performing following steps: 
    - Create and setup second state file which will store current tf state in S3 as you go on creating resources using terraform
    - Deploy networking config (VPC, Route-Tables, Internet Gateways, Security Groups, Bastion host-jump box)
9. Run `./step2.sh` to deploy datastore (postgres-9.6.10 and redis-3.2.10) for Gitlab
10. Run `./step3.sh` to deploy NFS for gitlab using `nfs.tf` and `ebs.tf`
11. As a part of good practice we should ensure tunneling from bastion to NFS ec2 instance works. Run `./step4.sh` to setup key to enable ssh after exporting following value in env-vars:
     - $PATH_TO_PEM you created in #5 
12. Run `ssh -A -t centos@$BASTION_EIP ssh centos@$NFS_IP`, where 
    - $BASTION_EIP which was printed as output in #8
    - $NFS_IP which was printed as output in #10
13. Uncomment `iam_instance_profile` in `./legendary-company-infrastructure/nfs.tf` and run `./step5.sh`, which will perform following steps:
    - Install ansible and copy `./ansible/nfs-servers.yml`. We are using ansible to attach ebs volume to aws instance *(We are not using aws_volume_attachment due to https://github.com/hashicorp/terraform/issues/2957)*
    - Install provider for terraform by running: `ansible-galaxy install aloisbarreras.ebs-raid-array,0.1.1 geerlingguy.nfs` followed by creation of  ansible role, IAM role and add assign that role to NFS
14. Run `ssh -A -t centos@bastion_ip ssh centos@nfs_server_private_ip` and once you are logged in, run `df -h` and you will see a directory `/gitlab-data`
15. We are now ready to create AMI which has Gitlab and other dependencies installed, later this AMI will be used to bring up AWS instance which will have Gitlab. Run `./step6.sh` to create AMI after exporting following value in env-vars.
    - $ACCESS_KEY
    - $SECRET_KEY
   We use Hashicorp packer to create this AMI. As part of `step6.sh`, following steps are performed:
    - Install packer
    - Create AMI (which holds gitlab installation) and push it to AWS, so it can be used later to create instance holding Gitlab
16. Update `gitlab_application_ami.default` in `./sprint-2019/variables.tf` with the AMI ID that was just created
17. Now we are ready to finally install Gitlab using AMI created in #15 using packer. Run `./step7.sh`, which will deploy gitlab resources using:
    - launch-configuration.tf
    - autoscaling-groups.tf
    - elb.tf
    - template-file.tf
18. You will now have gitlab up and running in your ec2 instance, to verify go to your elb in AWS  and check for instances in their (you will see
    0/1 instances)
19. Next you will need to seed the Postgres DB with Gitlab server, get the private IP of the EC2 instance running GitLab from the AWS Console and run `./step8.sh` after providing 
    - $BASTION_IP (from #8)
    - $GITLAB_PRIVATE_IP (from #19)
    - $POSTGRES_RDS_ENDPOINT (from #)
   There is a seeding error with gitlab and postgres which has been tackled in step8, here is the issue: https://gitlab.com/gitlab-org/gitlab-ce/issues/56993
20. Update ELB health check to call port 80
21. Next try connecting using ELB DNS and make sure your gitlab instance is up and running
22. Instead of using long and boring DNS address of ELB, we will create a DNS entry. Go to record set and create the record for gitlab and use ELB as Alias in the resources
23. You will have to ssh to gitlab instance and update `external_url 'http://<DNS>.com'` in `gitlab.rb` (vi /etc/gitlab/gitlab.rb).
24. Gitlab should now be access with http using record created in #23 (NOT https).
  In order to allow HTTPS access, follow these steps: 
    - You will need to create certificates for gitlab instance using letsencrypt (https://www.hostfav.com/blog/index.php/2017/07/27/install-lets-encrypt-certificate-on-gitlab-centos-7/)
    - Again repeat #24 but this time update your external URL with `https` and not `http`
  You are all set to run "https://<DNS>.com"
25. Go to Gitlab and create "Personal Access token" from gitlab admin console, this will be used to perform Gitlab-terraform operations like creating users, groups. Update this value in `gitlab.tf`
26. Run `./step9.sh` to create:
    - Gitlab Users and Groups
    - AWS instance running Nexus
27. Manually create another IAM user in AWS for nexus to use in order to create S3 buckets
28. Setup your nexus using the bellow guides, except chose the S3 option when creating the blob stores.  
    https://blog.sonatype.com/using-nexus-3-as-your-repository-part-1-maven-artifacts  
    https://blog.sonatype.com/using-nexus-3-as-your-repository-part-2-npm-packages  
    https://blog.sonatype.com/using-nexus-3-as-your-repository-part-3-docker-images
    
    -   Make sure that the `docker-private` registry allows anonymous pulls
    -   Make sure that the backend cookbook points to the correct maven-group address
29. In the Nexus admin area, go to Security > Realms and enable `Docker Bearer Token Realm` and `npm Bearer Token Realm`
30. Next we will setup Gitlab runner machines to act as slaves to run pipeline jobs. Get the value of Gitlab token and update this value in `./legendary-company-infrastructure/variables` for `gitlab_runner_token.default`
    and run `/step11.sh`, this will create 2 runners and you can setup these runners preferences as per need. 
31. Now you can try to push your examples projects using credentials created in #26
32. In order to create Hosting machine, RDS instance and S3 bucket for applications run `./step12.sh`.

#Steps for future:

- Make this process seamless and take out all shell scripts 
- Automate manual processes to be done via terraform
- Add terraform scripts for sonarQube
- Create modules for different resources so its easier for anyone to pull and perform this installation. 
