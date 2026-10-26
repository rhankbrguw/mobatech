import 'package:flutter/services.dart';

class PhonePrefixFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'[^\d+]'), '');

    if (text.startsWith('+62')) {
      text = text.substring(3);
    } else if (text.startsWith('62')) {
      text = text.substring(2);
    }

    if (text.startsWith('0')) {
      text = text.substring(1);
    }

    text = text.replaceAll(RegExp(r'\D'), '');
    if (text.length > 12) text = text.substring(0, 12);

    final buf = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 3 || i == 7) buf.write('-');
      buf.write(text[i]);
    }

    final formatted = buf.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
