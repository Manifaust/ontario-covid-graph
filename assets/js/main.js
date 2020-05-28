Chart.defaults.global.defaultFontFamily = getComputedStyle(document.body).fontFamily

const URLparams = new URLSearchParams(window.location.search)
const reportURL = '/report.json'
const darkModeToggle = document.getElementById('darkMode')
const dateRange = new Date()
dateRange.setMonth(dateRange.getMonth() - 2)

window.fetch(reportURL).then((response) => {
  return response.json()
}).then((data) => {
  chart.render({
    ele: document.getElementById('growthFactorChart'),
    data: data,
    title: 'Growth Factor (Total Cases)',
    key: 'growth_factor_total_cases',
    color: '255, 99, 132',
    maxValue: 2
  })

  chart.render({
    ele: document.getElementById('totalCases'),
    data: data,
    title: 'Total Cases',
    key: 'total_cases',
    color: '53, 126, 221'
  })

  chart.render({
    ele: document.getElementById('newCases'),
    data: data,
    title: 'New Cases',
    key: 'new_total_cases',
    color: '255, 159, 64'
  })

  chart.render({
    ele: document.getElementById('newTests'),
    data: data,
    title: "Previous Day's Tests",
    key: 'new_tests',
    color: '218, 112, 214'
  })

  chart.render({
    ele: document.getElementById('infectedResolvedDeaths'),
    data: data,
    title: 'Infected',
    key: 'infected',
    color: '153, 102, 255',
    fill: false,
    subCharts: [{
      title: 'Deaths',
      key: 'deaths',
      color: '229, 0, 93'
    }, {
      title: 'Resolved',
      key: 'resolved',
      color: '0, 160, 79'
    }]
  })

  chart.render({
    ele: document.getElementById('severity'),
    data: data,
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
    ele: document.getElementById('cities-total-cases'),
    data: data,
    title: 'Ontario Total Cases',
    key: 'total_cases',
    color: '222, 222, 222',
    fill: false,
    subCharts: [{
      title: 'Toronto Total Cases',
      subKey: 'Toronto Public Health',
      key: 'cities_total_cases_from_epidemiologic_summary',
      color: '40, 67, 142'
    }]
  })

  chart.render({
    ele: document.getElementById('cities-new-cases'),
    data: data,
    title: 'Ontario New Cases',
    key: 'new_total_cases',
    color: '222, 222, 222',
    fill: false,
    subCharts: [{
      title: 'Toronto New Cases',
      subKey: 'Toronto Public Health',
      key: 'cities_new_cases_from_epidemiologic_summary',
      color: '40, 67, 142'
    }]
  })

  chart.render({
    ele: document.getElementById('institutional-outbreaks'),
    data: data,
    title: 'Institutional Outbreaks',
    key: 'institutional_outbreaks',
    hideInLegend: true,
    color: '222, 222, 222',
    fill: false,
    subCharts: [{
      title: 'Retirement Home Outbreaks',
      key: 'institutional_outbreaks',
      subKey: 'retirement_home',
      color: '72, 159, 165'
    }, {
      title: 'Long-Term Care Outbreaks',
      key: 'institutional_outbreaks',
      subKey: 'long_term',
      color: '252, 113, 0'
    }, {
      title: 'Hospital Outbreaks',
      key: 'institutional_outbreaks',
      subKey: 'hospitals',
      color: '153, 0, 255'
    }, {
      title: 'Total Outbreaks',
      key: 'institutional_outbreaks',
      subKey: 'total',
      color: '222, 222, 222'
    }]
  })

  chart.render({
    ele: document.getElementById('institutional-cases'),
    data: data,
    title: 'Institutional Cases',
    key: 'institutional_cases',
    hideInLegend: true,
    color: '222, 222, 222',
    fill: false,
    subCharts: [{
      title: 'Retirement Home Residents Cases',
      key: 'institutional_resident_patient_cases',
      subKey: 'retirement_home',
      color: '72, 159, 165'
    }, {
      title: 'Retirement Home Staff Cases',
      key: 'institutional_staff_cases',
      subKey: 'retirement_home',
      color: '191, 31, 55'
    }, {
      title: 'Long-Term Care Residents Cases',
      key: 'institutional_resident_patient_cases',
      subKey: 'long_term',
      color: '252, 113, 0'
    }, {
      title: 'Long-Term Care Staff Cases',
      key: 'institutional_staff_cases',
      subKey: 'long_term',
      color: '153, 0, 255'
    }, {
      title: 'Hospital Patients Cases',
      key: 'institutional_resident_patient_cases',
      subKey: 'hospitals',
      color: '0, 167, 35'
    }, {
      title: 'Hospital Staff Cases',
      key: 'institutional_staff_cases',
      subKey: 'hospitals',
      color: '0, 42, 252'
    }, {
      title: 'Total Cases',
      key: 'institutional_all_cases',
      subKey: 'total',
      color: '222, 222, 222'
    }]
  })

  chart.render({
    ele: document.getElementById('institutional-deaths'),
    data: data,
    title: 'Institutional Deaths',
    key: 'institutional_deaths',
    hideInLegend: true,
    color: '222, 222, 222',
    fill: false,
    subCharts: [{
      title: 'Retirement Home Residents Deaths',
      key: 'institutional_resident_patient_deaths',
      subKey: 'retirement_home',
      color: '72, 159, 165'
    }, {
      title: 'Retirement Home Staff Deaths',
      key: 'institutional_staff_deaths',
      subKey: 'retirement_home',
      color: '191, 31, 55'
    }, {
      title: 'Long-Term Care Deaths',
      key: 'institutional_resident_patient_deaths',
      subKey: 'long_term',
      color: '252, 113, 0'
    }, {
      title: 'Long-Term Care Staff Deaths',
      key: 'institutional_staff_deaths',
      subKey: 'long_term',
      color: '153, 0, 255'
    }, {
      title: 'Hospital Patients Deaths',
      key: 'institutional_resident_patient_deaths',
      subKey: 'hospitals',
      color: '0, 167, 35'
    }, {
      title: 'Hospital Staff Deaths',
      key: 'institutional_staff_deaths',
      subKey: 'hospitals',
      color: '0, 42, 252'
    }, {
      title: 'Total Cases',
      key: 'institutional_all_deaths',
      subKey: 'total',
      color: '222, 222, 222'
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
          fill: opt.fill,
          pointBackgroundColor: `rgba(${opt.color}, 0.25)`,
          pointBorderColor: `rgba(${opt.color}, 0.5)`,
          spanGaps: true
        }]
      },
      options: {
        aspectRatio: window.matchMedia('(max-width: 600px)').matches ? 1.2 : 2,
        legend: {
          labels: {
            boxWidth: 15,
            filter: (legendItem, chartData) => {
              if (opt.hideInLegend && legendItem.datasetIndex === 0) {
                return false
              }
              return true
            }
          }
        },
        scales: {
          xAxes: [{
            type: 'time',
            gridLines: {
              zeroLineWidth: 0
            },
            ticks: {
              unit: 'day',
              min: dateRange
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
          subKey: i.subKey,
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
      if (opt.subKey) {
        return e.map(i => i !== undefined ? i[opt.subKey] : undefined)
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
      pointBackgroundColor: `rgba(${opt.color}, 0.25)`,
      pointBorderColor: `rgba(${opt.color}, 0.5)`,
      data: subChartData(),
      spanGaps: true
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
    updateElements('b--black-10', 'b--white-10')
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
    updateElements('b--white-10', 'b--black-10')
    URLparams.delete('dark')
  }
}

darkModeToggle.addEventListener('change', (e) => {
  darkMode(e.target.checked)
  window.history.replaceState({}, '', `${window.location.pathname}${e.target.checked ? '?' + URLparams : ''}`)
}, false)
