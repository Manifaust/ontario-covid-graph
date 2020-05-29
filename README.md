# [ontario-covid-graph](https://ontario-covid.com/)
![Update Report](https://github.com/Manifaust/ontario-covid-graph/workflows/Update%20Report/badge.svg)

A tool and [website](https://ontario-covid.com/) that graphs Ontario COVID-19 data.

## Viewing the Compiled Report
All the data gets compiled into `report.json`, which gets updated every day (unless something goes wrong).

### Raw Reports
Downloaded reports are saved every day to the `raw_reports` directory.

## Generate the Report
### Requirements

* ruby
* java

### Build Script
`$ ./run.sh`

This will download data from different sources to and compile it into `report.json`.

## Testing the Website

1. Install Jekyll and bundler gems: `$ bundle install`
2. Run local server: `$ bundle exec jekyll serve`

This will create a local webserver for you to test.

## License
- Code released under the MIT License. See the [LICENSE](./LICENSE)
- Data released under [Open Government Licence – Ontario](https://www.ontario.ca/page/open-government-licence-ontario). See the reports [./raw_reports/LICENSE](./raw_reports/LICENSE)
