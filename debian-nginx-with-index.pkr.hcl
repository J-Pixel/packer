variable "iam_token" {
    default = env("OAUTH_TOKEN")
}

source "yandex" "debian-nginx" {
  token               = "iam_token"        #from enviroment $OAUTH_TOKEN, .variables.pkrvars.hcl, or clear-text
  folder_id           = "b1g8dggeakajd96af6a4"
  source_image_family = "debian-9"
  ssh_username        = "debian"              #see it from username on actual vmd eployment of this image  
  use_ipv4_nat        = "true"
  image_description   = "my custom debian 9 with nginx with welcome page and ip"
  image_family        = "debian-9-webserver"
  image_name          = "my-debian-nginx"
  subnet_id           = "e9b41e2f9l88rmpfv38k"
  disk_type           = "network-ssd"
  zone                = "ru-central1-a"
}

build {
  sources = ["source.yandex.debian-nginx"]   

#install nginx and customization of index page
  provisioner "shell" {
    inline = ["sudo apt-get update -y",
              "sudo apt-get install -y nginx",
              "sudo /bin/bash -c 'source /etc/os-release; echo "now editing index"; sed -i "s/Welcome to nginx/It is $(hostname) on $PRETTY_NAME ip address's are $(hostname -I)/" /var/www/html/index.nginx-debian.html'",
              "sudo systemctl enable nginx.service"]

  }
}
