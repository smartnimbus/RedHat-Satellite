# GitLab Best Practices for IaC & CaC

This repository provides knowledge, standards, and best practices for GitLab usage in **Infrastructure as Code (IaC)** and **Configuration as Code (CaC)** projects. It includes key practices for Pipelines, Runners, Shared Repositories, Modules, Repo and Branching Strategies, and Secret Management.

## Folder Structure Overview

- **GitLab-Pipeline/**: Best practices, standards, and examples for creating and optimizing GitLab pipelines.
- **GitLab-Runner/**: Best practices for setting up and managing GitLab Runners.
- **Repo-Strategies/**: Guidance on structuring repositories for different environments, governance, and reducing blast radius.
- **Branching-Strategies/**: Standards and practices for setting up branch strategies to ensure segregation of duties and minimize risk.
- **Shared-Code/**: Reusable code modules for Terraform and Ansible, including examples and troubleshooting.
- **Secret-Management/**: Standards and best practices for securely managing secrets in GitLab pipelines.
- **How-To/**: Step-by-step instructions for common GitLab operations like merging branches, managing repositories, and resolving conflicts.

---

## Key Best Practices

### GitLab Pipeline Best Practices
- Use **YAML Anchors** to reduce code duplication.
- Implement **parallel jobs** for faster pipeline execution.
- Use **stages** to define the flow of your pipeline (build, test, deploy).
- Follow a **Fail Fast** approach with well-defined testing phases.
- Secure your pipeline with **secret management**.

### Repo Strategy Best Practices
- Favor **multiple repos** for different environments (e.g., dev, prod).
- Ensure **proper RBAC governance** is applied at the lowest possible level.
- Define **clear segregation of duties** to reduce blast radius.
- Centralize common reusable code (e.g., TF Modules, Ansible Roles).

---

## Step-by-Step Guides

- [Merging Between Repositories](How-To/merge_between_repos.md)
- [Merging Between Branches](How-To/merge_between_branches.md)
- [Managing Secrets in GitLab CI/CD](Secret-Management/secrets_in_ci_cd.md)

---

## Repo and Branching Decision Records

Decision records are available under the **Repo-Strategies/decisions/** and **Branching-Strategies/decisions/** directories. Each document covers:
- **Requirements Statement**
- **Available Options**
- **Recommendation**
- **Decision**
- **Justification**
- **Implication**
