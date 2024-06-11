![VegBank](http://vegbank.org/vegbank/images/vegbank_logo69x100trans.gif)
![VegBank](http://vegbank.org/vegbank/images/vegbank_caps170x40outline.jpg)

The [VegBank](http://vegbank.org) data system provides a community managed data portal for vegetation data, particularly plots, plant taxonomy, and communities.  It is a product of the Ecological Society of America (ESA) Vegetation Panel, and is affiliated with the National Vegetation Classification (USNVC).

VegBank provides a common storage system and web portal for accessing:

- Plot data
- Plant taxonomy data
- Community data

## Redesign

VegBank was originally designed and implemented in the early 2000's using server technology of the time, particularly as a Java servlet providing access to data that is stored in a backend postgresql database, and using Apache Struts to build a web-based interface for querying and viewing the data.  While the system has served well, most of these technology components have become obsolete, and need to be replaced.  This repository is being used to [redesign VegBank](vegbank2-plans.md), which will be refactored into several standalone components:
- VegBank REST API
- VegBank Web UI: Core Features
- VegBank Web UI: Ancillary Features
- VegBank: New features

## Project deliverables

### Task 1: Project Planning and Reporting

- 1.a Project start-up meeting
- 1.b Detailed plan and timeline
- 1.c Establish regular, monthly meetings with CDFW
- 1.d Progress Reports (Quarterly, January 30, April 30, July 30, October 30)
- 1.e Draft and Final Progress Report
    - Draft Report: prior to end of the contract term (01/05/2026)
    - Final Progress Report: Due prior to end of contract term (02/01/2026)

### Task 2: Improvements to VegBank Data Storage Design

- 2.a Refactored data model and design plans
- 2.b Deployed and refactored, open-source VegBank
- 2.c Publish an open-source R package for VegBank

### Task 3: California Vegetation Data Upload into VegBank

- 3.a Create tool for inducting California vegetation data
- 3.b Induct California vegetation survey data into VegBank

