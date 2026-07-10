import 'package:intl/intl.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';

class Formatters {
  static String formatDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date.toLocal());
  }

  static String getDayOfWeekID(DateTime d) => CoreFormatters.daysOfWeek[d.toLocal().weekday - 1];

  static String getMonthID(DateTime d) => CoreFormatters.months[d.toLocal().month - 1];

  static String formatDateID(DateTime d) {
    final localD = d.toLocal();
    return '${localD.day.toString().padLeft(2, '0')} ${getMonthID(localD)} ${localD.year}';
  }

  static String formatDateWithDayID(DateTime d) => '${getDayOfWeekID(d)}, ${formatDateID(d)}';

  static String formatDateTimeWithDayID(DateTime d) {
    final localD = d.toLocal();
    final timeStr = '${localD.hour.toString().padLeft(2, '0')}:${localD.minute.toString().padLeft(2, '0')}';
    return '${formatDateWithDayID(localD)} • $timeStr';
  }

  static String parseAndFormatDateID(String dateStr) {
    if (dateStr.isEmpty || dateStr == '-') return '-';
    try {
      return formatDateID(DateTime.parse(dateStr).toLocal());
    } catch (e) {
      return dateStr;
    }
  }

  static String formatDateTimeID(DateTime d) {
    final localD = d.toLocal();
    final timeStr = '${localD.hour.toString().padLeft(2, '0')}:${localD.minute.toString().padLeft(2, '0')}';
    return '${formatDateID(localD)} $timeStr';
  }

  static String parseAndFormatDateTimeID(String dateStr) {
    if (dateStr.isEmpty || dateStr == '-') return '-';
    try {
      return formatDateTimeID(DateTime.parse(dateStr).toLocal());
    } catch (e) {
      return dateStr;
    }
  }

  static String formatDateTimeSecID(DateTime d) {
    final localD = d.toLocal();
    final timeStr = '${localD.hour.toString().padLeft(2, '0')}:${localD.minute.toString().padLeft(2, '0')}:${localD.second.toString().padLeft(2, '0')}';
    return '${formatDateID(localD)} $timeStr';
  }

  static String parseAndFormatDateTimeSecID(String dateStr) {
    if (dateStr.isEmpty || dateStr == '-') return '-';
    try {
      return formatDateTimeSecID(DateTime.parse(dateStr).toLocal());
    } catch (e) {
      return dateStr;
    }
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: CoreFormatters.localeID,
      symbol: CoreFormatters.currencySymbol,
      decimalDigits: 0,
    ).format(amount);
  }

  static String _cleanPhone(String phone) {
    String clean = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (clean.startsWith(CoreFormatters.phonePrefixIntl)) {
      clean = clean.substring(3);
    } else if (clean.startsWith(CoreFormatters.phonePrefixLocalIntl)) {
      clean = clean.substring(2);
    } else if (clean.startsWith(CoreFormatters.phonePrefixLocal)) {
      clean = clean.substring(1);
    }
    return '${CoreFormatters.phonePrefixIntl}$clean';
  }

  static String _formatCleanPhone(String cleanPhone, String prefix) {
    String localPart = cleanPhone.substring(3);
    if (localPart.length <= 3) return localPart.isEmpty ? cleanPhone : '$prefix $localPart';
    String p1 = localPart.substring(0, 3);
    String remainder = localPart.substring(3);
    if (remainder.length > 4) {
      return '$prefix $p1-${remainder.substring(0, 4)}-${remainder.substring(4)}';
    }
    return '$prefix $p1-$remainder';
  }

  static String formatPhoneNumber(String phone) {
    String cleanPhone = _cleanPhone(phone);
    if (cleanPhone.startsWith(CoreFormatters.phonePrefixIntl)) {
      return _formatCleanPhone(cleanPhone, CoreFormatters.phonePrefixIntl);
    }
    return cleanPhone;
  }
}
