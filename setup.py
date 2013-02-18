#!/usr/bin/env python

import os
from distutils.core import setup
from distutils.command.install import INSTALL_SCHEMES


trap_scripts = [
    "trap/bin/trap-manage.py",
    "trap/bin/trap-local.py",
    "trap/bin/trap-run.py",
    "trap/bin/trap-inject.py",
]

tkp_scripts = [
    "tkp/bin/pyse.py",
    ]

def fullsplit(path, result=None):
    """
    Split a pathname into components (the opposite of os.path.join) in a
    platform-neutral way.
    """
    if result is None:
        result = []
    head, tail = os.path.split(path)
    if head == '':
        return [tail] + result
    if head == path:
        return result
    return fullsplit(head, [tail] + result)

# Tell distutils not to put the data_files in platform-specific installation
# locations. See here for an explanation:
# http://groups.google.com/group/comp.lang.python/browse_thread/thread/35ec7b2fed36eaec/2105ee4d9e8042cb
for scheme in INSTALL_SCHEMES.values():
    scheme['data'] = scheme['purelib']

trap_packages, tkp_packages, trap_data_files = [], [], []
root_dir = os.path.dirname(__file__)
if root_dir != '':
    os.chdir(root_dir)
    for dirpath, dirnames, filenames in os.walk('trap'):
        # Ignore dirnames that start with '.'
        for i, dirname in enumerate(dirnames):
            if dirname.startswith('.'): del dirnames[i]
        if '__init__.py' in filenames:
            trap_packages.append('.'.join(fullsplit(dirpath)))
        elif filenames:
            trap_data_files.append([dirpath, [os.path.join(dirpath, f) for f in filenames]])

    for dirpath, dirnames, filenames in os.walk('tkp'):
        # Ignore dirnames that start with '.'
        for i, dirname in enumerate(dirnames):
            if dirname.startswith('.'): del dirnames[i]
        if '__init__.py' in filenames:
            tkp_packages.append('.'.join(fullsplit(dirpath)))

setup(
    name = "trap",
    version = "0.1",
    packages = trap_packages,
    data_files = trap_data_files,
    scripts = trap_scripts,
    description = "LOFAR TRAnsients Pipeline (TRAP)",
    author = "TKP Discovery WG",
    author_email = "discovery@transientskp.org",
    url = "http://www.transientskp.org/",
)

setup(
    name = "tkp",
    version = "0.1",
    packages = tkp_packages,
    scripts = tkp_scripts,
    description = "LOFAR Transients Key Project (TKP)",
    author = "TKP Discovery WG",
    author_email = "discovery@transientskp.org",
    url = "http://www.transientskp.org/",
    )


# use numpy to compile fortran stuff into python module
from numpy.distutils.core import setup, Extension
setup(
  name="deconv",
  version="1.0",
  ext_modules = [Extension( 'deconv', ['external/deconv/deconv.f'] )],
)
