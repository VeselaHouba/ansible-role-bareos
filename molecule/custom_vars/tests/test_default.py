import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('instance01')


def test_check_bareos_client(host):
    if host.file("/var/lib/postgresql/").exists:
        with host.sudo('postgres'):
            cmd = "psql bareos -c 'select jobstatus from job where jobid=1'"
            jobstat = host.run(cmd)
            assert jobstat.rc == 0
            assert 'T' in jobstat.stdout


def test_check_bareos_console(host):
    c = host.run('curl http://localhost/bareos-webui/')
    assert 'Login form' in c.stdout
