import os

import testinfra.utils.ansible_runner
from packaging import version

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('server')


def test_bareos_release(host):
    v = host.package("bareos-client").version
    assert version.parse(v) > version.parse("20")
