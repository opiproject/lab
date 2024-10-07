# Ansible Best Practices and Guidelines

=====================================

This files helps you with the guidelines and the best practices that you can follow, when working on the OPI Ansible scripts. Also go through the guidelines stated on contributing for the OPI Lab repository for a general overview and the GitHub process associated with it.

## Table of Contents

---

1. [General Best Practices](#general-best-practices)
2. [Project Structure](#project-structure)
3. [Playbooks](#playbooks)
4. [Code Readability and Style](#code-readability-and-style)
5. [Additional Tips](#additional-tips)

## General Best Practices

---

Always test you code before raising a Pull Request and use version control and follow coding standards. Avoid unnecessary complexity and use Ansible's built-in features.

## Project Structure

---

This shall be updated soon with the new folder structure that we will be implementing.

- **Organize playbooks**: Use a clear directory structure for playbooks and roles.
- **Use top-level playbooks**: Create top-level playbooks that orchestrate other playbooks, example: site.yml (currently orchestrates all the other playbooks in the repository).
- **Separate configuration and deployment**: Use separate playbooks for configuration and deployment tasks.

## Playbooks

---

- **Use descriptive variable names**: Use clear and descriptive names for variables.
- **Avoid duplicating code**: Try to re-use the same code with different conditional variables like `when` to avoid code duplication.
- **Follow module development guidelines**: Adhere to Ansible's module development best practices.
- **Avoid Ansible-lint errors**: Once you have completed the development of a script, please run `ansible-lint` on your playbook and make sure there are no linting errors.
- **Use native modules**: Prefer native Ansible modules over the `command` module.
- **Avoid complex module options**: Keep module options simple and focused, and always check the official ansible documentation for help on the module options here [Ansible documentation](https://docs.ansible.com/ansible/latest/index.html)

## Code Readability and Style

---

- **Add comments**: Include comments to explain the purpose of tasks and variables.

## Additional Tips

---

- **Use blocks for critical changes**: Use block syntax to enable rollbacks and output data for critical changes.
- **Check and validate**: Use `--check` and `--diff` to validate changes also while running the playbooks on Semaphore before applying them.
