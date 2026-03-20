import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────
  static const Color gudeRed     = Color(0xFFE30613); // Primary brand red
  static const Color gudeRedDark = Color(0xFFC0000F); // Pressed / dark variant
  static const Color gudeRedLight= Color(0xFFFF3B3B); // Light variant / illustrations

  // ── Neutral ────────────────────────────────────────────
  static const Color white       = Color(0xFFFFFFFF);
  static const Color offWhite    = Color(0xFFF8F8F8);
  static const Color surface     = Color(0xFFF2F2F2);
  static const Color border      = Color(0xFFE0E0E0);
  static const Color divider     = Color(0xFFEEEEEE);

  // ── Text ───────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint      = Color(0xFF9E9E9E);
  static const Color textOnRed     = Color(0xFFFFFFFF);

  // ── Stability Score ────────────────────────────────────
  static const Color stable   = Color(0xFF4CAF50); // Green
  static const Color watch    = Color(0xFFFFC107); // Yellow
  static const Color atRisk   = Color(0xFFFF9800); // Orange
  static const Color critical = Color(0xFFF44336); // Red

  // ── Functional ─────────────────────────────────────────
  static const Color success  = Color(0xFF4CAF50);
  static const Color warning  = Color(0xFFFFC107);
  static const Color error    = Color(0xFFF44336);
  static const Color info     = Color(0xFF2196F3);

  // ── Dark Mode ──────────────────────────────────────────
  static const Color darkBg       = Color(0xFF121212);
  static const Color darkSurface  = Color(0xFF1E1E1E);
  static const Color darkCard     = Color(0xFF252525);
  static const Color darkBorder   = Color(0xFF333333);
  static const Color darkText     = Color(0xFFE0E0E0);
}
