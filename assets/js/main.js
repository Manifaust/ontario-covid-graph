const Chart = window.Chart

Chart.defaults.font.family = window.getComputedStyle(document.body).fontFamily
Chart.overrides.line.borderWidth = 1
Chart.overrides.line.spanGaps = true

const reportURL = '/report.json'
const darkModeToggle = document.getElementById('darkMode')
const chartControls = document.getElementById('chartControls')
const dateRange = new Date()
const darkChartBordersRGB = 'rgba(255,255,255,0.1)'
const lightChartBordersRGB = 'rgba(0,0,0,0.1)'

let fetchedData
dateRange.setMonth(dateRange.getMonth() - 4)

window.fetch(reportURL).then((response) => {
  return response.json()
}).then((data) => {
  fetchedData = data
  chart.render({
    ele: document.getElementById('weeklyGrowthFactorChart'),
    title: 'Weekly Growth Factor',
    key: 'weekly_growth_factor_total_cases',
    color: '255, 99, 132',
    maxValue: 2
  })

  chart.render({
    ele: document.getElementById('newCases'),
    title: 'New Cases',
    key: 'new_total_cases',
    hideInLegend: true,
    color: '255, 159, 64'
  })

  chart.render({
    ele: document.getElementById('immunization-coverage'),
    title: 'Immunization Coverage',
    hideInLegend: true,
    subCharts: [{
      title: 'Total Individuals Fully Vaccinated',
      key: 'vaccine',
      subKey: 'total_fully_vaccinated',
      color: '232, 20, 130'
    }, {
      title: 'Total Individuals with at Least One Dose',
      key: 'vaccine',
      subKey: 'total_individuals_at_least_one',
      color: '227, 168, 198'
    }]
  })

  chart.render({
    ele: document.getElementById('daily-vaccine'),
    title: 'Daily Vaccine',
    hideInLegend: true,
    subCharts: [{
      title: "Previous Day's Vaccine Doses",
      key: 'vaccine',
      subKey: 'previous_day_doses',
      color: '102, 153, 35'
    }]
  })

  chart.render({
    ele: document.getElementById('newTests'),
    title: "Previous Day's Tests",
    key: 'new_tests',
    color: '218, 112, 214'
  })

  chart.render({
    ele: document.getElementById('infectedResolvedDeaths'),
    title: 'Infected',
    key: 'infected',
    color: '153, 102, 255',
    fill: false,
    subCharts: [{
      title: 'Deaths',
      key: 'deaths',
      color: '229, 0, 93'
    }]
  })

  chart.render({
    ele: document.getElementById('severity'),
    title: 'Hospitalized',
    key: 'hospitalized',
    color: '80, 209, 208',
    fill: false,
    subCharts: [{
      title: 'ICU',
      key: 'icu',
      color: '141, 182, 0'
    }, {
      title: 'ICU on Ventilator',
      key: 'icu_on_ventilator',
      color: '228, 61, 77'
    }]
  })

  chart.render({
    ele: document.getElementById('toronto-new-cases'),
    title: 'Toronto New Cases',
    key: 'toronto',
    hideInLegend: true,
    color: '222, 222, 222',
    subCharts: [{
      title: 'Toronto',
      subKey: 'new_cases',
      key: 'toronto',
      color: '40, 67, 142'
    }]
  })

  chart.render({
    ele: document.getElementById('ltc-new-cases'),
    title: 'LTC',
    key: 'ltc',
    hideInLegend: true,
    color: '222, 222, 222',
    fill: true,
    subCharts: [{
      title: 'LTC Resident New Cases',
      key: 'ltc',
      subKey: 'resident_new_cases',
      color: '252, 113, 0'
    }]
  })

  chart.render({
    ele: document.getElementById('ltc-deaths'),
    title: 'LTC',
    key: 'ltc',
    hideInLegend: true,
    color: '222, 222, 222',
    fill: true,
    subCharts: [{
      title: 'LTC Resident Deaths',
      key: 'ltc',
      subKey: 'resident_total_deaths',
      color: '72, 159, 165'
    }]
  })

  return data.pop().date
}).then((lastDay) => {
  if (isDateSupported()) {
    chartControls.classList.add('db-ns')
  }
  createDateControl(lastDay)
  if (window.localStorage.getItem('darkMode') === 'true') {
    darkMode(true)
  }
})

const isDateSupported = () => {
  const input = document.createElement('input')
  const value = 'a'
  input.setAttribute('type', 'date')
  input.setAttribute('value', value)
  return (input.value !== value)
}

