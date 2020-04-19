Chart.defaults.global.defaultFontFamily = getComputedStyle(document.body).fontFamily

const URLparams = new URLSearchParams(window.location.search)
const reportURL = '/ontario-covid-graph/report.json'
const darkModeToggle = document.getElementById('darkMode')

window.fetch(reportURL).then((response) => {
  return response.json()
}).then((data) => {
  chart.render({
    ele: document.getElementById('growthFactorChart'),
    data: data,
    title: 'Growth Factor (Total Cases)',
    key: 'growth_factor_total_cases',
    color: '255, 99, 132',
    maxValue: 6
  })

  chart.render({
    ele: document.getElementById('totalCases'),
    data: data,
    title: 'Total Cases',
    key: 'total_cases',
    color: '54, 162, 235'
  })

  chart.render({
    ele: document.getElementById('newCases'),
    data: data,
    title: 'New Cases',
    key: 'new_total_cases',
    color: '255, 159, 64'
  })

  chart.render({
    ele: document.getElementById('infectedResolvedDeaths'),
    data: data,
    title: 'Infected',
    key: 'infected',
    color: '153, 102, 255',
    borderWidth: 2,
    fill: false,
    subCharts: [{
      title: 'Deaths',
      key: 'deaths',
      color: '0, 0, 0'
    }, {
      title: 'Resolved',
      key: 'resolved',
      color: '6, 255, 129'
    }]
  })

  chart.render({
    ele: document.getElementById('severity'),
    data: data,
    title: 'Hospitalized',
    key: 'hospitalized',
    color: '80, 209, 208',
    borderWidth: 2,
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
    ele: document.getElementById('cities-total-cases'),
    data: data,
    title: 'Total Cases',
    key: 'total_cases',
    color: '222, 222, 222',
    fill: false,
    subCharts: [{
      title: 'Toronto',
      location: 'Toronto',
      key: 'cities_total_cases',
      color: '40, 67, 142'
    }, {
      title: 'Mississauga',
      location: 'Mississauga',
      key: 'cities_total_cases',
      color: '82, 192, 232'
    }, {
      title: 'Newmarket',
      location: 'Newmarket',
      key: 'cities_total_cases',
      color: '70, 149, 65'
    }, {
      title: 'Ottawa',
      location: 'Ottawa',
      key: 'cities_total_cases',
      color: '18, 168, 142'
    }, {
      title: 'Whitby',
      location: 'Whitby',
      key: 'cities_total_cases',
      color: '239, 23, 40'
    }]
  })

  chart.render({
    ele: document.getElementById('cities-new-cases'),
    data: data,
    title: 'New Cases',
    key: 'new_total_cases',
    color: '222, 222, 222',
    fill: false,
    borderWidth: 2,
    subCharts: [{
      title: 'Toronto',
      location: 'Toronto',
      key: 'cities_new_cases',
      color: '40, 67, 142'
    }]
  })
}).then(() => {
  if (URLparams.get('dark') === 'true') {
    darkMode(true)
  }
})

const chart = {
  render: (opt) => {
    const chartLabels = opt.data.map(i => i.date)
    const chartData = opt.data.map(i => i[opt.key])
    if (!('borderWidth' in opt)) { opt.borderWidth = 1 }
    if (!('fill' in opt)) { opt.fill = true }
    var gradientFill = opt.ele.getContext('2d').createLinearGradient(0, 0, 0, 370)
    gradientFill.addColorStop(0, `rgba(${opt.color}, 0.6)`)
    gradientFill.addColorStop(1, `rgba(${opt.color}, 0)`)
    var myChart = new Chart(opt.ele, {
      type: 'line',
      data: {
        labels: chartLabels,
        datasets: [{
          label: opt.title,
          data: chartData,
          backgroundColor: gradientFill,
          borderColor: [
            `rgba(${opt.color}, 1)`
          ],
          borderWidth: opt.borderWidth,
          fill: opt.fill
        }]
      },
      options: {
        legend: {
          labels: {
            boxWidth: 15
          }
        },
        scales: {
          xAxes: [{
            type: 'time',
            time: {
              unit: 'day'
            }
          }],
          yAxes: [{
            position: 'right',
            ticks: {
              beginAtZero: true,
              max: opt.maxValue
            }
          }]
        }
      }
    })

    if (opt.subCharts) {
      opt.subCharts.map(i =>
        chart.addData({
          chart: myChart,
          title: i.title,
          color: i.color,
          subChartData: opt.data,
          key: i.key,
          location: i.location,
          borderWidth: opt.borderWidth,
          fill: opt.fill
        })
      )
    }

    chart.collection.push(myChart)
  },
  addData: (opt) => {
    const subChartData = () => {
      const e = opt.subChartData.map(i => i[opt.key])
      if (opt.location) {
        return e.map(i => i !== undefined ? i[opt.location] : undefined)
      }
      return e
    }

    opt.chart.data.datasets.push({
      label: opt.title,
      backgroundColor: [
        `rgba(${opt.color}, 0.2)`
      ],
      borderColor: [
        `rgba(${opt.color}, 1)`
      ],
      borderWidth: opt.borderWidth,
      fill: opt.fill,
      data: subChartData()
    })
    opt.chart.update()
  },
  collection: []
}

const darkMode = (e) => {
  const body = document.body
  const title = document.getElementById('title')
  if (e) {
    darkModeToggle.checked = true
    body.classList.remove('bg-near-white')
    body.classList.add('bg-near-black', 'white')
    title.classList.remove('black')
    title.classList.add('white')
    chart.collection.map((chart) => {
      chart.options.scales.xAxes[0].gridLines.color = 'rgba(255,255,255,0.1)'
      chart.options.scales.yAxes[0].gridLines.color = 'rgba(255,255,255,0.1)'
      chart.update()
    })
    URLparams.set('dark', true)
  } else {
    body.classList.add('bg-near-white')
    body.classList.remove('bg-near-black', 'white')
    title.classList.add('black')
    title.classList.remove('white')
    chart.collection.map((chart) => {
      chart.options.scales.xAxes[0].gridLines.color = 'rgba(0,0,0,0.1)'
      chart.options.scales.yAxes[0].gridLines.color = 'rgba(0,0,0,0.1)'
      chart.update()
    })
    URLparams.set('dark', false)
  }
}

darkModeToggle.addEventListener('change', (e) => {
  darkMode(e.target.checked)
  window.history.replaceState({}, '', `${window.location.pathname}?${URLparams}`)
}, false)
