import QtCharts 2.0
import QtQuick 2.0

ChartView {
  title: pypie.title
  objectName: "chartView"
  titleColor: "white"
  backgroundColor: "white"
  legend.labelColor: "red"
  legend.alignment: Qt.AlignRight
  antialiasing: true

  BarSeries {
    id: barChartId
    objectName: "barChart"
    axisX: BarCategoryAxis {categories: pypie.categories}
    axisY: ValueAxis {
      id: axisY
      min: pypie.mini
      max: pypie.maxi
    }
  }

  // PieSeries {
  //   id: pieChartId
  //   objectName: "pieChart"
  //   title: "Pie Chart"
  //   labelsVisible: true
  //   labelsPosition: PieSlice.LabelInsideHorizontal
  //   PieSlice {label: "Slice 1"; value: 10; color: "red"}
  //   PieSlice {label: "Slice 2"; value: 20; color: "green"}
  //   PieSlice {label: "Slice 3"; value: 30; color: "blue"}
  //   PieSlice {label: "Slice 4"; value: 40; color: "yellow"}
  //   }
  

  Component.onCompleted: {
    addBarSets()
  }

  // function addSlices() {
  //   var slices = pypie.slices
  //   for (var name in slices) {
  //     pieChartId.append(name, slices[name])
  //   }
  // }

  function addBarSets() {
    var barsets = pypie.barsets
    for (var name in barsets) {
      barChartId.append(name, barsets[name])
    }
  }
}