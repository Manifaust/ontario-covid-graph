---
layout: default
---

<div class="bb b--black-10 lh-copy f6">
  <p><a class="link blue underline-hover" href="#data-source-info">What's the source of this data?</a></p>
  <p>
    <b>Jan 22 Update</b>
    <ul>
      <li>Moved hospital graph up.</li>
    </ul>
  </p>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">New Cases</h2>
  <canvas id="newCases" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Hospital Treatment</h2>
  <canvas id="severity" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Daily Vaccine Doses Administered</h2>
  <p>There is an increase in the doses administered on Dec 3 due to the introduction of third dose data being reported on this date. Moving forward, the daily doses will include third doses administered.</p>
  <canvas id="daily-vaccine" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Immunization Coverage</h2>
  <canvas id="immunization-coverage" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Long-Term Care Home (LTC) New Cases</h2>
  <canvas id="ltc-new-cases" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Long-Term Care Home (LTC) Deaths</h2>
  <canvas id="ltc-deaths" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Toronto New Cases</h2>
  <canvas id="toronto-new-cases" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Infections and Deaths</h2>
  <canvas id="infectedResolvedDeaths" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">New Tests Completed</h2>
  <p class="lh-copy f6">Total tests completed from the day before.</p>
  <canvas id="newTests" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Weekly Growth Factor</h2>
  <p class="lh-copy f6">The growth factor measures the acceleration of new cases. For example, if the number of new cases this week is 10% more than the number of new cases last week, then the growth factor is 1.10.</p>

  <p class="lh-copy f6">A growth factor that's consistently above 1.00 means the virus is spreading faster and faster. Conversely, a growth factor that's consistently below 1.00 means the virus's spread is slowing down.</p>
  <canvas id="weeklyGrowthFactorChart" class="mb3"></canvas>
</div>

<h2 class="f3 fw3" id="data-source-info">Where does our data come from?</h2>
<p class="lh-copy f6">Data for this website comes from the <a class="link blue underline-hover"
href="https://data.ontario.ca/dataset?keywords_en=COVID-19">Ontario Data
Catalogue</a> and the <a class="link blue underline-hover"
href="https://data.ontario.ca/dataset?keywords_en=COVID-19">daily
epidemiological summaries</a> from the Government of Ontario. This data is made
available under <a class="link blue underline-hover"
href="https://github.com/Manifaust/ontario-covid-graph/blob/master/raw_reports/LICENSE">Ontario's Open Government License</a>.</p>

<h2 class="f3 fw3">About</h2>
<p class="lh-copy f6">This website was created by Tony Wong and Garry Ing. It's <a class="link blue underline-hover"
href="https://github.com/Manifaust/ontario-covid-graph">open source</a>.</p>

