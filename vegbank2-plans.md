![VegBank](http://vegbank.org/vegbank/images/vegbank_logo69x100trans.gif)

![VegBank](http://vegbank.org/vegbank/images/vegbank_caps170x40outline.jpg)

# VegBank Redesign

The objectives of this project are to:

1) Vegbank Improvements: provide an efficient means of inducting vegetation community data from California and Nationally into VegBank in the future
2) Load California Data: Induct all existing California vegetation community data as identified by CDFW into VegBank
3) Update vocabularies: review extant data in VegBank and update the community assignments and plant taxonomy to be consistent with current standards.

The redesign will serve several goals, primarily to improve maintainability and secondarily to add critical new features to support the objectives above.  For maintainability, we plan to modernize the VegBank technology components, remove obsolete frameworks, and better modularize the system so that the web-based client is independent of the backend data store. This separation of the user interface from the data storage systems will make it easier in the future to upgrade the web interface as standards change without refactoring the storage subsystems.  In addition, we propose several new features that can help make VegBank a critical part of the infrastructure for California and national vegetation science.

## Personnel estimate

The below task breakdown represents an extremely rough personnel estimate. Actual work would be conducted on a level-of-effort basis, meaning that we will fund and deploy a certain level of effort, and will work through the prioritized set of tasks as best as we can. Some contingency has been built in (40%), but significant delays or complications from the historical code could cause time delays.

Currently, the total project development effort is estimated at 162 person weeks for software development. This does not include data cleaning and loading of specific datasets, which will need to be estimated as well. The budget I shared has budgeted 208 weeks of software development FTE over 2 years. Personnel in this estimate would include the following roles:

- Software developers at NCEAS (TBD)
- Systems administrator at NCEAS (Outin)
- Project coordinator at NCEAS (TBD)
- Project lead at NCEAS (Jones)
- NVC liasion / vegetation science consultant (Lee?)
- Data Science analyst at NCEAS (TBD)

## Objective 1: VegBank Software Improvements

This proposal structures work in five task phases, each of which builds upon the previous. Some work, such as the Task 2 user interface work, can start and be accomplished in parallel with previous task phases.

- Task 1.1: VegBank Storage Service and API
- Task 1.2: VegBank Web UI: Core Features
- Task 1.3: VegBank R client
- Task 1.4: VegBank Web UI: Ancillary Features
- Task 1.5: VegBank: New features
- Task 1.6: Maintenance and operations

### Task 1.1: Design planning and Storage Service and API

