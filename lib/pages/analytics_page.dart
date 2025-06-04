import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/income_entry.dart';
import '../models/expense_entry.dart';
import '../services/income_service.dart';
import '../services/expense_service.dart';
import '../services/app_settings_service.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  double totalIncome = 0;
  double totalExpenses = 0;
  double netIncome = 0;
  Map<String, double> expenseCategories = {};
  List<BarChartGroupData> barGroups = [];
  List<FlSpot> incomeSpots = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final incomeEntries = await IncomeService().getIncomes();
    final expenseEntries = await ExpenseService().getExpenses();

    final now = DateTime.now();
    final currentMonthIncome = incomeEntries
        .where((e) => e.date.month == now.month && e.date.year == now.year)
        .toList();
    final currentMonthExpenses = expenseEntries
        .where((e) => e.date.month == now.month && e.date.year == now.year)
        .toList();

    totalIncome = currentMonthIncome.fold(0, (sum, e) => sum + e.amount);
    totalExpenses = currentMonthExpenses.fold(0, (sum, e) => sum + e.amount);
    netIncome = totalIncome - totalExpenses;

    expenseCategories = {};
    for (final e in currentMonthExpenses) {
      expenseCategories[e.category] =
          (expenseCategories[e.category] ?? 0) + e.amount;
    }

    final Map<int, double> weeklyIncome = {};
    final Map<int, double> incomePerDay = {};

    for (final e in currentMonthIncome) {
      final week = ((e.date.day - 1) / 7).floor();
      weeklyIncome[week] = (weeklyIncome[week] ?? 0) + e.amount;
      incomePerDay[e.date.day] = (incomePerDay[e.date.day] ?? 0) + e.amount;
    }

    barGroups = weeklyIncome.entries.map((e) {
      return BarChartGroupData(x: e.key, barRods: [
        BarChartRodData(toY: e.value, color: Colors.green, width: 20),
      ]);
    }).toList();

    incomeSpots = incomePerDay.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
    incomeSpots.sort((a, b) => a.x.compareTo(b.x));

    setState(() {});
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPieChart(Map<String, double> data, String currency) {
    if (data.isEmpty) return Center(child: Text('no_data').tr());

    final sections = data.entries.map((e) => PieChartSectionData(
      title: '${e.key}\n${e.value.toStringAsFixed(2)}$currency',
      value: e.value,
      radius: 60,
      titleStyle: const TextStyle(fontSize: 12),
      color: Colors.cyan,
    )).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        barGroups: barGroups,
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text('W${value.toInt() + 1}'),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 30),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        maxY: barGroups.isNotEmpty
            ? barGroups.map((e) => e.barRods.first.toY).reduce((a, b) => a > b ? a : b) + 10
            : 100,
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: incomeSpots,
            isCurved: true,
            color: Colors.blueAccent,
            barWidth: 3,
            dotData: FlDotData(show: true),
          )
        ],
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 22),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsService>();
    final currency = settings.currency;

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSummaryCard('total_income'.tr(), '${totalIncome.toStringAsFixed(2)}$currency', Icons.attach_money, Colors.green),
                _buildSummaryCard('total_expenses'.tr(), '${totalExpenses.toStringAsFixed(2)}$currency', Icons.money_off, Colors.red),
                _buildSummaryCard('net_income'.tr(), '${netIncome.toStringAsFixed(2)}$currency', Icons.savings, Colors.blue),
                const SizedBox(height: 24),
                Text('expenses_by_category'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(height: 200, child: _buildPieChart(expenseCategories, currency)),
                const SizedBox(height: 32),
                Text('income_by_week'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(height: 200, child: _buildBarChart()),
                const SizedBox(height: 32),
                Text('income_trend_line'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(height: 200, child: _buildLineChart()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
