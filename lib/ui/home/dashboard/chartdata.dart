import 'package:flutter/material.dart';

class ChartData {
  final String x;
  final int y;
  final Color color;

  ChartData(this.x, this.y, {this.color = Colors.blue});
}

class SalesData {
  SalesData(this.category, this.sales);

  final String category;
  final double sales;
}

class CustomerType {
  final String month;
  final int sales;

  CustomerType(this.month, this.sales);
}
