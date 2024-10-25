# Version Control for Terraform Modules

## Overview
Version control is crucial for managing Terraform modules, ensuring that environments can reference stable, tested module versions. This practice prevents unexpected changes from breaking infrastructure.

### Best Practices
1. **Semantic Versioning (SemVer):**
   - Follow the [Semantic Versioning 2.0.0](https://semver.org/) standard: `MAJOR.MINOR.PATCH`.
     - **MAJOR**: Incompatible API changes.
     - **MINOR**: Backward-compatible new functionality.
     - **PATCH**: Backward-compatible bug fixes.
   
2. **Tagging Releases:**
   - Use Git tags to manage and reference specific versions of a Terraform module.
   - Every release should be tagged with a version number (e.g., `v1.0.0`, `v1.1.0`, `v2.0.0`).

3. **Module Registry (Optional):**
   - If using a module registry (like Terraform Cloud or GitLab’s Terraform Module Registry), ensure each version of the module is published and can be referenced by version in the configuration.

4. **Module Version Pinning:**
   - Always pin your modules in `main.tf` or `modules.tf` to a specific version.
   - Example:
     ```hcl
     module "vpc" {
       source  = "git::https://gitlab.com/yourgroup/terraform-modules.git//vpc?ref=v1.0.0"
       version = "1.0.0"  # Pinning to a specific version
     }
     ```

5. **Backward Compatibility:**
   - Ensure that module updates are backward compatible to the extent possible.
   - Communicate breaking changes clearly in the release notes (see the **Changelog** section below).

6. **Release Branches:**
   - Use **GitFlow** or a similar branching strategy to control the release process.
   - Feature branches are merged into the `main` branch, and versions are tagged on `main` before release.

7. **Automated Versioning via GitLab CI:**
   - Automate version increments (using tags) based on commit messages or merge events in GitLab CI.

---

## Example Workflow

1. **Developing a New Feature:**
   - Create a feature branch for new functionality or fixes (`feature/new-feature`).
   - Implement the feature and push changes to the feature branch.
   - Once complete, open a merge request to merge into `main`.

2. **Testing:**
   - Test the feature in a staging environment (e.g., with the `dev` or `pre-prod` environment).
   - Ensure backward compatibility by using the feature branch in the relevant Terraform project:
     ```hcl
     module "vpc" {
       source = "git::https://gitlab.com/yourgroup/terraform-modules.git//vpc?ref=feature/new-feature"
     }
     ```

3. **Version Bump and Release:**
   - After testing, merge the feature branch into `main`.
   - Tag the new release based on the changes (e.g., `v1.1.0`).
     ```bash
     git checkout main
     git tag v1.1.0
     git push origin v1.1.0
     ```

4. **Pinning the Module in Environment Configs:**
   - Update the Terraform code for the environment (e.g., `production`) to pin the new version of the module:
     ```hcl
     module "vpc" {
       source  = "git::https://gitlab.com/yourgroup/terraform-modules.git//vpc?ref=v1.1.0"
       version = "1.1.0"
     }
     ```

---

## Changelog

Always maintain a **changelog** for each version release. See [changelog.md](changelog.md) for an example.
