import os

import testinfra.utils.ansible_runner
from packaging import version

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_check_bareos_client(host):
    if host.file("/var/lib/postgresql/").exists:
        with host.sudo('postgres'):
            cmd = "psql bareos -c 'select jobstatus from job where jobid=1'"
            jobstat = host.run(cmd)
            assert jobstat.rc == 0
            assert 'T' in jobstat.stdout


def test_bareos_release(host):
    hostvars = host.ansible.get_variables()
    if 'bareos_install_server' in hostvars and ['bareos_install_server']:
        v = host.package("bareos").version
        assert version.parse(v) > version.parse("20")
    else:
        v = host.package("bareos-client").version
        assert version.parse(v) > version.parse("20")
