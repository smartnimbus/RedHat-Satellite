# Automating Version Control in GitLab Pipelines

## Overview
Automating version bumps and tagging releases in GitLab CI ensures consistency and minimizes human errors.

### Best Practices
1. **Semantic Versioning in CI/CD:**
   - Automatically increment versions based on the type of changes (features, fixes).
   - Use tags in GitLab for every release.

2. **Automating Terraform Module Versioning:**
   - Create a GitLab CI job to tag releases based on merge events to `main`.

3. **Automating Ansible Role Versioning:**
   - Tag Ansible roles similarly, based on feature completion or bug fixes.

---

## Example: GitLab CI for Terraform Modules

```yaml
stages:
  - validate
  - test
  - release

validate:
  stage: validate
  script:
    - terraform fmt -check
    - terraform validate

test:
  stage: test
  script:
    - terraform plan

release:
  stage: release
  script:
    - git tag v$(date +'%Y%m%d%H%M%S')
    - git push origin --tags
  only:
    - main
```

## Example: GitLab CI for Ansible Roles

```yaml
stages:
  - lint
  - test
  - release

lint:
  stage: lint
  script:
    - ansible-lint playbooks/

test:
  stage: test
  script:
    - ansible-playbook -i inventory.ini playbooks/install_satellite.yml --check

release:
  stage: release
  script:
    - git tag v$(date +'%Y%m%d%H%M%S')
    - git push origin --tags
  only:
    - main

```

By maintaining a structured approach to version control for **Terraform** and **Ansible** modules, you ensure a robust, reliable infrastructure and configuration management practice.

