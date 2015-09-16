VegBank 2
=========

## Goals
- Sustainability
    - Modernize VegBank, improve maintainability
        - Remove struts and obsolete frameworks
    - Separate UI from backend to lower future UI upgrade costs
- New features
    - DOI identifiers for plots or sets of plots

## Tasks

This is a rough, back of the envelope estimate. Caveat emptor.

| Task# | Description                              | Weeks |
|-------|------------------------------------------|-------|
| 1     | Spinup on existing codebase              | 4     |
| 2     | REST API - Design iterations             | 2     |
| 3     | REST API - Code and Test                 | 8     |
| 4     | HTML5/JS frontend - Design iterations    | 4     |
| 5     | Query implementation - Plots             | 1     |
| 6     | Query implementation - Plants            | 1     |
| 7     | Query implementation - Community         | 1     |
| 8     | Data cart and data download              | 3     |
| 9     | Data forms implementation - Users        | 2     |
| 10    | Data forms implementation - Plots        | 2     |
| 11    | Data forms implementation - Plants       | 2     |
| 12    | Data forms implementation - Community    | 2     |
| 13    | Plot Loading -- Rectification            | 1     |
| 14    | Plot Loading -- XML                      | 4     |
| 15    | Plot Loading -- VegBranch                | 2     |
| 16    | Plot Loading -- CSV                      | 1     |
| 17    | Plot Loading -- Other                    | 2     |
| 18    | Plant Loading                            | 2     |
| 19    | Community Loading                        | 2     |
| 20    | Data Export                              | 3     |
| 21    | User Certification                       | 2     |
| 22    | New build system (maven)                 | 2     |
| 23    | New testing suite/CI                     | 2     |
| 24    | New testing suite/CI                     | 2     |
| 25    | Completely remove Struts framework       | 2     |
| 26    | Admin forms and pages                    | 2     |
| 27    | Automate build and deploy process        | 2     |
| 28    | Optimize loading process - speed, memory | 4     |
| 29    | New feature: DOI archiving               | 3     |

## Maintenance and operation

Longer term maintenance and operation requires a small but steady infusion of funds

- Hardware $4000 every 3 years, assuming the hardware requirements are roughly constant
   - Last upgraded in 2010
- Systems admin: security, OS patches, Virtual machine management: 2 weeks per year sysadmin
- Routine software maintenance: browser compatibility fixes, version upgrades for Java, security bug fixes; 4 weeks per year


## ESA 2015 Discussion

- Some folks want more detailed usage statistics (New Zealand)
- VegBranch, still working, but usability improvements with VegTwig
- Loading data: problems with loading more than 100 plots in a single XML batch
    - problem was downloading data using XSLT conversion from XML to CSV
- Interest in the API/UI refactoring, liked that model
- Interest in exposing VegBank data through DataONE
- EcoObs -- the Nature Serve ecological observations database





