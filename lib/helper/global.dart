import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:e_maintenance/model/app_models.dart';

class AppDateUtils {
  const AppDateUtils._();

  static final DateFormat _apiFormatter = DateFormat('yyyy-MM-dd');
  static final DateFormat _displayFormatter = DateFormat('dd-MM-yyyy');

  static String todayApiString() => _apiFormatter.format(DateTime.now());

  static String formatDisplay(String value) {
    if (value.trim().isEmpty) {
      return '-';
    }

    try {
      return _displayFormatter.format(DateTime.parse(value));
    } catch (_) {
      return value;
    }
  }

  static String formatApi(DateTime value) => _apiFormatter.format(value);

  static DateTime? parseApi(String value) {
    if (value.trim().isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  static List<String> buildDateRange(String startDate, String endDate) {
    final start = parseApi(startDate);
    final end = parseApi(endDate);
    if (start == null || end == null) {
      return <String>[];
    }

    final values = <String>[];
    for (var date = start; !date.isAfter(end); date = date.add(const Duration(days: 1))) {
      values.add(formatApi(date));
    }
    return values;
  }
}

class AppHelpers {
  const AppHelpers._();

  static String serialForReport(String rawValue) {
    if (rawValue.isEmpty) {
      return '';
    }

    if (rawValue.startsWith('0') && rawValue.length > 3) {
      return rawValue.substring(3);
    }

    return rawValue;
  }

  static String inspectionLabel(String id) {
    return InspectionKind.fromId(id).label;
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
