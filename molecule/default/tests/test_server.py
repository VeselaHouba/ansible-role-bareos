import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('server')


def test_check_bareos_client(host):
    with host.sudo('postgres'):
        cmd = "psql bareos -c 'select jobstatus from job where jobid=1'"
        jobstat = host.run(cmd)
        assert jobstat.rc == 0
        assert 'T' in jobstat.stdout
