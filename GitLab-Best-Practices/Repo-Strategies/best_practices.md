# Managing Branch-Level Permissions in GitLab
This guide explains how to manage permissions at the branch level in GitLab using protected branches.

## Introduction

Branch-level permissions are crucial for maintaining code integrity and controlling access to critical parts of your project. Protected branches in GitLab allow you to define rules for who can push, merge, and perform other actions on specific branches.

## Steps to Grant Permissions on a Branch Level

1. **Navigate to Repository Settings:**

   - Go to your project in GitLab.
   - Click on `Settings` in the left sidebar.
   - In the Settings menu, click on `Repository`.
   - Under the Repository section, click on `Protected Branches`.

3. **Add Protected Branch:**

   - Click on the `Protect` button next to the branch you want to protect.

4. **Set Permissions:**

   - Choose which roles are allowed to push, merge, or force push to the branch.
   - You can specify roles like Developer, Maintainer, Owner, etc.
   - Set rules for who can unprotect the branch.


## Example

Configuration in .gitlab-ci.yml
## Protect the `main` branch
```yaml
protected_branches:
  - name: main
    push_access_levels:
      - Maintainer
      - Owner
    merge_access_levels:
      - Maintainer
      - Owner
    force_push_allowed: false
    unprotect_access_levels:
      - Owner
```
## Explanation:
   - This configuration protects the main branch.
   - Only Maintainers and Owners can push and merge to the main branch.
   - Force push is disabled for everyone.
   - Only Owners can unprotect the branch.
  
By using protected branches and defining clear permissions, you can enhance the security and stability of your GitLab projects.