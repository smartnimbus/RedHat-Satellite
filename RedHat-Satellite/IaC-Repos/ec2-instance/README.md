# EC2 Instance Module with SSM IAM Role and User Data Configuration

This Terraform module manages the creation of an EC2 instance with flexible configurations, including an optional SSM IAM role and custom user data capabilities. The module allows for dynamic management of default and custom user data scripts, and attaches an IAM role for Systems Manager (SSM) access if needed.

## Features

- **EC2 Instance Creation**: Launches an EC2 instance with custom instance settings.
- **SSM IAM Role**: Automatically creates or attaches an existing IAM role for SSM communication.
- **User Data Customization**: Merges a default startup script with user-provided user data.
- **Custom Tagging and Configurations**: Supports custom tags, AMI lookup by region, and other instance properties.

## Usage

### Example `main.tf`

```hcl
module "ec2_instance" {
  source = "./path/to/module"

  name                            = "cbpf-p-euw1-az1-ec2-demo-001"  # "git::https://gitlab.com/......?ref=v1.0.0"
  environment                     = "dev"
  region                          = "us-east-1"
  enable_instance                 = true
  instance_ami                    = "ami-0c55b159cbfafe1f0" # Example AMI ID
  instance_type                   = "t2.micro"
  instance_vpc_security_group_ids = ["sg-0a1b2c3d4e5f6g7h8"]
  instance_subnet_id              = "subnet-0123456789abcdef0"
  instance_user_data              = <<-EOF
    #!/bin/bash
    echo "User-specific script running..."
    # additional commands
  EOF
  tags = {
    Project       = "demo"
  }
}
```


### Variables

| Variable                            | Description                                                                                   | **Default                     |
|-------------------------------------|-----------------------------------------------------------------------------------------------|-----------------------------|
| `region`    | The region where to deploy this code (e.g. us-east-1). | (`default = us-east-1`) |
| `ami`     | Default AMIs by region | (`default = {'us-east-1': 'ami-46c1b650', 'us-west-2': 'ami-50d1d929', 'eu-west-1': 'ami-6e28b517'}`) |
| `environment`     | Environment for service | (`default = STAGE`) |
| `tags`    | A list of tag blocks. Each element should have keys named key, value, and propagate_at_launch. | (`default = {}`) |
| `instance_name`     | Name for AWS EC2 node(s) | (`default = TEST`) |
| `enable_instance`     | Enable instance usage | (`default = true`) |
| `instance_ami`    | Set AMI ID for AWS EC2 instance | (`default = ""`) |
| `instance_launch_template`    | is specified and the Launch Template specifies an instance type. If an instance type is specified in the Launch Template, setting instance_type will override the instance type specified in the Launch Template. Updates to this field will trigger a stop/start of the EC2 instance. | (`default = {}`) |
| `instance_metadata_options`     | (Optional) Customize the metadata options of the instance | (`default = {}`) |
| `instance_availability_zone`    | (Optional) The AZ to start the instance in. | (`default = null`) |
| `instance_type`     | Type of instance t2.micro, m1.xlarge, c1.medium etc | (`default = t2.micro`) |
| `instance_disk_size`    | disk size for EC2 instance | (`default = 8`) |
| `instance_tenancy`    | (Optional) The tenancy of the instance (if the instance is running in a VPC). An instance with a tenancy of dedicated runs on single-tenant hardware. The host tenancy is not supported for the import-instance command. Available values: default, dedicated, host. | (`default = default`) |
| `instance_host_id`    | (Optional) The Id of a dedicated host that the instance will be assigned to. Use when an instance is to be launched on a specific dedicated host. | (`default = null`) |
| `instance_cpu_core_count`     | (Optional) Sets the number of CPU cores for an instance. This option is only supported on creation of instance type that support CPU Options CPU Cores and Threads Per CPU Core Per Instance Type     | specifying this option for unsupported instance types will return an error from the EC2 API. | (`default =  |null`)
| `instance_cpu_threads_per_core`     | (Optional) has no effect unless cpu_core_count is also set) If set to to 1, hyperthreading is disabled on the launched instance. Defaults to 2 if not set. See Optimizing CPU Options for more information. | (`default = 2`) |
| `instance_ebs_optimized`    | (Optional) If true, the launched EC2 instance will be EBS-optimized. Note that if this is not set on an instance type that is optimized by default then this will show as disabled but if the instance type is optimized by default then there is no need to set this and there is no effect to disabling it. See the EBS Optimized section of the AWS User Guide for more information. If true, the launched EC2 instance will be EBS-optimized | (`default = null`) |
| `instance_disable_api_termination`    |  (Optional) If true, enables EC2 Instance Termination Protection | (`default = null`) |
| `instance_initiated_shutdown_behavior`    | (Optional) Shutdown behavior for the instance. Amazon defaults this to stop for EBS-backed instances and terminate for instance-store instances. Cannot be set on instance-store instances. See Shutdown Behavior for more information. | (`default = null`) |
| `instance_key_name`     | (Optional) The key name of the instance | (`default = null`) |
| `instance_get_password_data`    | (Optional) If true, wait for password data to become available and retrieve it. Useful for getting the administrator password for instances running Microsoft Windows. The password data is exported to the password_data attribute. See GetPasswordData for more information. | (`default = null`) |
| `instance_security_groups`    | (Optional, EC2-Classic and default VPC only) A list of security group names (EC2-Classic) or IDs (default VPC) to associate with. | (`default = []`) |
| `instance_associate_public_ip_address`    | (Optional) Associate a public ip address with an instance in a VPC. | (`default = null`) |
| `instance_source_dest_check`    | (Optional) Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs. Defaults true. | (`default = True`) |
| `instance_subnet_id`    | (Optional) The VPC Subnet ID to launch in. | (`default = null`) |
| `instance_vpc_security_group_ids`     | The associated security groups in non-default VPC | (`default = []`) |
| `instance_monitoring`     | (Optional) If true, the launched EC2 instance will have detailed monitoring enabled. If true, the launched EC2 instance will have detailed monitoring enabled | (`default = null`) |
| `instance_user_data`    | (Optional) The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead. | (`default = null`) |
| `instance_user_data_base64`     | (Optional) Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption. | (`default = null`) |
| `instance_user_data_replace_on_change`    | (Optional) When used in combination with user_data or user_data_base64 will trigger a destroy and recreate when set to true. Defaults to false if not set. | (`default = null`) |
| `instance_iam_instance_profile`     | (Optional) The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile. Ensure your credentials have the correct permission to assign the instance profile according to the EC2 documentation, notably iam:PassRole. | (`default = null`) |
| `instance_placement_group`    | (Optional) The Placement Group to start the instance in. | (`default = null`) |
| `instance_placement_partition_number`     | (Optional) The number of the partition the instance is in. Valid only if the aws_placement_group resource's strategy argument is set to 'partition'. | (`default = null`) |
| `instance_private_ip`     | (Optional) Private IP address to associate with the instance in a VPC. | (`default = null`) |
| `instance_ipv6_address_count`     | (Optional) A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet. | (`default = null`) |
| `instance_ipv6_addresses`     | (Optional) Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface | (`default = null`) |
| `instance_volume_tags`    | A mapping of tags to assign to the devices created by the instance at launch time | (`default = {}`) |
| `instance_root_block_device`    | Customize details about the root block device of the instance. See Block Devices below for details | (`default = []`) |
| `instance_ebs_block_device`     | Additional EBS block devices to attach to the instance | (`default = []`) |
| `instance_ephemeral_block_device`     | Customize Ephemeral (also known as Instance Store) volumes on the instance | (`default = []`) |
| `instance_network_interface`    | Customize network interfaces to be attached at instance boot time | (`default = []`) |
| `instance_timeouts`     | Set timeout for EC2 instance | (`default = {}`) |
| `instance_capacity_reservation_specification`     | (Optional) Describes an instance's Capacity Reservation targeting option. | (`default = []`) |
| `instance_credit_specification`     | (Optional) Configuration block for customizing the credit specification of the instance. See Credit Specification below for more details. Terraform will only perform drift detection of its value when present in a configuration. Removing this configuration on existing instances will only stop managing it. It will not change the configuration back to the default for the instance type. | (`default = []`) |
| `instance_enclave_options`    | (Optional) Enable Nitro Enclaves on launched instances. | (`default = {}`) |
| `instance_hibernation`    | (Optional) If true, the launched EC2 instance will support hibernation. | (`default = null`) |
| `instance_secondary_private_ips`    | (Optional) A list of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) in a VPC. Can only be assigned to the primary network interface (eth0) attached at instance creation, not a pre-existing network interface i.e., referenced in a network_interface block. Refer to the Elastic network interfaces documentation to see the maximum number of private IP addresses allowed per instance type. | (`default = null`) |



