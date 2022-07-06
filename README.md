# Bareos

Role to setup BareOS server and clients.

# Variables
## Server

__Note:__ More options can be seen in `defaults/main.yml`

- `bareos_install_server` - Install packages valid for server (`false`). Note that this also installs postgresql!
- `bareos_setup_db` - Check if postgresql DB `bareos` exists. If not, create and fill with data (`false`)
- `bareos_setup_db_sensu` - Creates `sensu` DB user for monitoring (`false`)
- `bareos_sensu_postgres_pass` - Set pass for user sensu to postgresql
- `bareos_email` - Email address used for messages (Daemon, Standard) and Catalog bootstrap
- `bareos_dir_ip_eth` - Director ethernet IP address
- `bareos_director` - If you need to override backup director IP address on your client's /etc/hosts
```
bareos_director:
  ip: 10.0.0.1
  name: backup
```
- `bareos_clients` - List of clients in following format:

```
bareos_clients:
  - name: some-hostname
    ansible_delegate_hostname: some-hostname
    address: 10.1.1.1
    password: MySuperSecretPassword
    enable_backup_job: true
    state: present                      # optional
    autostart: true                     # optional
    director_ip: 10.0.0.1               # optional
    director_name: backup               # optional
    max_job_bandwidth: 1 mb/s           # optional
```

- `bareos_filesets`: List of filesets in following format:

```
bareos_filesets:
  - name: FilesetFoo
    description: "Backup Foo"
    include_file: /home/foo
```

- `bareos_pools`: List of pools in following format:

```
bareos_pools:
  - name: FullFoo
    retention: "365 days"
    max_vol_bytes: 50G
    max_vol: 1000
    label: "FullFoo-"
  - name: IncrementalFoo
    retention: "365 days"
    max_vol_bytes: 50G
    max_vol: 1000
    label: "IncrementalFoo-"
```

`bareos_dir_storage`: List of storages in following format:

```
bareos_dir_storage:
  - name: FileFoo
    device: FileStorageFoo
    bareos_dir_ip: 10.0.0.1
```

`bareos_devices`: List of devices in following format:

```
bareos_devices:
  - name: FileStorageFoo
    arch_device: /backup
```

`bareos_schedules`: List of schedules in following format:

```
bareos_schedules:
- name: ScheduleFoo
  full: "Full on 1 at 02:23"
  incr: "Incremental daily at 02:25"
```

`bareos_jobdefs`: List of jobdefs in following format:

```
bareos_jobdefs:
  - name: JobDefFoo
    level: Incremental
    client: foo-fd
    fileset: FilesetFoo
    schedule: ScheduleFoo
    storage: FileFoo
    pool: IncrementalFoo
    full_pool: FullFoo
    incr_pool: IncrementalFoo
```

`bareos_jobs`: List of jobs in following format:

```
bareos_jobs:
  - name: JobFoo
    jobdef: JobDefFoo
    client: foo-fd
```
__NOTES:__

- `ansible_delegate_hostname` must match `inventory_hostname` in ansible inventory list.
Some tasks will be delegated from backup server to this client
- `enable_backup_job` - Will create backup job `DefaultJobLinux`
- `state` - When set to `absent`, client will be removed from server config (default: `present`)
- `autostart` - Schedule first backup right away (default: `true`)
- `director_ip` - [Optional] Same as `bareos_director`, just different place to setup
- `director_name` - [Optional] Same as `bareos_director`, just different place to setup


## Client
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

# License

GNU GPL

# Author Information

Jan Michalek a.k.a. VeselaHouba
