import os

import testinfra.utils.ansible_runner

import time

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('server')


def test_check_bareos_client_job(host):
    with host.sudo('postgres'):
        cmd = "cd /;psql bareos -c 'select jobstatus from job where jobid=1'"
        jobstat = host.run(cmd)
        assert jobstat.rc == 0
        # Wait until job finishes, max 10 min
        i = 0
        while ('R' in jobstat.stdout) and (i < 60):
            jobstat = host.run(cmd)
            i += 1
            time.sleep(10)
        assert 'T' in jobstat.stdout


def test_check_bareos_console(host):
    c = host.run('curl http://localhost/bareos-webui/')
    assert 'Login form' in c.stdout
