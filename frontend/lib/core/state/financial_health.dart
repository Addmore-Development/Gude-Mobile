// lib/core/state/financial_health.dart
//
// Single source of truth for the user's financial health.
// Import this anywhere you need the health score or status label.

class FinancialHealth {
  // ── Raw numbers ──────────────────────────────────────
  static const double monthlyBudget = 2000.0;
  static const double totalSpent    = 1780.0;
  static const double income        = 2450.0;

  // ── Derived score (0–100) ────────────────────────────
  // Simple formula: how much budget is left as a % of income
  static const double score = 31.0;

  // ── Thresholds ───────────────────────────────────────
  static bool get isHealthy   => score >= 70;
  static bool get isWatching  => score >= 45 && score < 70;
  static bool get isAtRisk    => score >= 25 && score < 45;
  static bool get isCritical  => score < 25;

  // Convenience booleans used in UI warnings
  static bool get needsWarning => score < 45;
  static bool get needsAlert   => score < 35;

  // ── Labels ───────────────────────────────────────────
  static String get label {
    if (isHealthy)  return 'Healthy';
    if (isWatching) return 'Watch';
    if (isAtRisk)   return 'At Risk';
    return 'Critical';
  }

  static String get emoji {
    if (isHealthy)  return '🟢';
    if (isWatching) return '🟡';
    if (isAtRisk)   return '🟠';
    return '🔴';
  }

  // Colour as a plain int so it can be used as const
  static int get colorValue {
    if (isHealthy)  return 0xFF10B981;
    if (isWatching) return 0xFFF59E0B;
    if (isAtRisk)   return 0xFFEF4444;
    return 0xFF7F1D1D;
  }

  // ── Welcome-card subtitle (used on HomePage) ─────────
  static String get homepageSubtitle {
    if (isHealthy)  return 'Your finances are in great shape 💪';
    if (isWatching) return 'Keep an eye on your spending';
    if (isAtRisk)   return 'Your spending needs attention ⚠️';
    return 'Financial situation is critical — act now 🔴';
  }

  // ── Status badge label (used on HomePage) ────────────
  static String get statusBadge {
    if (isHealthy)  return 'Stable';
    if (isWatching) return 'Watch';
    if (isAtRisk)   return 'At Risk';
    return 'Critical';
  }

  static int get badgeColorValue {
    if (isHealthy)  return 0xFF10B981; // green
    if (isWatching) return 0xFFF59E0B; // amber
    return 0xFFEF4444;                 // red
  }
}