const chart = {
  gradientFill: (ctx, color) => {
    const gradientFill = ctx.getContext('2d').createLinearGradient(0, 0, 0, 370)
    gradientFill.addColorStop(0, `rgba(${color}, 0.6)`)
    gradientFill.addColorStop(1, `rgba(${color}, 0)`)
    return gradientFill
  },
  render: async (opt) => {
    const chartLabels = fetchedData.map(i => i.date)
    const chartData = fetchedData.map(i => i[opt.key])
    if (!('fill' in opt)) { opt.fill = true }
    if (!('color' in opt)) { opt.color = '127, 127, 127' }
    const myChart = new Chart(opt.ele, {
      type: 'line',
      data: {
        labels: chartLabels,
        datasets: [{
          label: opt.title,
          data: chartData,
          backgroundColor: chart.gradientFill(opt.ele, opt.color),
          borderColor: `rgba(${opt.color}, 1)`,
          fill: opt.fill,
          pointBackgroundColor: `rgba(${opt.color}, 0.25)`,
          pointBorderColor: `rgba(${opt.color}, 0.5)`
        }]
      },
      options: {
        aspectRatio: window.matchMedia('(max-width: 600px)').matches ? 1.2 : 2,
        plugins: {
          legend: {
            display: opt.displayLegend,
            labels: {
              boxWidth: 15,
              color: '#666',
              filter: (legendItem, chartData) => {
                if (opt.hideInLegend && legendItem.datasetIndex === 0) {
                  return false
                }
                return true
              }
            }
          }
        },
        scales: {
          x: {
            type: 'time',
            min: dateRange,
            time: {
              tooltipFormat: 'MMMM d'
            },
            gridLines: {
              zeroLineWidth: 0
            }
          },
          y: {
            position: 'right'
          }
        }
      }
    })

    if (opt.subCharts) {
      opt.subCharts.map(i =>
        chart.addData({
          ctx: opt.ele,
          chart: myChart,
          title: i.title,
          color: i.color,
          subChartData: fetchedData,
          key: i.key,
          subKey: i.subKey,
          fill: opt.fill
        })
      )
    }

    chart.collection.push(myChart)
  },
  addData: async (opt) => {
    const subChartData = () => {
      const e = opt.subChartData.map(i => i[opt.key])
      if (opt.subKey) {
        return e.map(i => i !== undefined ? i[opt.subKey] : undefined)
      }
      return e
    }

    opt.chart.data.datasets.push({
      label: opt.title,
      backgroundColor: chart.gradientFill(opt.ctx, opt.color),
      borderColor: `rgba(${opt.color}, 1)`,
      fill: opt.fill,
      pointBackgroundColor: `rgba(${opt.color}, 0.25)`,
      pointBorderColor: `rgba(${opt.color}, 0.5)`,
      data: subChartData()
    })
    opt.chart.update()
  },
  collection: []
}

const updateElements = (fromClass, toCLass) => {
  Array.from(document.getElementsByClassName(fromClass)).forEach((i) => {
    i.classList.remove(fromClass)
    i.classList.add(toCLass)
  })
}

const darkMode = (e) => {
  const bodyClass = document.documentElement.classList
  const titleClass = document.getElementById('title').classList
  if (e) {
    darkModeToggle.checked = true
    bodyClass.remove('bg-near-white')
    bodyClass.add('bg-near-black', 'white')
    titleClass.remove('black')
    titleClass.add('white')
    chart.collection.map((chart) => {
      chart.options.scales.y.grid.borderColor = darkChartBordersRGB
      chart.options.scales.x.grid.color = darkChartBordersRGB
      chart.options.scales.y.grid.color = darkChartBordersRGB
      return chart.update()
    })
    updateElements('b--black-10', 'b--white-10')
  } else {
    bodyClass.add('bg-near-white')
    bodyClass.remove('bg-near-black', 'white')
    titleClass.add('black')
    titleClass.remove('white')
    chart.collection.map((chart) => {
      chart.options.scales.y.grid.borderColor = lightChartBordersRGB
      chart.options.scales.x.grid.color = lightChartBordersRGB
      chart.options.scales.y.grid.color = lightChartBordersRGB
      return chart.update()
    })
    updateElements('b--white-10', 'b--black-10')
  }
}

darkModeToggle.addEventListener('change', (e) => {
  darkMode(e.target.checked)
  window.localStorage.setItem('darkMode', e.target.checked)
}, false)

const createDateControl = (lastDay) => {
  const dateControl = document.createElement('input')
  dateControl.type = 'date'
  dateControl.name = 'dateControl'
  dateControl.value = dateRange.toISOString().substring(0, 10)
  dateControl.max = lastDay
  dateControl.min = '2020-01-01'
  dateControl.classList = 'f7 ba br2'
  dateControl.id = 'dateControl'
  chartControls.appendChild(dateControl)

  dateControl.addEventListener('change', (e) => {
    chart.collection.map((chart) => {
      chart.options.scales.x.min = e.target.value
      return chart.update()
    })
  }, false)
}
