![VegBank](http://vegbank.org/vegbank/images/vegbank_logo69x100trans.gif)
![VegBank](http://vegbank.org/vegbank/images/vegbank_caps170x40outline.jpg)


## VegBank

- **License**: [Apache 2](http://opensource.org/licenses/Apache-2.0)
- [Package source code on GitHub](https://github.com/NCEAS/vegbank2)
- [**Submit Bugs and feature requests**](https://github.com/NCEAS/vegbank2/issues)
- Contact us: help@vegbank.org

The [VegBank](http://vegbank.org) data system provides a community managed data portal for
vegetation plot data, with special emphasis on supporting the U.S. National Vegetation
Classification (USNVC) and validating standard USNVC vegetation types. VegBank is a product of the
Ecological Society of America (ESA) [Panel on Vegetation Classification](https://esa.org/vegpanel/)
and is maintained and operated by the [National Center for Ecological Analysis and
Synthesis](https://www.nceas.ucsb.edu) (NCEAS).

VegBank provides a common storage system and services for accessing:

- Plot data
- Plant taxonomy data
- Community data

VegBank is an open source, community project. We [welcome contributions](./CONTRIBUTING.md) in many
forms, including code, graphics, documentation, bug reports, testing, etc. Use the [VegBank
discussions](https://github.com/NCEAS/vegbank2/discussions) to discuss these contributions with us.

## Redesign

VegBank was originally [designed and implemented](https://github.com/NCEAS/vegbank) in the early
2000's using server technology of the time, particularly as a Java servlet providing access to data
that is stored in a backend postgresql database, and using Apache Struts to build a web-based
interface for querying and viewing the data. While the system has served well, most of these
technology components have become obsolete, and need to be replaced.

As part of the [VegBank redesign effort](vegbank2-plans.md), the original monolithic system has been
refactored into multiple standalone components:

- [vegbank-service](.): the VegBank data storage system and REST API (this repository)
- [vegbankr](https://github.com/NCEAS/vegbankr): the VegBank R package that accesses the service
- [vegbank-web](https://github.com/NCEAS/vegbank-web): the VegBank web application that accesses the service

## VegBank REST API

> [!WARNING]
> The API service is currently in beta. Services are likely to go up and down, features are subject
> to change, and the returned data do not necessarily reflect the current production VegBank system.

The VegBank REST API is the primary interface for interacting with the data system. While this
repository contains the service's source code, most users will interact with the production instance
hosted and maintained by NCEAS. The API provides a programmatic way to search and retrieve
vegetation plot records, plant concepts, community types, and other supporting information, as well
as submit and upload new data to the archive.

- **Comprehensive API documentation** (WIP): https://nceas.github.io/vegbank2/api/
- **Development API**: https://api-dev.vegbank.org

## Development build

This is a python package, and built using the [Python Poetry](https://python-poetry.org) build tool.

To install locally, create a virtual environment for python 3.12+, install poetry, and then install
or build the package with `poetry install` or `poetry build`, respectively.

To run tests, navigate to the root directory and run `poetry run pytest`. If the test suite contains
tests that take a longer time to run (e.g., relating to the storage of large files) - mark them as
`slow` and to execute all tests, run `pytest --run-slow`.

The GitHub repository has also been configured to run a [continuous integration
build](https://github.com/NCEAS/vegbank2/actions) which executes the `poetry run pytest` command in
the standard poetry-maintained virtual environment. To test the action run locally, you can install
the `act` commandline client (e.g., `brew install act`) and then execute the actions from the local
commandline. This depends on a local docker instance being configured, and the first run will take
longer as the initial docker images are pulled. Thereafter, checking the action build before pushing
commits can be run, for example, for the mac with:

- `act --container-architecture linux/amd64`

## Current Contributors

- Matthew B. Jones (jones@nceas.ucsb.edu): [ORCID: 0000-0003-0077-4738](https://orcid.org/0000-0003-0077-4738)
- Jim Regetz (regetz@nceas.ucsb.edu): [ORCID: 0009-0008-2666-6229](https://orcid.org/0009-0008-2666-6229)
- Robert Shelton (rshelton@nceas.ucsb.edu)
- Darian Gill (dgill@nceas.ucsb.edu)
- Dou Mok (mok@nceas.ucsb.edu): [ORCID: 0000-0002-6076-8092](https://orcid.org/0000-0002-6076-8092)
- Michael T. Lee
- Robert K. Peet

## Previous Contributors

- Michael D. Jennings
- Dennis Grossman
- Marilyn D. Walker
- Mark Anderson
- Gabriel Farrell
- John Harris
- Chad Berkley

## License
```
Copyright [2026] [Regents of the University of California]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

## Acknowledgements
Work on this package was supported by:

- California Department of Fish and Wildlife
- DataONE Network
- National Center for Ecological Analysis and Synthesis, a Center funded by the University of California, Santa Barbara, and the State of California.
- National Science Foundation

[![nceas_footer](https://www.nceas.ucsb.edu/sites/default/files/2020-03/NCEAS-full%20logo-4C.png)](https://www.nceas.ucsb.edu)

