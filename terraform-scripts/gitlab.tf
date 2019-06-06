provider "gitlab" {
  token    = ""
  base_url = "https://<GITLAB-DNS>/api/v4"
}

resource "gitlab_group" "legendary-infra-cookbooks" {
  name        = "legendary-infra-cookbooks"
  path        = "legendary-infra-cookbooks"
  description = "Cookbooks for Legendary Infra Project"
}

resource "gitlab_group" "frontend-cookbooks" {
  name        = "legendary-infra-frontend-cookbooks"
  path        = "legendary-infra-frontend-cookbooks"
  parent_id   = "${gitlab_group.legendary-infra-cookbooks.id}"
  description = "Frontend (Javascript) Examples"
}

resource "gitlab_group" "backend-cookbooks" {
  name        = "legendary-infra-cookbooks"
  path        = "legendary-infra-cookbooks"
  parent_id   = "${gitlab_group.legendary-infra-cookbooks.id}"
  description = "Backend (Java) Examples"
}

resource "gitlab_group" "infrastructre-cookbooks" {
  name        = "legendary-infrastructre-cookbooks"
  path        = "legendary-infrastructre-cookbooks"
  parent_id   = "${gitlab_group.legendary-infra-cookbooks.id}"
  description = "Infrastrucutre (Terraform, Ansible, Packer, AWS)"
}

// Create gitlab-users for legendary-infra
resource "gitlab_user" "testUser" {
  name             = "ABC"
  username         = "testUser"
  password         = ""
  email            = "testUser@gmail.com"
  is_admin         = true
  can_create_group = true
}