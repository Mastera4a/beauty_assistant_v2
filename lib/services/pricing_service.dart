import 'package:beauty_assistant/models/user_settings.dart';
import 'package:beauty_assistant/services/app_settings_service.dart';

final settingsService = AppSettingsService();

class PricingService {
  final UserSettings settings;

  PricingService(this.settings);

  /// Количество клиентов в месяц
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

  /// Время на соцсети (в часах в месяц)
  double get _socialMediaHoursPerMonth => (settings.socialMediaMinutes * 4) / 60;

  /// Общее количество времени, затраченное на клиентов (в часах)
  double get _clientHours => (_monthlyClients * settings.timePerClientMinutes) / 60;

  /// Общие рабочие часы (клиенты + соцсети)
  double get _totalWorkHours => _clientHours + _socialMediaHoursPerMonth;

  /// Общие расходы в месяц
  double get _monthlyExpenses =>
      settings.avgMaterialCost +
      settings.rentTaxes +
      (settings.trainingCosts / 12) +
      settings.insuranceCost;

  /// Себестоимость (без учёта прибыли)
  double get costPerClient => _monthlyExpenses / _monthlyClients;

  /// Желаемый доход в месяц
  double get _targetIncome {
    if (settings.incomeUnit == 'hour') {
      return settings.desiredIncome * _totalWorkHours;
    } else {
      return settings.desiredIncome;
    }
  }

  /// Рекомендуемая цена за процедуру
  double get recommendedPricePerClient =>
      costPerClient + (settings.desiredIncome * (settings.timePerClientMinutes / 60));

  /// Чистый доход за месяц
  double get monthlyNetIncome =>
      (recommendedPricePerClient * _monthlyClients) - _monthlyExpenses;

  /// Проверка на минимальную цену
  bool get isBelowOptimal => recommendedPricePerClient < 50;

  /// Валюта (из глобальных настроек)
  String get currency => settingsService.currency;

  /// Единица времени (из глобальных настроек)
  String get timeUnit => settingsService.timeUnit;
}
