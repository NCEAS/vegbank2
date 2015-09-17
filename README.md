![VegBank](http://vegbank.org/vegbank/images/vegbank_logo69x100trans.gif)
![VegBank](http://vegbank.org/vegbank/images/vegbank_caps170x40outline.jpg)

# VegBank
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
