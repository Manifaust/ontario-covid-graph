---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

<div class="bb b--black-10">
  <p class="lh-copy f6"><a class="link blue underline-hover" href="#data-source-info">What's the source of this data?</a></p>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">New Cases</h2>
  <p class="lh-copy f6">New cases are calculated using the difference between daily total cases.</p>
  <canvas id="newCases" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Severe Cases</h2>
  <canvas id="severity" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">New Tests Completed</h2>
  <p class="lh-copy f6">Total tests completed from the day before.</p>
  <canvas id="newTests" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Toronto New Cases</h2>
  <canvas id="cities-new-cases" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Infections and Deaths</h2>
  <canvas id="infectedResolvedDeaths" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Total Cases</h2>
  <p class="lh-copy f6">Total case includes infected, but also resolved cases such as recovered and deaths.</p>
  <canvas id="totalCases" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Weekly Growth Factor</h2>
  <p class="lh-copy f6">The growth factor measures the acceleration of new cases. For example, if the number of new cases this week is 10% more than the number of new cases last week, then the growth factor is 1.10.</p>

  <p class="lh-copy f6">A growth factor that's consistently above 1.00 means the virus is spreading faster and faster. Conversely, a growth factor that's consistently below 1.00 means the virus's spread is slowing down.</p>
  <canvas id="weeklyGrowthFactorChart" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Institutional Outbreaks</h2>
  <p class="lh-copy f6">There's a spike in April 29 because that's when the province started to provide data for retirement homes.</p>
  <canvas id="institutional-outbreaks" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Institutional Cases</h2>
  <canvas id="institutional-cases" class="mb3"></canvas>
</div>

<div class="bb b--black-10">
  <h2 class="f3 fw3">Institutional Deaths</h2>
  <canvas id="institutional-deaths" class="mb3"></canvas>
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

