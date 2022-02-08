import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('client')


def test_client_config(host):
    config1 = host.file("/etc/bareos/bareos-fd.d/client/myself.conf")
    config2 = host.file("/etc/bareos/bareos-fd.d/director/bareos-dir.conf")
    assert config1.contains("Maximum Bandwidth Per Job")
    assert config2.contains("md5")


def test_client_process(host):
    fdsrv = host.service("bareos-fd")
    assert fdsrv.is_running
    assert fdsrv.is_enabled
