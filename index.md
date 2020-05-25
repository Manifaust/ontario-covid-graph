---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

<a href="#data-source-info">What's the source of this data?</a>

<h2>Total Cases</h2>
<p>The total cases for Ontario includes infected, but also resolved cases such as
recovered and dead.</p>
<canvas id="totalCases" class="mb3"></canvas>

<h2>New Cases</h2>
<p>New cases are calculated using the difference between daily total cases.</p>
<canvas id="newCases" class="mb3"></canvas>

<h2>Growth Factor</h2>
<p>The growth factor measures the acceleration of new cases. For example, if
the number of new cases today is 10% more than the number of new cases
yesterday, then the growth factor is 1.10.</p>

<p>A growth factor that's consistently above 1.00 means the virus is spreading faster
and faster. Conversely, a growth factor that's consistently below 1.00 means the
virus's spread is slowing down.<p>
<canvas id="growthFactorChart" class="mb3"></canvas>

<h2>Infections and Deaths</h2>
<canvas id="infectedResolvedDeaths" class="mb3"></canvas>

<h2>Severe Cases</h2>
<canvas id="severity" class="mb3"></canvas>

<h2>Total Cases for Toronto</h2>
<canvas id="cities-total-cases" class="mb3"></canvas>

<h2>New Cases for Toronto</h2>
<canvas id="cities-new-cases" class="mb3"></canvas>

<h2>Institutional Outbreaks</h2>
<p>There's a spike in April 29 because that's when the province started to
provide data for retirement homes</p>
<canvas id="institutional-outbreaks" class="mb3"></canvas>

<h2>Institutional Cases</h2>
<canvas id="institutional-cases" class="mb3"></canvas>

<h2>Institutional Deaths</h2>
<canvas id="institutional-deaths" class="mb3"></canvas>

<h2>Where does our data come from?</h2><a name="data-source-info" />
<p>Data for this website comes from <a
href="https://data.ontario.ca/dataset?keywords_en=COVID-19">Ontario Data
Catalogue</a> and the <a
href="https://data.ontario.ca/dataset?keywords_en=COVID-19">daily
epidemiological summaries</a> from the Government of Ontario.</p>
