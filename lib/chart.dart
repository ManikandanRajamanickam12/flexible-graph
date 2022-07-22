import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<ChartData> chartData = [];
  List newdata = [];
  List data = [];
  var timecheck = DateTime.parse("2022-12-20 10:11:25").minute;
  @override
  void initState() {
    // TODO: implement initState
    check();
    super.initState();
  }

  check() {
    var rngtwo = Random();
    DateTime time = DateTime.now();

    if (chartData.isEmpty) {
      chartData.add(ChartData(DateTime.now(), 0));
    } else {
      chartData.add(ChartData(time, rngtwo.nextInt(50)));
    }

    if (time.minute != timecheck) {
      chartData.clear();
    }

    timecheck = time.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    check();
                  });
                },
                child: Text("Generate")),
          ),
          Container(
              width: 1500,
              height: 800,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                title: ChartTitle(text: 'Latency Graph'),
                legend: Legend(
                    isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                // primaryXAxis: NumericAxis(
                //     maximum: 60,
                //     minimum: 0,
                //     labelFormat: '{value}',
                //     axisLine: const AxisLine(width: 0),
                //     majorTickLines:
                //         const MajorTickLines(color: Colors.transparent)),
                primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat.jms(),
                    intervalType: DateTimeIntervalType.seconds
                    // axisLabelFormatter: (AxisLabelRenderDetails details) {
                    //   return ChartAxisLabel(
                    //       "Chart Axis${details.value.toString()}", const TextStyle());
                    // },
                    // labelFormat: "{value}"),
                    ),
                primaryYAxis: NumericAxis(
                    labelFormat: '{value}',
                    axisLine: const AxisLine(width: 0),
                    majorTickLines:
                        const MajorTickLines(color: Colors.transparent)),
                series: <ChartSeries>[
                  ScatterSeries<ChartData, DateTime>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                  )
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              )),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final int y;
}
