![VegBank](http://vegbank.org/vegbank/images/vegbank_logo69x100trans.gif)
![VegBank](http://vegbank.org/vegbank/images/vegbank_caps170x40outline.jpg)


## VegBank

- **Authors**: Last, First (ORCID); ...
- **License**: [Apache 2](http://opensource.org/licenses/Apache-2.0)
- [Package source code on GitHub](https://github.com/NCEAS/vegbank2)
- [**Submit Bugs and feature requests**](https://github.com/NCEAS/vegbank2/issues)
- Contact us: support@dataone.org

The [VegBank](http://vegbank.org) data system provides a community managed data portal for vegetation data, particularly plots, plant taxonomy, and communities.  It is a product of the Ecological Society of America (ESA) Vegetation Panel, and is affiliated with the National Vegetation Classification (USNVC).

VegBank provides a common storage system and web portal for accessing:

- Plot data
- Plant taxonomy data
- Community data

VegBank is an open source, community projects.  We [welcome contributions](./CONTRIBUTING.md) in many forms, including code, graphics, documentation, bug reports, testing, etc.  Use the [DataONE discussions](https://github.com/DataONEorg/dataone/discussions) to discuss these contributions with us.

## Redesign

VegBank was originally designed and implemented in the early 2000's using server technology of the time, particularly as a Java servlet providing access to data that is stored in a backend postgresql database, and using Apache Struts to build a web-based interface for querying and viewing the data.  While the system has served well, most of these technology components have become obsolete, and need to be replaced.  This repository is being used to [redesign VegBank](vegbank2-plans.md), which will be refactored into several standalone components:

- [vegbank-service](.): the VegBank data system and API access service 
- [vegbank-web](): the VegBank web application that accesses the service
- [vegbankr](.): the VegBank R package that accesses the service

### Project deliverables

#### Task 1: Project Planning and Reporting

- D-1.1 Project start-up meeting
- D-1.2 Detailed plan and timeline
- D-1.3 Establish regular, monthly meetings with CDFW
- D-1.4 Progress Reports (Quarterly, January 30, April 30, July 30, October 30)
- D-1.5 Draft and Final Progress Report
    - Draft Report: prior to end of the contract term (01/05/2026)
    - Final Progress Report: Due prior to end of contract term (02/01/2026)

#### Task 2: Improvements to VegBank Data Storage Design

- D-2.1 Refactored data model and design plans
- D-2.2 Deployed and refactored, open-source VegBank
- D-2.3 Publish an open-source R package for VegBank

#### Task 3: California Vegetation Data Upload into VegBank

- D-3.1 Create tool for inducting California vegetation data
- D-3.2 Induct California vegetation survey data into VegBank


## Documentation

Documentation is a work in progress, and can be found ...

## Development build

This is a python package, and built using the [Python Poetry](https://python-poetry.org) build tool.

To install locally, create a virtual environment for python 3.12+, 
install poetry, and then install or build the package with `poetry install` or `poetry build`, respectively.

To run tests, navigate to the root directory and run `poetry run pytest`. If the test suite contains tests that
take a longer time to run (e.g., relating to the storage of large files) - mark them as `slow` and to execute all tests, run
`pytest --run-slow`.

The GitHub repository has also been configured to run a [continuous integration build](https://github.com/NCEAS/vegbank2/actions) which executes the `poetry run pytest` command in the standard poetry-maintained virtual environment. To test the action run locally, you can install the `act` commandline client (e.g., `brew install act`) and then execute the actions from the local commandline. This depends on a local docker instance being configured, and the first run will take longer as the initial docker images are pulled. Thereafter, checking the action build before pushing commits can be run, for example, for the mac with:

- `act --container-architecture linux/amd64`

## Usage Example

```py
from product import Product

# Example code here...

```

## License
```
Copyright [2024] [Regents of the University of California]

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

