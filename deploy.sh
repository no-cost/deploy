#!/bin/bash
cd "$(dirname "$0")"

# https://docs.ansible.com/ansible/latest/reference_appendices/config.html#envvar-ANSIBLE_HOST_KEY_CHECKING
export ANSIBLE_HOST_KEY_CHECKING=False

# https://docs.ansible.com/ansible/latest/reference_appendices/config.html#envvar-ANSIBLE_PIPELINING
export ANSIBLE_PIPELINING=True


if [ ! -f ~/.ssh/id_rsa ]; then
    echo "SSH key 'id_rsa' not found!"
    read -p "Do you want to continue? You should copy the key from the old server. This will generate new 'id_rsa' in Ansible later (y/n) " -n 1 -r
fi

if [ ! -f ~/.ssh/ansible_vault_password ]; then
    echo "'~/.ssh/ansible_vault_password' not found! Please, create it so that 'secrets.yml' can be decrypted."
    exit 1
fi


ansible-playbook playbooks/main.yml --user root --verbose --extra-vars @secrets.yml --vault-password-file="~/.ssh/ansible_vault_password" --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 $@
