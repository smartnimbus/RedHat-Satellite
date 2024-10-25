# Version Control for Ansible Roles

## Overview
Ansible roles and playbooks should be version-controlled to ensure consistent and reproducible deployments. Like Terraform, version control is essential to manage changes and maintain backward compatibility.

### Best Practices
1. **Semantic Versioning (SemVer):**
   - Follow the same **Semantic Versioning** convention for Ansible roles: `MAJOR.MINOR.PATCH`.
   
2. **Tagging and Releasing Roles:**
   - Use Git tags for version control and release management.
   - For every role update, increment the version, and tag the release.

3. **Version Pinning in Playbooks:**
   - In playbooks, reference specific versions of Ansible roles using `git` and tags.

4. **Branching and Feature Development:**
   - Follow a **feature-branch-based** development model.
   - Before merging a feature into `main`, ensure backward compatibility and that tests pass.

5. **Changelog Maintenance:**
   - Keep a changelog for each role to document updates and breaking changes.

---

## Example Workflow

1. **Role Development:**
   - Create a new branch for the role (`feature/new-feature`).
   - Develop and test the role locally and in a test environment.
   - Example:
     ```bash
     git checkout -b feature/add-satellite-configuration
     ansible-playbook playbooks/install_satellite.yml
     ```

2. **Role Version Bump:**
   - After testing, merge the feature branch into `main`.
   - Tag the new release version:
     ```bash
     git tag v1.2.0
     git push origin v1.2.0
     ```

3. **Using Role Versions in Playbooks:**
   - In playbooks, reference the specific role version:
     ```yaml
     - hosts: satellite_servers
       roles:
         - { role: "git@gitlab.com:yourgroup/ansible-roles.git#v1.2.0", name: "satellite" }
     ```

---

## Changelog

See the [changelog.md](changelog.md) file for version-specific changes.
