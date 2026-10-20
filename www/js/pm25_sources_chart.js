document.addEventListener('DOMContentLoaded', function () {
  var chartDom = document.getElementById('main');
  var myChart = echarts.init(chartDom);
  var option;

  const Icons = {
    Car: './car_van_2_icon_png.png', //ROOT_PATH + '/data/asset/img/weather/sunny_128.png',
    Overcrowding: './25694.png',
    Job: './briefcase_2_icon_png.png',
    Ownership: 'key.png',
    Energy: './icons/bolt-solid.png',
    Manufacturing: './icons/oil-well-solid.png',
    Industrial: './icons/industry-solid.png',
    Residential: './25694.png',
    Agriculture: './icons/tractor-solid.png',
    Road: './car_icon_png.png',
    Fugitive: './icons/smog-solid.png',
    NonRoad: './icons/ship-solid.png',
  };

  const seriesLabel = {
    show: true
  };
  option = {
    title: {
      //text: 'Townsend Deprivation'
    },
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
      }
    },
    legend: {
      //data: ['City Alpha', 'City Beta', 'City Gamma', 'City Delta']
    },
    grid: {
      left: 100
    },
    toolbox: {
      show: true,
      feature: {
        saveAsImage: {}
      }
    },
    xAxis: {
      type: 'value',
      //name: '%',
      // axisLabel: {
      //   formatter: '{value}',
      //   textStyle: {
      //     align: 'right'
      //   }
      // },
      splitLine: { show: false },
      axisLine: { show: false },
      axisTick: { show: false },
      axisLabel: { show: false },
    },
    yAxis: {
      splitLine: { show: false },
      axisLine: { show: false },
      axisTick: { show: false },
      type: 'category',
      inverse: false,
      data: [
        'Energy',
        'Manufacturing',
        'Industrial',
        'Residential',
        'Agriculture',
        'Road',
        'Fugitive',
        'NonRoad'
      ],
      axisLabel: {
        align: 'right',
        textStyle: {
          align: 'right'
        },
        formatter: function (value) {
          return '{' + value + '| }';
        },
        margin: 20,
        rich: {
          Manufacturing: {
            height: 30,
            width: 30,
            align: 'right',
            backgroundColor: {
              image: Icons.Manufacturing
            },
            borderRadius: 10,
            borderWidth: 0,
            borderColor: '#ff8811'
          },
          Energy: {
            height: 30,
            width: 30,
            align: 'right',
            backgroundColor: {
              image: Icons.Energy
            },
            borderRadius: 10,
            borderWidth: 0,
            borderColor: '#ff8811'
          },
          Industrial: {
            height: 30,
            width: 30,
            align: 'right',
            backgroundColor: {
              image: Icons.Industrial
            },
            borderRadius: 10,
            borderWidth: 0,
            borderColor: '#ff8811'
          },
          Residential: {
            height: 30,
            width: 30,
            align: 'right',
            backgroundColor: {
              image: Icons.Residential
            },
            borderRadius: 10,
            borderWidth: 0,
            borderColor: '#ff8811'
          },
          Road: {
            height: 30,
            width: 30,
            align: 'right',
            backgroundColor: {
              image: Icons.Road
            },
            borderRadius: 10,
            borderWidth: 0,
            borderColor: '#ff8811'
          },
          Agriculture: {
            height: 30,
            width: 30,
            align: 'right',
            backgroundColor: {
              image: Icons.Agriculture
            },
            borderRadius: 10,
            borderWidth: 0,
            borderColor: '#ff8811'
          },
          Fugitive: {
            height: 30,
            width: 30,
            align: 'right',
            backgroundColor: {
              image: Icons.Fugitive
            },
            borderRadius: 10,
            borderWidth: 0,
            borderColor: '#ff8811'
          },
          NonRoad: {
            height: 30,
            width: 30,
            align: 'right',
            backgroundColor: {
              image: Icons.NonRoad
            },
            borderRadius: 10,
            borderWidth: 0,
            borderColor: '#ff8811'
          }
        }
      }
    },
    series: [
      {
        name: 'PM2.5',
        type: 'bar',
        itemStyle: {
          borderRadius: 5,
          color: '#000000'
        },
        data: [3.3, 16.1, 12.9, 43.1, 4.0, 12.4, 1.1, 3.6]
      }
    ]
  };

  option && myChart.setOption(option);
}); // DOMContentLoaded
