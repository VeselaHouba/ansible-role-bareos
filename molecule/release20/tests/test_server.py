import os

import testinfra.utils.ansible_runner
from packaging import version

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('server')


def test_check_bareos_job(host):
    with host.sudo('postgres'):
        cmd = "psql bareos -c 'select jobstatus from job where jobid=1'"
        jobstat = host.run(cmd)
        assert jobstat.rc == 0
        assert 'T' in jobstat.stdout


def test_bareos_release(host):
    v = host.package("bareos").version
    assert version.parse(v) > version.parse("20")
