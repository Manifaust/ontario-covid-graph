const reportURL = '/ontario-covid-graph/report.json'

const report = fetch(reportURL).then((response) => {
  return response.json();
}).then((data) => {
  chartData.render(
    document.getElementById('growthFactorChart'),
    data,
    'Growth Factor (Total Cases)',
    'growth_factor_total_cases',
    `255, 99, 132`,
    6
  )

  chartData.render(
    document.getElementById('totalCases'),
    data,
    'Total Cases',
    'total_cases',
    `54, 162, 235`
  )

  chartData.render(
    document.getElementById('newInfectedCases'),
    data,
    'New Infected Cases',
    'new_infected_cases',
    `255, 159, 64`
  )
})

const chartData = {
  render: (context, contextData, label, dataKey, rgb, maxValue) => {
    const chartLabels =  contextData.map(i => i.date)
    const chartData = contextData.map(i => i[dataKey])
    const myChart = new Chart(context, {
        type: 'line',
        data: {
          labels: chartLabels,
          datasets: [{
              label: label,
              data: chartData,
              backgroundColor: [
                `rgba(${rgb}, 0.2)`
              ],
              borderColor: [
                `rgba(${rgb}, 1)`
              ],
              borderWidth: 1,
          }]
        },
        options: {
          scales: {
            yAxes: [{
              ticks: {
                beginAtZero: true,
                max: maxValue
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
    });
  }
}

