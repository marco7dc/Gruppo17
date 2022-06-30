//import the packages

import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prova1/pages/chartPage.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorPage extends StatefulWidget {
  SensorPage({Key? key}) : super(key: key);

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  //in this 3 variables we store instant for instant the value of our sensor
  // they are lists of 3 elements one value for each axis of the sensor
  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  int? count = 0;
  double? second = 0.125;
// some variable for the chart and the visualization of the page
  UserAccelerometerEvent? accelerometerValues;
  String acc_x = '';
  String acc_y = '';
  List<double> list_acc_y = [0]; //list of accelerations from
  //axis y of the accelerometer

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  //some variables that we use for control the buttons and the graph
  bool _stop = false;
  double? maxX = 2;
  double? maxY = 2;
  double? minX = 0;
  double? minY = -2;
  double? newX = 0;
  double? newY = 0;
  Timer? timer;
  // two lists of acceleration, Y_Acc is the data we collect from the axis y of the accelerometer
  List<FlSpot>? Y_Acc = [
    const FlSpot(0, 0),
  ];
  List<FlSpot>? X_Acc = [
    const FlSpot(0, 0),
  ];

  @override
  Widget build(BuildContext context) {
    // this variables will be show in our page with only 1 decimal
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();

    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
        title: const Text('Raccolta Dati'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                width: 275,
                height: 75,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 3),
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
                          'accelerometro asse Y',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          color: Colors.amber.withOpacity(0.2),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'accelerometro asse X',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: 400,
            height: 300,
            margin: const EdgeInsets.only(right: 10),
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
                          reservedSize: 15,
                        ),
                      ),
                      rightTitles: AxisTitles(sideTitles: SideTitles()),
                      topTitles: AxisTitles(sideTitles: SideTitles()),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 15,
                        ),
                      ),
                    ),
                    maxX: maxX,
                    maxY: maxY,
                    minY: minY,
                    minX: minX,
                    lineBarsData: [
                      LineChartBarData(
                          spots: Y_Acc,
                          isCurved: true,
                          color: Colors.deepOrange,
                          barWidth: 5,
                          belowBarData: BarAreaData(show: false)),
                      LineChartBarData(
                          spots: X_Acc,
                          isCurved: true,
                          color: Colors.amber.withOpacity(0.2),
                          barWidth: 5,
                          belowBarData: (BarAreaData(show: false))),
                    ]),
              ),
            ),
          ),
          Container(
            width: 300,
            height: 160,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Accelerometer: $accelerometer',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Stack(
                    children: <Widget>[
                      Text(
                        'UserAccelerometer: $userAccelerometer',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Gyroscope: $gyroscope',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChartPage(Chart: list_acc_y),
                          ));
                    },
                    child: const Text('CHART'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.black // Background color
                        ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _RefreshChart,
                  child: Text('REFRESH'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.black, // Background color
                  ),
                ),
                ElevatedButton(
                  onPressed: _setChart,
                  child: Text('STAMPA'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.black, // Background color
                  ),
                ),
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: Text('STOP'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.black, // Background color
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

//this function refresh the chart
  void _RefreshChart() {
    setState(() {
      List<FlSpot>? temp = [
        const FlSpot(0, 0),
      ];
      Y_Acc = temp;
      X_Acc = temp;
      maxX = 2;
      maxY = 2;
      minX = 0;
      minY = -2;
      newX = 0;
      newY = 0;
      count = 0;
      second = 0.125;
      list_acc_y = [0];
      _stop = false;
    });
  }

// this function set every 0.125 second the new value and put it in the chart dinamically
// with the use of a timer
  void _setChart() {
    Timer.periodic(const Duration(milliseconds: 125), (timer) {
      setState(() {
        if (!_stop) {
          var a_x = acc_x;
          var a_y = acc_y;
          var temp = double.parse(acc_y);
          list_acc_y.add(temp);

          if (temp > maxY!) maxY = temp;
          if (temp < minY!) minY = temp;

          if (second! + 0.125 > maxX!) {
            maxX = maxX! + 0.125;
            minX = minX! + 0.125;
          }
          if (Y_Acc!.first.x < minX!) Y_Acc!.removeAt(0);

          if (X_Acc!.first.x < minX!) X_Acc!.removeAt(0);
          newX = second! - 0.125;
          second = second! + 0.125;

          newY = double.parse(a_x);
          X_Acc!.add(FlSpot(newX!, newY!));

          newY = double.parse(a_y);
          Y_Acc!.add(FlSpot(newX!, newY!));
        } else {
          timer.cancel(); // if i pressd 'stop button'
        }
      });
    });
  }

  // condition that we will use for stopping the setChart function
  void _stopTimer() {
    _stop = true;
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

//this functoins permit us to put our sensor data inside a variable
  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          setState(() {
            _userAccelerometerValues = <double>[event.x, event.y, event.z];
            accelerometerValues = event;
            acc_x = event.x.toStringAsFixed(1);
            acc_y = event.y.toStringAsFixed(1);
          });
        },
      ),
    );
  }
}
