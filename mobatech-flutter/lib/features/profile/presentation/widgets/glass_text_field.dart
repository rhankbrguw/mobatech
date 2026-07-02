import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/widgets/app_text_field.dart';

class GlassTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;
  final bool readOnly;
  final String? prefixText;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final Function(String)? onChanged;

  const GlassTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.prefixText,
    this.formatters,
    this.validator,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hint: 'Masukkan ${label.toLowerCase()}',
      controller: controller,
      prefixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          if (prefixText != null) ...[
            const SizedBox(width: 8),
            Text(
              prefixText!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ]
        ],
      ),
      keyboardType: keyboardType,
      readOnly: readOnly,
      inputFormatters: formatters,
      validator: validator,
      onTap: onTap,
      onChanged: onChanged ?? (val) {
        if (label == 'Nomor Telepon') {
          if (val.startsWith('62')) {
            controller.text = val.substring(2);
            controller.selection = TextSelection.collapsed(offset: controller.text.length);
          } else if (val.startsWith('0')) {
            controller.text = val.substring(1);
            controller.selection = TextSelection.collapsed(offset: controller.text.length);
          }
        }
      },
    );
  }
}
