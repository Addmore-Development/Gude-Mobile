// lib/features/chatbot/services/ai_coach_service.dart

class CoachContext {
  final double walletBalance;
  final double monthlyBudget;
  final double totalSpent;
  final double income;
  final int stabilityScore;
  final String stabilityLabel;
  final int marketplaceActivity;
  final int missedCheckins;
  final String page;

  const CoachContext({
    this.walletBalance = 1234.50,
    this.monthlyBudget = 3000,
    this.totalSpent = 1830,
    this.income = 650,
    this.stabilityScore = 62,
    this.stabilityLabel = 'Steady',
    this.marketplaceActivity = 3,
    this.missedCheckins = 2,
    this.page = 'home',
  });
}

class CoachMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String> quickReplies;

  CoachMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.quickReplies = const [],
  }) : timestamp = timestamp ?? DateTime.now();
}

class AiCoachService {
  static String buildSystemPrompt(CoachContext ctx) {
    return '''
You are Coach Gude, a warm, motivating financial and wellbeing mentor for South African university students using the Gude app.

STUDENT SNAPSHOT:
- Wallet Balance: R${ctx.walletBalance.toStringAsFixed(2)}
- Monthly Budget: R${ctx.monthlyBudget.toStringAsFixed(2)}
- Total Spent: R${ctx.totalSpent.toStringAsFixed(2)}
- Income Earned this month: R${ctx.income.toStringAsFixed(2)}
- Budget used: ${((ctx.totalSpent / ctx.monthlyBudget) * 100).toStringAsFixed(0)}%
- Stability Score: ${ctx.stabilityScore}/100 (${ctx.stabilityLabel})
- Active marketplace gigs: ${ctx.marketplaceActivity}
- Missed weekly check-ins: ${ctx.missedCheckins}
- Current page: ${ctx.page}

YOUR ROLE:
- Be a proactive mentor, not just a Q&A bot
- Give specific, actionable advice tailored to their numbers
- Use South African context (Rands, campus life, Gautrain, load shedding)
- Be encouraging but honest about financial risks
- Reference their actual data when giving advice
- Suggest specific Gude app features (Budget Planner, Savings Goals, Marketplace)
- Keep responses concise — 2-4 sentences unless detail is explicitly requested
- Use emojis sparingly (1-2 per message max)
- Never be preachy; be a peer mentor who happens to know finance well
- Always end with a concrete next action the student can take in the Gude app

TONE: Warm, direct, South African, Gen Z-aware.
''';
  }

  static List<CoachMessage> getWelcomeMessages(CoachContext ctx) {
    final pct = ((ctx.totalSpent / ctx.monthlyBudget) * 100).round();
    String insight;
    List<String> quickReplies;

    if (ctx.page == 'wallet') {
      insight =
          "Your wallet balance is R${ctx.walletBalance.toStringAsFixed(0)} and you've used $pct% of your R${ctx.monthlyBudget.toStringAsFixed(0)} budget this month. ${pct > 80 ? "Getting close to the limit — let's protect what's left." : "You're managing well. Want tips to optimise further?"} 💳";
      quickReplies = [
        'Where am I overspending?',
        'Budget tips',
        'Set a savings goal'
      ];
    } else if (ctx.page == 'stability') {
      insight =
          "Your stability score is ${ctx.stabilityScore}/100 — ${ctx.stabilityLabel}. ${ctx.missedCheckins > 0 ? "You've missed ${ctx.missedCheckins} check-in${ctx.missedCheckins != 1 ? 's' : ''} which is pulling your score down." : "Keep it up!"} I can help you improve it 📊";
      quickReplies = [
        'How do I improve my score?',
        'Complete check-in tips',
        'Boost marketplace activity'
      ];
    } else if (ctx.stabilityScore >= 75) {
      insight =
          "You're doing well — ${ctx.stabilityScore}/100 stability! 💪 You've earned R${ctx.income.toStringAsFixed(0)} this month and are ${100 - pct}% under budget. Let's keep building on that.";
      quickReplies = [
        'How do I grow my savings?',
        'Find more gigs',
        'Review my budget'
      ];
    } else if (ctx.stabilityScore >= 55) {
      insight =
          "Hey, you're at ${ctx.stabilityScore}/100 stability — steady but there's room to grow. You've used $pct% of your budget with some of the month left. Let's tighten that up.";
      quickReplies = [
        'Where am I overspending?',
        'Set a savings goal',
        'Boost my score'
      ];
    } else {
      insight =
          "I can see you're navigating some pressure right now — ${ctx.stabilityScore}/100 stability and $pct% of budget used. That's okay, I'm here to help you course-correct 🎯";
      quickReplies = [
        'Help me fix my budget',
        'Find quick income',
        'What should I do first?'
      ];
    }

    return [
      CoachMessage(
        text: "Hi, I'm Coach Gude! $insight",
        isUser: false,
        quickReplies: quickReplies,
      ),
    ];
  }

  static String getContextualNudge(CoachContext ctx) {
    final pct = (ctx.totalSpent / ctx.monthlyBudget) * 100;

    if (ctx.page == 'wallet') {
      if (pct > 90) return "⚠️ ${pct.toInt()}% budget used!";
      if (pct > 70) return "💡 Budget tip available";
      return "💬 Ask Coach Gude";
    }

    if (ctx.page == 'stability') {
      if (ctx.stabilityScore < 50) return "📊 Improve your score";
      if (ctx.missedCheckins >= 2) return "📋 Missed check-ins";
      return "💬 Ask Coach Gude";
    }

    if (pct > 90) return "⚠️ ${pct.toInt()}% budget used!";
    if (ctx.marketplaceActivity == 0) return "💼 No active gigs";
    if (ctx.stabilityScore < 50) return "📊 Score needs attention";
    return "💬 Ask Coach Gude";
  }
}
