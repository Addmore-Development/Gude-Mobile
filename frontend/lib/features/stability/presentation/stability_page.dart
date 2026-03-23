import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';

class StabilityPage extends StatefulWidget {
  const StabilityPage({super.key});
  @override
  State<StabilityPage> createState() => _StabilityPageState();
}

class _StabilityPageState extends State<StabilityPage> {
  final _score = 72;

  Color get _scoreColor {
    if (_score >= 75) return const Color(0xFF4CAF50);
    if (_score >= 50) return const Color(0xFFFF9800);
    if (_score >= 25) return const Color(0xFFFF5722);
    return const Color(0xFFF44336);
  }

  String get _scoreLabel {
    if (_score >= 75) return 'Stable';
    if (_score >= 50) return 'Watch';
    if (_score >= 25) return 'At Risk';
    return 'Critical';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildScoreCard(),
              _buildMetrics(),
              _buildCheckIn(context),
              _buildAlerts(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      color: Colors.white,
      child: const Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Stability Score', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              Text('Your student wellness overview', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 160, height: 160,
                child: CircularProgressIndicator(
                  value: _score / 100,
                  strokeWidth: 12,
                  backgroundColor: _scoreColor.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(_scoreColor),
                ),
              ),
              Column(
                children: [
                  Text('$_score', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: _scoreColor)),
                  Text(_scoreLabel, style: TextStyle(fontSize: 16, color: _scoreColor, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _indicator('Green', const Color(0xFF4CAF50), _score >= 75),
              _indicator('Yellow', const Color(0xFFFF9800), _score >= 50 && _score < 75),
              _indicator('Orange', const Color(0xFFFF5722), _score >= 25 && _score < 50),
              _indicator('Red', const Color(0xFFF44336), _score < 25),
            ],
          ),
        ],
      ),
    );
  }

  Widget _indicator(String label, Color color, bool active) {
    return Column(
      children: [
        Container(
          width: 16, height: 16,
          decoration: BoxDecoration(
            color: active ? color : color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: active ? color : AppColors.textGrey,
          fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
      ],
    );
  }

  Widget _buildMetrics() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Health Metrics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _metricCard('Financial Health', 68, const Color(0xFF6C3CE1), Icons.account_balance_wallet_outlined)),
              const SizedBox(width: 12),
              Expanded(child: _metricCard('Marketplace Activity', 85, const Color(0xFF4ECDC4), Icons.storefront_outlined)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _metricCard('Engagement', 72, const Color(0xFFFF9800), Icons.psychology_outlined)),
              const SizedBox(width: 12),
              Expanded(child: _metricCard('Wellbeing', 60, const Color(0xFFE91E63), Icons.favorite_outline)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricCard(String label, int score, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark))),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: score / 100,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 6),
          Text('$score%', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildCheckIn(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.edit_note_outlined, color: AppColors.primary, size: 32),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weekly Check-In', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.textDark)),
                Text('How are you feeling this week?', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.push('/stability/checkin'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Start', style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildAlerts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Alerts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 12),
          _alert('Spending spike detected', 'Your food spending is 30% above budget', const Color(0xFFFF9800), Icons.warning_amber_outlined),
          _alert('Great marketplace activity!', 'You completed 3 jobs this week', const Color(0xFF4CAF50), Icons.check_circle_outline),
        ],
      ),
    );
  }

  Widget _alert(String title, String subtitle, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(subtitle, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
