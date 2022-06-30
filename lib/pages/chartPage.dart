//first we import all the package that we need
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../database/entities/series.dart';
import '../repository/databaseRepository.dart';

class ChartPage extends StatefulWidget {
  List<double>?
      Chart; //List that contain data collected from page sensorPage, it's mandatory, but if there isn't
  // data inside we will show an empty graph
  ChartPage({Key? key, required this.Chart}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  // here we have some variables that we use for setting the graph parameter
  double? maxX = 2;
  double? maxY = 2;
  double? minX = 0;
  double? minY = -2;
  double? newX = 0;
  double? newY = 0;
  //variables for the graph and functions we'll se after
  Timer? timer;
  int? count = 0;
  double? meanA = 0;
  double? meanT = 0;
  var sensorData;
  List<double> time_and_acc = [];

  List<FlSpot>? allData = [
    const FlSpot(0, 0)
  ]; //list of point that we will see in the graph

  //the following function is a function that set our graph with the data that we collect from sensorPage.
  //this graph will be a static one 'cause in this page we want to see all the data together
  void _chart() {
    var dataCollection = start();
    time_and_acc = _reps(dataCollection);
    count = time_and_acc.first.round();
    meanT = time_and_acc.last;
    setState(() {
      maxX = dataCollection.length.toDouble() * 0.125;
    });
    //beacuse we collect data every 0.125 seconds
    double ameanA = _mean(dataCollection);
    meanA = double.parse(ameanA.toStringAsFixed(3));
    double b = 0;
    // with this cycle we put our data collection in allData for the rappresentation
    //in the graph and we set the y axis for a better vision
    while (b < dataCollection.length) {
      allData!.add(FlSpot(b / 8, dataCollection.elementAt(b.toInt())));
      if (dataCollection.elementAt(b.toInt()) > maxY!) {
        maxY = dataCollection.elementAt(b.toInt()) + 1;
      }
      if (dataCollection.elementAt(b.toInt()) < minY!) {
        minY = dataCollection.elementAt(b.toInt()) - 1;
      }
      b += 1;
    }
  }

// this function calculate and return the mean acceleration of the data collection
  double _mean(List<double> a) {
    int len = 0;
    double media = 0;
    while (len < a.length) {
      media += a.elementAt(len).abs();
      len += 1;
    }
    media = media / a.length;
    return media;
  }

// _reps is a function that calculate number of reps the user do and also calculate the
//mean time for one reps and the time for every reps
  List<double> _reps(List<double> a) {
    List<double> meanTimeAcc =
        []; // this variable will have in first position the
    // number of reps, in second position mean time for a reps
    for (var i = 0; i < a.length; i++) {
      if (a[i] > 0) {
        a[i] = a[i] * 2;
      }
    }

    List lst = [a[0]];
    //moving averange filter with n=3
    for (var i = 1; i < a.length - 1; i++) {
      lst.add((a[i - 1] + a[i + 1]) / 2);
    }
    lst.add(a[a.length - 1]);

    for (var i = 0; i < lst.length; i++) {
      if (lst[i] > 0) {
        lst[i] = lst[i] * lst[i];
      }
    }

    List instants = [];
    int reps = 0;
    const interval = 0.125;
    const lim = 1.25;
    for (var i = 0; i < lst.length - 16; i++) {
      if (lst[i] > lim) {
        if (lst[i + 1] > lim) {
          reps = reps + 1;
          instants.add(i);
          lst[i + 1] = 0.0;
          lst[i + 2] = 0.0;
          lst[i + 3] = 0.0;
          lst[i + 4] = 0.0;
          lst[i + 5] = 0.0;
          lst[i + 6] = 0.0;
          lst[i + 7] = 0.0;
          lst[i + 8] = 0.0;
          lst[i + 9] = 0.0;
          lst[i + 10] = 0.0;
          lst[i + 11] = 0.0;
          lst[i + 12] = 0.0;
          lst[i + 13] = 0.0;
          lst[i + 14] = 0.0;
          lst[i + 15] = 0.0;
          lst[i + 16] = 0.0;
        }
      }
    }
    meanTimeAcc.add(reps.toDouble());
    var T;
    List durations = [];
    for (var i = 1; i < instants.length; i++) {
      T = (instants[i] - instants[i - 1]) * interval;
      durations.add(T);
    }
    var m = 0.0;
    for (var i = 0; i < durations.length; i++) {
      m = m + durations[i];
    }
    var mean = m / durations.length;
    meanTimeAcc.add(mean);
    return meanTimeAcc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        centerTitle: true,
        title: const Text('Grafici analisi accelerazione',
            style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30),
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow, width: 3),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: Colors.deepOrange,
                      ),
                      SizedBox(width: 10),
                      const Text(
                        'GRAFICO ACCELERAZIONE asse Y',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            //here we use sizeBox+Linechart for showing our data in the graph
            SizedBox(
              width: 350,
              height: 350,
              child: SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: LineChart(
                  LineChartData(
                      borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          )),
                      gridData: FlGridData(
                          show: true,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                                color: Colors.white.withOpacity(0.5),
                                strokeWidth: 1);
                          },
                          drawVerticalLine: true,
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                                color: Colors.white.withOpacity(0.5),
                                strokeWidth: 1);
                          }),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                          ),
                        ),
                        rightTitles: AxisTitles(sideTitles: SideTitles()),
                        topTitles: AxisTitles(sideTitles: SideTitles()),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                          ),
                        ),
                      ),
                      maxX: maxX,
                      maxY: maxY,
                      minY: minY,
                      minX: minX,
                      lineBarsData: [
                        LineChartBarData(
                            spots: allData,
                            isCurved: true,
                            color: Colors.deepOrange,
                            barWidth: 5,
                            belowBarData: BarAreaData(show: false)),
                      ]),
                ),
              ),
            ),
            Column(children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 40),
                        child: ElevatedButton(
                          onPressed: _chart, //when we press we create our chart
                          style: ElevatedButton.styleFrom(
                            primary: Colors.yellow,
                            onPrimary: Colors.black,
                          ),
                          child: const Text('SHOW CHART'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 40),
                        child: ElevatedButton(
                          onPressed: () async {
                            await Provider.of<DatabaseRepository>(context,
                                    listen: false)
                                .insertSeries(
                                    Series(null, count, meanA!, meanT!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Saved",
                                  textAlign: TextAlign.center,
                                ),
                                duration: Duration(milliseconds: 1500),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.yellow,
                            onPrimary: Colors.black,
                          ),
                          child: const Text('SAVE DATA'),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 40),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.yellow,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'REPS :',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$count',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ]),
                    ),
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }

  //this method take the data we pass through sensorPage and put it in a
  // list
  List<double> start() {
    sensorData = widget.Chart;
    return sensorData;
  }
}
