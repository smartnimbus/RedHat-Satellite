
# Load the default user data script
data "template_file" "default_userdata" {
  # The path to the default user data script
  template = file("${path.module}/default_userdata.sh")
}
