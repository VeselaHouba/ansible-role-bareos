Role Name
=========

Role to setup BareOS server and clients.

# Variables
## Server

Note: More options can be seen in `defaults/main.yml`

- `bareos_install_server` - Install packages valid for server (`false`). Note that this also installs postgresql!
- `bareos_setup_db` - Check if postgresql DB `bareos` exists. If not, create and fill with data (`false`)
- `bareos_sensu_postgres_pass` - Set pass for user sensu to postgresql
- `bareos_director` - If you need to override backup director IP address on your client's /etc/hosts
```
bareos_director:
  ip: 10.0.0.1
  name: backup
```
- `bareos_clients` - List of clients in following format:

```
bareos_clients:
  - name: hostbill
    ansible_delegate_hostname: hostbill
    address: 146.255.58.229
    password: "{{ vault_bareos_hostbill_password }}"
    enable_backup_job: true
    state: present
    autostart: true
    director_ip: 10.8.8.1
    director_name: backup
```

__NOTES:__

- `ansible_delegate_hostname` must match `inventory_hostname` in ansible inventory list.
Some tasks will be delegated from backup server to this client
- `enable_backup_job` - Will create backup job `DefaultJobLinux`
- `state` - When set to `absent`, client will be removed from server config (default: `present`)
- `autostart` - Schedule first backup right away (default: `true`)
- `director_ip` - [Optional] Same as `bareos_director`, just different place to setup
- `director_name` - [Optional] Same as `bareos_director`, just different place to setup


# Client
- `bareos_install_client` - Install packages for client (`false`)


Example Playbook
----------------

```
---
- hosts: bareos-client
  become: true
  roles:
    - { name: bareos, tags: bareos }

- hosts: bareos-server
  become: true
  roles:
    - { name: bareos, tags: bareos }
```

License
-------

BSD

Author Information
------------------

<!-- TODO -->
