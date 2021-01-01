Chart.defaults.font.family = getComputedStyle(document.body).fontFamily
Chart.defaults.elements.line.borderWidth = 1
Chart.defaults.controllers.line.spanGaps = true

const reportURL = '/report.json'
const darkModeToggle = document.getElementById('darkMode')
const chartControls = document.getElementById('chartControls')
const dateRange = new Date()
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
    ele: document.getElementById('totalCases'),
    title: 'Total Cases',
    key: 'total_cases',
    color: '53, 126, 221'
  })

  chart.render({
    ele: document.getElementById('newCases'),
    title: 'New Cases',
    key: 'new_total_cases',
    color: '255, 159, 64'
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
    ele: document.getElementById('cities-total-cases'),
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
    title: 'Toronto New Cases',
    key: 'toronto',
    hideInLegend: true,
    color: '222, 222, 222',
    fill: false,
    subCharts: [{
      title: 'Toronto',
      subKey: 'new_cases',
      key: 'toronto',
      color: '40, 67, 142'
    }]
  })

  chart.render({
    ele: document.getElementById('institutional-outbreaks'),
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
  return data.pop().date
}).then((lastDay) => {
  if (isDateSupported()) {
    chartControls.classList.add('db-ns')
  }
  createDateControl(lastDay)
  if (localStorage.getItem('darkMode') === 'true') {
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
  render: (opt) => {
    const chartLabels = fetchedData.map(i => i.date)
    const chartData = fetchedData.map(i => i[opt.key])
    if (!('fill' in opt)) { opt.fill = true }
    const gradientFill = opt.ele.getContext('2d').createLinearGradient(0, 0, 0, 370)
    gradientFill.addColorStop(0, `rgba(${opt.color}, 0.6)`)
    gradientFill.addColorStop(1, `rgba(${opt.color}, 0)`)
    const myChart = new Chart(opt.ele, {
      type: 'line',
      data: {
        labels: chartLabels,
        datasets: [{
          label: opt.title,
          data: chartData,
          backgroundColor: gradientFill,
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
      backgroundColor: `rgba(${opt.color}, 0.2)`,
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
  const body = document.body
  const title = document.getElementById('title')
  if (e) {
    darkModeToggle.checked = true
    body.classList.remove('bg-near-white')
    body.classList.add('bg-near-black', 'white')
    title.classList.remove('black')
    title.classList.add('white')
    chart.collection.map((chart) => {
      chart.options.scales.x.gridLines.color = 'rgba(255,255,255,0.1)'
      chart.options.scales.y.gridLines.color = 'rgba(255,255,255,0.1)'
      chart.update()
    })
    updateElements('b--black-10', 'b--white-10')
  } else {
    body.classList.add('bg-near-white')
    body.classList.remove('bg-near-black', 'white')
    title.classList.add('black')
    title.classList.remove('white')
    chart.collection.map((chart) => {
      chart.options.scales.x.gridLines.color = 'rgba(0,0,0,0.1)'
      chart.options.scales.y.gridLines.color = 'rgba(0,0,0,0.1)'
      chart.update()
    })
    updateElements('b--white-10', 'b--black-10')
  }
}

darkModeToggle.addEventListener('change', (e) => {
  darkMode(e.target.checked)
  localStorage.setItem('darkMode', e.target.checked)
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
      chart.update()
    })
  }, false)
}