## IAM Role and SSM Access

This module includes optional IAM role resources to allow EC2 instances to communicate with AWS Systems Manager (SSM). If an existing IAM role with the name `${var.name}-ssm-role` is found, it is used; otherwise, a new role with appropriate permissions is created.

- **IAM Role Creation**: Creates an IAM role if one does not exist.
- **SSM Policy Attachment**: Attaches the `AmazonSSMManagedInstanceCore` policy for SSM actions.

## User Data Configuration

The module loads a default user data script (`default_userdata.sh`), which can be combined with user-provided `instance_user_data`. The `combined_userdata.tpl` file merges these scripts, allowing both default and custom commands to run on instance startup.

### Sample Default User Data Script

In `default_userdata.sh`:
```bash
#!/bin/bash
# Default startup script for all instances
echo "Running default startup script..."
# Default commands
```

### Combining User Data

The combined user data runs both the default and custom commands by merging the `default_userdata.sh` and `instance_user_data` variable contents.

## Outputs

| Output                     | Description                                                                 |
|----------------------------|-----------------------------------------------------------------------------|
| `instance_ids` | ID of the created EC2 instance. |
| `availability_zone` | List of availability zones of instances |
| `key_name` | List of key names of instances |
| `public_dns` | List of public DNS names assigned to the instances. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC |
| `public_ip` | List of public IP addresses assigned to the instances, if applicable |
| `primary_network_interface_id` | List of IDs of the primary network interface of instances |
| `private_dns` | List of private DNS names assigned to the instances. Can only be used inside the Amazon EC2, and only available if you've enabled DNS  |hostnames for your VPC
| `private_ip` | List of private IP addresses assigned to the instances |
| `security_groups` | List of associated security groups of instances |
| `vpc_security_group_ids` | List of associated security groups of instances, if running in non-default VPC |
| `subnet_id` | List of IDs of VPC subnets of instances |
| `tags` | List of tags of instances |
- 
---

## Notes

1. Ensure IAM permissions for creating or attaching the IAM role for SSM.
2. To update the default script in `default_userdata.sh`, change it directly in the module directory.
3. The `templatefile` function merges `default_userdata.sh` with `instance_user_data`, simplifying customizations while preserving the default script.

---













# ec2-instance-rhel9



## Getting started

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.com/IaC-core/terraform/modules/aws/compute/ec2/ec2-instance-rhel9.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://gitlab.com/IaC-core/terraform/modules/aws/compute/ec2/ec2-instance-rhel9/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Set auto-merge](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/index.html)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing (SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thanks to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README

Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
