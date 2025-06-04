import 'package:beauty_assistant/models/user_settings.dart';
import 'package:beauty_assistant/services/app_settings_service.dart';

final settingsService = AppSettingsService();

class PricingService {
  final UserSettings settings;

  PricingService(this.settings);

  /// Получаем количество клиентов в месяц на основе единицы измерения
  int get _monthlyClients {
    switch (settings.clientsUnit) {
      case 'day':
        return settings.clientsPerUnit * 30;
      case 'week':
        return settings.clientsPerUnit * 4;
      case 'month':
      default:
        return settings.clientsPerUnit;
    }
  }

  /// Общие ежемесячные расходы
  double get _totalExpenses =>
      settings.avgMaterialCost +
      settings.rentTaxes +
      settings.trainingCosts +
      settings.insuranceCost;

  /// Вычисляем желаемый доход за месяц
  double get _targetIncome {
    if (settings.incomeUnit == 'hour') {
      final totalMinutes = _monthlyClients * settings.timePerClientMinutes;
      return (totalMinutes / 60) * settings.desiredIncome;
    } else {
      return settings.desiredIncome;
    }
  }

  /// Рекомендуемая цена за клиента
  double get recommendedPricePerClient =>
      (_targetIncome + _totalExpenses) / _monthlyClients;

  /// Чистый доход за месяц (доход − расходы)
  double get monthlyNetIncome =>
      recommendedPricePerClient * _monthlyClients - _totalExpenses;

  /// Цена за клиента без желаемого дохода (себестоимость)
  double get costPerClient =>
      settings.avgMaterialCost +
      settings.rentTaxes / _monthlyClients +
      settings.trainingCosts / _monthlyClients +
      settings.insuranceCost / _monthlyClients;

  /// Проверка на минимальный порог
  bool get isBelowOptimal => recommendedPricePerClient < 50;

  /// Валюта (из глобальных настроек)
  String get currency => settingsService.currency;

  /// Единица времени (из глобальных настроек)
  String get timeUnit => settingsService.timeUnit;
}
