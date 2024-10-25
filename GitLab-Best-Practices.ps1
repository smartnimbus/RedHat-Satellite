# Define the base directory
$baseDir = "\CBL\GitLab-Best-Practices"

# Define the structure
$structure = @(
    "README.md",
    "GitLab-Pipeline/standards.md",
    "GitLab-Pipeline/best_practices.md",
    "GitLab-Pipeline/examples/simple_pipeline.md",
    "GitLab-Pipeline/examples/complex_pipeline.md",
    "GitLab-Pipeline/troubleshooting.md",
    "GitLab-Runner/standards.md",
    "GitLab-Runner/best_practices.md",
    "GitLab-Runner/examples/shared_runner_setup.md",
    "GitLab-Runner/troubleshooting.md",
    "Repo-Strategies/standards.md",
    "Repo-Strategies/best_practices.md",
    "Repo-Strategies/decisions/single_vs_multi_repo.md",
    "Repo-Strategies/decisions/governance_and_rbac.md",
    "Repo-Strategies/decisions/segregation_of_duty.md",
    "Repo-Strategies/examples/single_repo_structure.md",
    "Repo-Strategies/examples/multiple_repo_structure.md",
    "Repo-Strategies/examples/migration_between_repos.md",
    "Branching-Strategies/standards.md",
    "Branching-Strategies/best_practices.md",
    "Branching-Strategies/decisions/branching_governance.md",
    "Branching-Strategies/decisions/reduce_blast_radius.md",
    "Branching-Strategies/examples/feature_branch.md",
    "Branching-Strategies/examples/release_branch.md",
    "Branching-Strategies/examples/hotfix_branch.md",
    "Shared-Code/TF-Modules/standards.md",
    "Shared-Code/TF-Modules/examples/",
    "Shared-Code/TF-Modules/versioning/version_control.md",
    "Shared-Code/TF-Modules/versioning/changelog.md",
    "Shared-Code/TF-Modules/troubleshooting.md",
    "Shared-Code/Ansible-Modules/standards.md",
    "Shared-Code/Ansible-Modules/examples/",
    "Shared-Code/Ansible-Modules/versioning/version_control.md",
    "Shared-Code/Ansible-Modules/versioning/changelog.md",
    "Shared-Code/Ansible-Modules/troubleshooting.md",
    "Secret-Management/standards.md",
    "Secret-Management/best_practices.md",
    "Secret-Management/examples/secrets_in_ci_cd.md",
    "Secret-Management/examples/hashicorp_vault_integration.md",
    "How-To/merge_between_repos.md",
    "How-To/merge_between_branches.md",
    "How-To/troubleshooting_merge_conflicts.md"
)

# Create the base directory
New-Item -Path $baseDir -ItemType Directory -Force

# Create the structure
foreach ($item in $structure) {
    $fullPath = Join-Path -Path $baseDir -ChildPath $item
    if ($item -match "/$") {
        # Create directory
        New-Item -Path $fullPath -ItemType Directory -Force
    } else {
        # Create file and ensure directory exists
        $directory = Split-Path -Path $fullPath -Parent
        if (-not (Test-Path -Path $directory)) {
            New-Item -Path $directory -ItemType Directory -Force
        }
        New-Item -Path $fullPath -ItemType File -Force
    }
}

Write-Host "Folder and file structure created successfully!"
