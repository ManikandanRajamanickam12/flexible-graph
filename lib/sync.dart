import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Sync extends StatefulWidget {
  const Sync({Key? key}) : super(key: key);

  @override
  State<Sync> createState() => _SyncState();
}

class _SyncState extends State<Sync> {
  List<ChartData> chartData = [];

  int count = 0;
  dynamic prev = 0;
  dynamic now = 0;

  @override
  void initState() {
    // generate();
    super.initState();
  }

  generate() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      var rng = Random();
      count = count + rng.nextInt(10); // 7 for checking
      print(count);
      now = (count / 60).floor();
      if (now == prev) {
        chartData.add(ChartData(count, rng.nextInt(20)));
      } else {
        chartData.clear();
        chartData.add(ChartData(0, 0));
      }
      setState(() {
        prev = now;
      });
    });

    // if (count % 60 == 0) {
    //   chartData.clear();
    //   chartData.add(ChartData(0, 0));
    // } else {
    //   chartData.add(ChartData(count, rng.nextInt(20)));
    // }
  }

  num plot(x) {
    return x % 60;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        generate();
                      });
                    },
                    child: Text("Generate")),
              ),
            ],
          ),
          Container(
              width: 1500,
              height: 800,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                title: ChartTitle(text: 'Latency Graph'),
                legend: Legend(
                    isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                primaryXAxis: NumericAxis(minimum: 0, maximum: 60),
                primaryYAxis: NumericAxis(
                    labelFormat: '{value}',
                    axisLine: const AxisLine(width: 0),
                    majorTickLines:
                        const MajorTickLines(color: Colors.transparent)),
                series: <ChartSeries>[
                  ScatterSeries<ChartData, num>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => plot(data.x) as num,
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
  final int x;
  final int y;
}
