"""
This package contains the Python modules used by the LOFAR Transients Pipeline
(TraP). This includes:

- Pipeline configuration management;
- Task distribution;
- Image loading and quality control;
- Source detection and measurement;
- Storing and associating sources in the database.

For details, see http://docs.transientskp.org/.
"""
import pkg_resources

try:
    __version__ = pkg_resources.require("tkp")[0].version
except pkg_resources.DistributionNotFound:
    __version__ = "4.0"
