import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color palette
class DashboardColors {
  // Primary colors
  static const Color primary = Color(0xFF1E293B);
  static const Color primaryLight = Color(0xFF334155);
  static const Color secondary = Color(0xFF3B82F6);

  // Status colors
  static const Color pending = Color(0xFFF59E0B);
  static const Color confirmed = Color(0xFF3B82F6);
  static const Color shipped = Color(0xFF8B5CF6);
  static const Color delivered = Color(0xFF10B981);
  static const Color cancelled = Color(0xFFEF4444);

  // Background colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFE5E7EB);

  // Text colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // UI Element colors
  static const Color iconBackground = Color(0xFFECF5FF);
  static const Color buttonBlue = Color(0xFF3B82F6);
  static const Color statusBadgeBackground = Color(0xFFFFF7EC);
}

// Text styles
class DashboardTextStyles {
  static TextStyle heading = GoogleFonts.montserrat(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: DashboardColors.textPrimary,
  );

  static TextStyle sectionTitle = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static TextStyle cardTitle = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static TextStyle bodyText = GoogleFonts.montserrat(
    fontSize: 13,
    color: Colors.black54,
  );

  static TextStyle smallText = GoogleFonts.montserrat(
    fontSize: 11,
    color: Colors.black45,
  );

  static TextStyle statNumber = GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle statusText = GoogleFonts.montserrat(
    fontSize: 11,
    fontWeight: FontWeight.bold,
  );

  static TextStyle linkText = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: DashboardColors.buttonBlue,
  );
}

// Common decorations
class DashboardDecorations {
  static BoxDecoration cardDecoration = BoxDecoration(
    color: DashboardColors.cardBackground,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration statusBadgeDecoration(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
    );
  }

  static BoxDecoration statusCardDecoration(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.3)),
    );
  }

  static BoxDecoration iconContainerDecoration = BoxDecoration(
    color: DashboardColors.iconBackground,
    borderRadius: BorderRadius.circular(8),
  );
}
