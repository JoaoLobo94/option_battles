import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PriceChart extends StatelessWidget {
  final List<double> priceData;
  final List<double> firstPrice;

  const PriceChart({Key? key, required this.priceData, required this.firstPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 10,
        minY: priceData.reduce((min, price) => min < price ? min : price) - 2,
        maxY: priceData.reduce((max, price) => max > price ? max : price) + 2,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(priceData.length, (index) {
              return FlSpot(index.toDouble(), priceData[index]);
            }),
            dotData: const FlDotData(
              show: false,
            ),
            isCurved: true,
            color: _getColor(priceData.last, firstPrice.first, false),
            belowBarData: BarAreaData(show: true, color: _getColor(priceData.last, firstPrice.first, true), ),
          ),


        ],
        extraLinesData: ExtraLinesData(
          extraLinesOnTop: true,
          horizontalLines: [
            HorizontalLine(
              y: firstPrice[0],
              color: Colors.red,
              strokeWidth: 2,
              dashArray: [5, 2],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(right: 5, bottom: 5),
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                labelResolver: (line) => 'Start Price: ${line.y}',
              ),
            ),
          ],
        ),
        gridData: FlGridData(show: true,
          drawVerticalLine: false,
          drawHorizontalLine: true,
          horizontalInterval: 0.5, // Set the interval for horizontal lines
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Colors.grey,
              strokeWidth: 1,
              dashArray: [5, 2],
            );
          },
        ),
        titlesData: FlTitlesData(show: true,
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 46,
                getTitlesWidget: leftTitleWidgets,
              ),
          )
        ),
      ),
    );
  }


  Color _getColor(double priceData, double firstPrice, bool hasOpacity) {
    if (priceData > firstPrice) {
      return hasOpacity ? Colors.green.withOpacity(0.2) : Colors.greenAccent;
    } else if (priceData < firstPrice) {
      return hasOpacity ? Colors.red.withOpacity(0.2) : Colors.redAccent;
    } else {
      return hasOpacity ? Colors.blue.withOpacity(0.2) : Colors.blueAccent;
    }
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
     TextStyle style = TextStyle(
      color: _getColor(value,firstPrice[0], false),
      fontSize: 10,
    );

    String text = '${value}';

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }
}
