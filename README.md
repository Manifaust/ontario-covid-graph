![Update Report](https://github.com/Manifaust/ontario-covid-graph/workflows/Update%20Report/badge.svg)
# ontario-covid-graph
A tool and website that graphs Ontario COVID-19 data

# Viewing the Compiled Report
All the data gets compiled into `report.json`, which gets updated every day (unless something goes wrong).

## Raw Reports
Downloaded reports are saved every day to the `raw_reports` directory.

# Generate the Report
## Requirements

* ruby
* java

## Build Script
`$ ./run.sh`

This will download data from different sources to and compile it into `report.json`.

# Testing the Website

`$ jekyll serve`

This will create a local webserver for you to test.