This phase creates an upgraded postgres database using the current VegBank data model, and deploys it on an updated operating system, and with a newly designed REST API that provides a service access layer to both download and upload all data within the system.  To the extent possible, this storage service will implement an API that is compatible with the [DataONE REST API](https://purl.dataone.org/architecture/apis/MN_APIs.html), to enable VegBank to become a member of the larger DataONE federation of data repositories. At the end of Phase I, the core VegBank data store will be a standalone service that can be directly accessed by both the Phase II web application and other client tools, such as commmand line browsers such as `curl` and scripting languages such as `R` and `python`.  This system should be smaller and more maintainable than any web application that relies on it, and will be designed for maintainability.

| Task# | Description                                                | Weeks | Notes |
|-------|------------------------------------------------------------|-------|-------|
| 1     | Spinup on existing codebase and data model                 | 4     |       |
| 1a    | Data model - Design iterations, simplification             | 4     | NB: simpler to keep existing model, unless there are missing data types?      |
| 2     | REST API - Design iterations                               | 2     |       |
| xx    | REST API - Design over-the-wire data representation        | 4     |       |
| 3     | REST API - Code and Test                                   | 8     |       |
| 4     | ~~Data Loading via XML (plants, plots, communities, etc.)~~    | 4     | Proposal: Remove XML format      |
| 5     | ~~Optimize existing loading process - speed, memory (fix loading bugs to allow large number of plots; optimize keyword indexing)~~ | 4     | Proposal: Remove XML format      |
| 6     | Design and code new data loading format and loading process for efficiency | 16|       |
| 7     | ~~Design and implement VegBranch changes for new load changes (M Lee) (only needed if 6, and done in parallel)~~ | 3     |       |
| 8     | New build system (maven)                                   | 2     |       |
| 9     | New testing suite/CI                                       | 2     |       |
| 10    | Automate build and deploy process                          | 2     |       |
| 11    | Deploy REST Service (upgrade postgres, web servers, etc)   | 1     |       |
| 12    | Supervision and coordination (one week each for Jones, Lee, and the developer) | 3 |       |
| xx    | Contingency time                                           | 18    |       |

TOTAL: 63 person weeks

### Task 1.2: New Web UI: Core Features

Phase II will focus on design of a new web application based on core, modern HTML and Javascript models that presents the core features of the current VegBank application, inlcuding the ability to search for plot, plant, and community data, and to display details of these on the site.  It will inlcude the current data cart model to select multiple plots and download them at once, user management pages for account creation and authentication, and a simple page to upload the VegBank XML format to load new plots.  At the end of this phase, a modern and maintainable version of VegBank (but with with fewer features than the original) will have been deployed, replacing the original application.

| Task# | Description                                                | Weeks | Notes |
|-------|------------------------------------------------------------|-------|-------|
| 13    | HTML5/JS frontend - Design iterations                      | 4     |       |
| 14    | Query implementation - Plots                               | 2     |       |
| 15    | Data views implementation - Plots                          | 2     |       |
| 16    | Data views implementation - Plants                         | 2     |       |
| 17    | Data views implementation - Community                      | 2     |       |
| 18    | Query implementation - Plants                              | 1     |       |
| 19    | Query implementation - Community                           | 1     |       |
| 20    | Data cart and data download                                | 3     |       |
| 21    | Form page and logic to upload data via new loader          | 4     |       |
| 22    | ~~Data views implementation - Users (user signup, forgot password, account info, login, logout)~~ | 2     | Switch to ORCID logins via DataONE      |
| 22    | Switch to DataONE/ORCID auth (user signup, login, logout, jwt support) | 4     | Switch to ORCID logins via DataONE      |
| 23    | ~~User Certification request form  (is user certification still needed - we have never turned anyone down?)~~ | 2     | Proposal: Remove      |
| 24    | Deploy VegBank 2 (VegBank 1 decomissioned)                 | 2     |       |
| 25    | Supervision and coordination (one week each for Jones, Lee, and the developer) | 3 |       |
| xx    | Contingency time                                           | 12    |       |

TOTAL: 42 person weeks

### Task 1.3: New R client `vegbank` package

In this phase, we design a new `vegbank` R package as a convenient means to download, create, and upload data to and from the VegBank API. This replaces the current `vegbranch` access database, in favor of the more common use of R in this discipline. The package will support a local copy of a subset of the vegbank data, creating new plot, community, and plant records locally; verification of the validity of these new records; and data upload of these new records to the VegBank API.

| Task# | Description                                                | Weeks | Notes |
|-------|------------------------------------------------------------|-------|-------|
| xx    | R Client - Design iterations                               | 4     |       |
| xx    | Data model in R                                            | 2     |       |
| xx    | Design and code authentication API                         | 2     |       |
| xx    | Data download implementation - Plots                       | 2     |       |
| xx    | Data download implementation - Plants                      | 2     |       |
| xx    | Data download implementation - Community                   | 2     |       |
| xx    | Query function - local plot subsetting                     | 2     |       |
| xx    | Design and code local data insertion functions             | 2     |       |
| xx    | Design and code local data verification functions          | 2     |       |
| xx    | Design and code data upload functions                      | 2     |       |
| xx    | Design and code submission review and approval functions   | 2     |       |
| xx    | Code review and publish `vegbank` R package                | 2     |       |
| xx    | Supervision and coordination (one week each for Jones and the developer) | 2 |       |
| xx    | Contingency time                                           | 10    |       |

TOTAL: 38 person weeks

### Task 1.4: New Web UI: Ancillary Features

Phase IV will focus on completion of useful features which are helpful in the current VegBank application, particularly to advanced users.  These include advanced searching and filtering of plot data, the ability to display vegetation plots on a map, the ability to view other ancillary data from the database, and the ability to manually annotate plots to associate them with new communities and plant concepts. This phase includes the migration of information about VegBank as a project, documentation about the data model, and administrative forms for managing the system and users.  When complete, a full replacement of the current VegBank system will have been designed and deployed, minus a few features that were deemed unnecessary (see table below).

| Task# | Description                                                | Weeks | Notes |
|-------|------------------------------------------------------------|-------|-------|
| 26    | ~~Query implementation - Advanced Plots~~                  | 2     |       |
| 27    | ~~Map UI for mapping plots (from query and dataset)~~      | 1     |       |
| 28    | ~~View Uploaded Plots (another type of plot query)~~       | 1     |       |
| 29    | ~~Edit uploaded plot precision and embargo date (Consider supporting modification of multiple plots at once) (mlee is the only one who probably uses this)~~| 1  |       |
| 30    | ~~Supplemental data queries (People, stratum, cover, projects, references, supplemental search)~~ | 4 |       |
| 31    | ~~Plot Annotation -- mapping plots to new communities or plant concepts~~ |  2  |       |
| 32    | **Historical webpage migration to the new system: history, ERD, general information** |  2    |       |
| 33    | ~~Data dictionary querying and display (reads tables in the database)~~ |   2   |       |
| 34    | **Admin forms and pages**                                  | 2     |       |
| xx    | Contingency time                                           | 1     |       |

TOTAL: 5 person weeks

### Task 1.5: Additional Features

Phase V introduces new features that are not currently part of VegBank.  Each of these could be implemented independently, and some are underspecified and so do not yet have time estimates.  Features include the addition of DOIs as a mechanism to improve citation of VegBank data, the ability to periodically import plant community data from USNVC, and the ability for VegBank to be accessible as a DataONE member to increase discoverability of VegBank holdings.

| Task# | Description                                                | Weeks | Notes |
|-------|------------------------------------------------------------|-------|-------|
| 35    | New feature: DOI assignment                                | 2     |       |
| 36    | New feature: Automate import of community concepts from usnvc.org, deal with duplication |  4  |       |
| 37    | DataONE member node                                        | 4     |       |
| 38    | Security analysis and code review                          | 2     |       |
| 39    | ~~New feature: Changes to data model (unspecified)~~       | ?     |       |
| 40    | ~~New feature: Quick view of community type (unspecified)~~| ?     |       |
| 41    | Data usage and citation reports, integrate with DataONE    | 2     |       |
| 42    | ~~Import / Export of data using the VegX schema or variant~~| ?     |       |
| 43    | ~~Schema and UI modifications for compatibility with BIEN~~| ?     |       |
| 44    | ~~Import / Export of data from TurboVeg format or app~~    | ?     |       |
| xx    | Contingency time                                           | 4     |       |

TOTAL: 14 person weeks

### Dropped Features

The following features of the current VegBank application were deemed to not be useful, or no longer relevant, and so the plan is to drop these from the application and not reimplement them.

| Task# | Description                                                | Weeks | Notes |
|-------|------------------------------------------------------------|-------|-------|
| XX    | Supplemental data creation forms (party, stratum, cover, reference) | ? |       |
| XX    | Dataset queries (from link at top of page; map datasets, constancy table, find plots plant, and find plots with community)   | ?     |       |
| XX    | Plot Loading -- Rectification                              | 1     |       |
| XX    | Plot Loading -- VegBranch                                  | 2     |       |
| XX    | Plot Loading -- CSV                                        | 1     |       |
| XX    | Plot Loading -- Other                                      | 2     |       |
| XX    | Plant Loading                                              | 2     |       |
| XX    | Community Loading                                          | 2     |       |
| XX    | Data Export (part of data download #8)                     | 3     |       |

### Task 1.6: Maintenance and operations

Longer term maintenance and operation requires a small but steady infusion of funds to upgrade hardware, provide power and cooling, and handle routine systems administration.  These costs can be broken down as:

- Hardware $4500 every 3 years, assuming the hardware requirements are roughly constant
   - Last upgraded in 2010
   - Simplest to amortize this as roughly $1500 per year, which will both pay for hardware and any maintenance agreements.
   - At NCEAS, hardware would now be on a virtual private cloud, rather than dedicated hardware, and so the annual fee is appropriate
- Systems admin (2 weeks per year): security, OS patches, Virtual machine management, hardware upgrades
- Routine software maintenance (4 weeks per year): browser compatibility fixes, version upgrades for Java and other software, security bug fixes

## Objective 2: California vegetation data processing

### Task 2.1: Transform California vegetation data to new VegBank model

- Needs scope estimate

### Task 2.2: Create a workflow (in R or another language) to automate this transformation

- Needs scope estimate

### Task 2.3: Upload current California data to VegBank (using new R package or REST API)

- Needs scope estimate

## Objective 3: Update taxonomies and classifications

### Task 3.1: Load new USDA plant taxonomies

- Helps test the taxonomy loading functions
- Needs scope estimate

### Task 3.2: Load new USNVC Classifications

- Helps test the classification loading functions
- Needs scope estimate

### Task 3.3: Map legacy data in BegBank to new vocabularies

- May not be a high priority
- Needs scope estimate

# Project scoping calls

## Call notes 2023-10-06

- Bob: need web feature to annotate plot classifications
  - also need batch update of community reassignments (and maybe not a web feature for it at all)
- Mike: who is the target audience for the client software?
  - Heritage programs
  - Grad students
- General discussion of suitability of R client
  - general agreement that it is the best approach
- Matt: big question is the over-the-wire data representation
- Rosie: can we have a GIS-enabled API for doing spatial queries in e.g., ArcGIS online?
- add staff time for documentation effort -- tutorials for R client in particular, from a veg science perspective
  - maybe Patrick McIntyre to help with this effort?
- Discussion of transformation steps to get data into standard format
  - Mike Lee: people should upload their raw data and tranformation scripts (store in DataONE?)
- Este -- the map UI would be useful in Phase 4
- TODO: add data scientist/analyst(s) and MLee to budget

## Call Notes 2023-09-27

- Rochelle says they have an existing data model in CA
- Timeline
    - Keep language in contract broad and flexible
    - Hard deadline of Feb 1 to get all paperwork done at Cal Wildlife
    - Start with general framework
    - Don't frame it as an IT development project
    - Can push start date to March 2024 or April, money expires in March 2026
    - Mid Oct
        - Need scope of work,
    - Deliverables
        - Project management - Matt & NCEAS
        - Data cleaning, loading, and migration - Data Scientist @ NCEAS
            - Migrate data into Vegbank
        - Software development - Developer @ NCEAS
        - R Package for veg data validation (but is that the wrong approach for the audience)
        - QC
        - One deliverable
    - Bob - can work on intro
    - Rochelle -- they can give their feedback based on their data
    - Bob - work with other groups about veg data and how they handle that
        - GBIF and Alexis
        - European Veg Archive
        - SPlot group with 2 million plots
        - BIEN - veg plot data 
        - Maybe hold a meeting

## Call notes from 2019-04-23

Alternative trajectory

- R API for querying iNaturalist
- R versus curl
- Note the BIEN group developed an rBIEN package
    - https://bien.nceas.ucsb.edu/bien/tools/rbien/
    - https://github.com/bmaitner/RBIEN/blob/master/tutorials/RBIEN_tutorial.Rmd
- Simplify data model for plots
- TurboVeg: can run desktop version
    - Missing tree stem data
    - Only use one strata system
    - Only use one classification approach
- Similar initiatives: SPlot,
- Proposal
    - Simplify the data model
    - Create a REST interface
    - Create an R package
    - Web interface?

