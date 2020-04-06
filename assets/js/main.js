const reportURL = '/ontario-covid-graph/report.json'

const report = fetch(reportURL).then((response) => {
  return response.json()
}).then((data) => {
  chartData.render({
    ele: document.getElementById('growthFactorChart'),
    data: data,
    title: 'Growth Factor (Total Cases)',
    key: 'growth_factor_total_cases',
    color: `255, 99, 132`,
    maxValue: 6
  })

  chartData.render({
    ele: document.getElementById('totalCases'),
    data: data,
    title: 'Total Cases',
    key: 'total_cases',
    color: `54, 162, 235`
  })

  chartData.render({
    ele: document.getElementById('newCases'),
    data: data,
    title: 'New Cases',
    key: 'new_total_cases',
    color: `255, 159, 64`
  })

  chartData.render({
    ele: document.getElementById('infectedResolvedDeaths'),
    data: data,
    title: 'Infected',
    key: 'infected',
    color: `153, 102, 255`,
    subCharts: [{
      title: 'Deaths',
      key: 'deaths',
      color: `0, 0, 0`
    },{
      title: 'Resolved',
      key: 'resolved',
      color: `6, 255, 129`
    }]
  })
})

function addData(opt) {
  opt.chart.data.datasets.push({
    label: opt.title,
    backgroundColor: [
      `rgba(${opt.color}, 0.2)`
    ],
    borderColor: [
      `rgba(${opt.color}, 1)`
    ],
    borderWidth: 1,
    data: opt.subChartData
  })
  opt.chart.update()
}

const chartData = {
  render: (opt) => {
    const chartLabels = opt.data.map(i => i.date)
    const chartData = opt.data.map(i => i[opt.key])
    const myChart = new Chart(opt.ele, {
        type: 'line',
        data: {
          labels: chartLabels,
          datasets: [{
            label: opt.title,
            data: chartData,
            backgroundColor: [
              `rgba(${opt.color}, 0.2)`
            ],
            borderColor: [
              `rgba(${opt.color}, 1)`
            ],
            borderWidth: 1,
          }]
        },
        options: {
          scales: {
            yAxes: [{
              ticks: {
                beginAtZero: true,
                max: opt.maxValue
              }
            }],
            xAxes: [{
              type: 'time',
              time: {
                unit: 'day'
              }
            }]
          }
        }
    })

    if (opt.subCharts) {
      const addSubCharts = opt.subCharts.map(i =>
        addData({
          chart: myChart,
          title: i.title,
          color: i.color,
          subChartData: opt.data.map(e => e[i.key])
        })
      )
    }
  }
}

