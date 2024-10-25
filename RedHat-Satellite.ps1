# Define the base directory
$baseDir = "RedHat-Satellite"

# Define the structure
$structure = @(
    "CaC-Repos"
    "IaC-Repos"
    "Platform-Configuration"
    "Platform-Infrastructure"
    "README.md"
    "CaC-Repos/Redhat-Satellite-Configuration"
    "CaC-Repos/Redhat-Satellite-Configuration/ansible"
    "CaC-Repos/Redhat-Satellite-Configuration/ansible/playbooks"
    "CaC-Repos/Redhat-Satellite-Configuration/ansible/roles"
    "CaC-Repos/Redhat-Satellite-Configuration/ansible/templates"
    "CaC-Repos/Redhat-Satellite-Configuration/ansible/inventory.ini"
    "CaC-Repos/Redhat-Satellite-Configuration/ansible/playbooks/install_capsule.yml"
    "CaC-Repos/Redhat-Satellite-Configuration/ansible/playbooks/install_satellite.yml"
    "CaC-Repos/Redhat-Satellite-Configuration/ansible/roles/capsule"
    "CaC-Repos/Redhat-Satellite-Configuration/ansible/roles/satellite"
    "CaC-Repos/Redhat-Satellite-Configuration/ansible/roles/capsule/tasks"
    "CaC-Repos/Redhat-Satellite-Configuration/ansible/roles/capsule/tasks/main.yml"
    "CaC-Repos/Redhat-Satellite-Configuration/ansible/roles/satellite/tasks"
    "CaC-Repos/Redhat-Satellite-Configuration/ansible/roles/satellite/tasks/main.yml"
    "CaC-Repos/Redhat-Satellite-Configuration/ansible/templates/capsule_installation_script.j2"
    "CaC-Repos/Redhat-Satellite-Configuration/ansible/templates/satellite_installation_script.j2"
    "IaC-Repos/packer"
    "IaC-Repos/redhat-ec2-instance"
    "IaC-Repos/RedHat-Satellite-Infrastructure"
    "IaC-Repos/packer/scripts"
    "IaC-Repos/packer/redhat-packer-template.json"
    "IaC-Repos/packer/scripts/harden.sh"
    "IaC-Repos/packer/scripts/install_core_apps.sh"
    "IaC-Repos/redhat-ec2-instance/main.tf"
    "IaC-Repos/redhat-ec2-instance/outputs.tf"
    "IaC-Repos/redhat-ec2-instance/variables.tf"
    "Platform-Configuration/Non-Production"
    "Platform-Configuration/Pre-Production"
    "Platform-Configuration/Production"
    "Platform-Infrastructure/Non-Production"
    "Platform-Infrastructure/Pre-Production"
    "Platform-Infrastructure/Production"
    "Platform-Infrastructure/Non-Production/userdata"
    "Platform-Infrastructure/Non-Production/backend.tf"
    "Platform-Infrastructure/Non-Production/compute.tf"
    "Platform-Infrastructure/Non-Production/main.tf"
    "Platform-Infrastructure/Non-Production/network.tf"
    "Platform-Infrastructure/Non-Production/outputs.tf"
    "Platform-Infrastructure/Non-Production/provider.tf"
    "Platform-Infrastructure/Non-Production/variables.tf"
    "Platform-Infrastructure/Non-Production/userdata/satellite_userdata.sh"
)

# Create the base directory
New-Item -Path $baseDir -ItemType Directory -Force

# Create the base directory
New-Item -Path $baseDir -ItemType Directory -Force

foreach ($item in $structure) {
    $fullPath = Join-Path -Path $baseDir -ChildPath $item

    # Check if the item has an extension (meaning it's a file)
    if ($item -match "\.[^\\]+$") { 
        # Create file and ensure directory exists
        $directory = Split-Path -Path $fullPath -Parent
        if (-not (Test-Path -Path $directory)) { 
            New-Item -Path $directory -ItemType Directory -Force 
        }
        New-Item -Path $fullPath -ItemType File -Force
    } else {
        # Create directory
        New-Item -Path $fullPath -ItemType Directory -Force
    }
}

Write-Host "Folder and file structure created successfully!"



