import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color PRIMARY = Color(0xFF1E5E44); // Hermina green
  static const Color PRIMARY_GREEN = Color(0xFF1E5E44); // Alias
  static const Color PRIMARY_DARK = Color(0xFF113C2B);
  static const Color PRIMARY_LIGHT = Color(0xFFE8F5E9);
  static const Color BACKGROUND_WAVE = Color(0xFFBAC8EE);

  // Backgrounds
  static const Color BACKGROUND_SCREEN = Color(0xFFF8F9FA);
  static const Color BACKGROUND_WHITE = Color(0xFFFAFAFA);
  static const Color BACKGROUND_LIGHT_GREY = Color(0xFFF5F5F5);

  // Text
  static const Color TEXT_DARK = Color(0xFF1E1E1E);
  static const Color TEXT_GREY = Color(0xFF828282);
  static const Color TEXT_LIGHT_GREY = Color(0xFFBDBDBD);
  static const Color TEXT_WHITE = Color(0xFFFAFAFA);
  static const Color TEXT_WHITE70 = Color(0xB3FAFAFA);

  // Borders & Dividers
  static const Color BORDER_GREY = Color(0xFFE0E0E0);
  static const Color DIVIDER_GREY = Color(0xFFEEEEEE);

  // Icons
  static const Color ICON_GREY = Color(0xFF9E9E9E);
  static const Color ICON_LIGHT_GREY = Color(0xFFE0E0E0);

  // Status/Alerts
  static const Color ERROR_RED = Color(0xFFE53935);
  static const Color SUCCESS_GREEN = Color(0xFF4CAF50);
  static const Color WARNING_YELLOW = Color(0xFFFFB300);

  // Button disabled
  static const Color BUTTON_DISABLED = Color(0xFFEEEEEE);
  static const Color BUTTON_DISABLED_TEXT = Color(0xFFBDBDBD);

  // Specific
  static const Color AGENDA_HEADER = Color(0xFF265A8E);
  static const Color AGENDA_BACKGROUND = Color(0xFFFDF7E7);
  static const Color ASSISTANT_BACKGROUND = Color(0xFFF0F4FD);
  static const Color ASSISTANT_ICON_COLOR = Color(0xFF4F7396);
  static const Color ASSISTANT_BORDER = Color(0xFFE3EAFC);

  // Emergency
  static const Color EMERGENCY_DARK1 = Color(0xFF1A1A2E);
  static const Color EMERGENCY_DARK2 = Color(0xFF16213E);
  static const Color AMBULANCE_BLUE = Color(0xFF1565C0);
  static const Color AMBULANCE_BLUE_DARK = Color(0xFF0D47A1);
  static const Color ARRIVED_GREEN1 = Color(0xFF1B5E20);
  static const Color ARRIVED_GREEN2 = Color(0xFF2E7D32);

  // Transparent / Opacity
  static const Color TRANSPARENT = Colors.transparent;
  static Color SHADOW_COLOR = const Color(0xFF121212).withValues(alpha: 0.05);
  static Color OVERLAY_WHITE20 = AppColors.BACKGROUND_WHITE.withValues(
    alpha: 0.2,
  );
  static Color OVERLAY_PRIMARY15 = PRIMARY.withValues(alpha: 0.15);

  // Chatbot specific / additions
  static const Color ICON_ORANGE = Colors.orange;
  static const Color ICON_BLUE = Colors.blue;
  static const Color ICON_GREEN = Colors.green;

  static const Color GOOGLE_BLUE = Color(0xFF4285F4);
  static const Color GOOGLE_RED = Color(0xFFEA4335);
  static const Color GOOGLE_YELLOW = Color(0xFFFBBC05);
  static const Color GOOGLE_GREEN = Color(0xFF34A853);

  static Color BLACK10 = const Color(0xFF121212).withValues(alpha: 0.1);
  static Color WHITE85 = AppColors.BACKGROUND_WHITE.withValues(alpha: 0.85);
  static Color WHITE50 = AppColors.BACKGROUND_WHITE.withValues(alpha: 0.5);
  static Color GREY20 = Colors.grey.withValues(alpha: 0.2);
  static Color PRIMARY85 = PRIMARY.withValues(alpha: 0.85);
  static Color ORANGE10 = Colors.orange.withValues(alpha: 0.1);
  static Color ICON_WHITE30 = const Color(0x4DFAFAFA);

  // Warning
  static const Color WARNING_ORANGE = Colors.orange;
  static Color WARNING_LIGHT = Colors.orange.withValues(alpha: 0.1);

  static Color getGlassBackground(bool isDark) => isDark
      ? AppColors.BACKGROUND_WHITE.withValues(alpha: 0.05)
      : AppColors.BACKGROUND_WHITE.withValues(alpha: 0.7);
  static Color getGlassBorder(bool isDark) => isDark
      ? AppColors.BACKGROUND_WHITE.withValues(alpha: 0.1)
      : const Color(0xFF121212).withValues(alpha: 0.1);
  static Color getTextPrimary(bool isDark) =>
      isDark ? AppColors.BACKGROUND_WHITE : TEXT_DARK;
  static Color getTextSecondary(bool isDark) =>
      isDark ? const Color(0xB3FAFAFA) : TEXT_GREY;

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'menunggu':
      case 'requested':
        return WARNING_ORANGE;
      case 'approved':
      case 'disetujui':
      case 'processing':
        return GOOGLE_BLUE;
      case 'ready':
      case 'tersedia':
      case 'available':
        return Colors.purple;
      case 'completed':
      case 'selesai':
      case 'active':
      case 'aktif':
      case 'redeemed':
      case 'ditebus':
        return SUCCESS_GREEN;
      case 'cancelled':
      case 'dibatalkan':
      case 'unavailable':
      case 'rejected':
      case 'ditolak':
        return ERROR_RED;
      case 'dispatched':
        return AMBULANCE_BLUE_DARK;
      case 'arrived':
        return ARRIVED_GREEN1;
      default:
        return TEXT_GREY;
    }
  }

  static Color getStatusBgColor(String status) {
    return getStatusColor(status).withValues(alpha: 0.1);
  }
}
