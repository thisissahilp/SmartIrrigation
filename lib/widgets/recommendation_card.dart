import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_translations.dart';
import '../services/irrigation_service.dart';
import '../services/recommendation_service.dart';
import '../services/settings_service.dart';
import '../services/weather_service.dart';

class RecommendationCard extends StatelessWidget {
  final Function(String route) onNavigate;

  const RecommendationCard({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final irrigation = IrrigationService();
    final weatherService = WeatherService();
    final settingsService = SettingsService();

    return ListenableBuilder(
      listenable: Listenable.merge([irrigation, weatherService, settingsService]),
      builder: (context, _) {
        final rec = RecommendationService().evaluateRecommendation(
          context: context,
          onNavigate: onNavigate,
        );

        Color headerColor;
        Color cardBgColor;
        IconData cardIcon;

        switch (rec.type) {
          case RecommendationType.safetyInterruption:
            headerColor = const Color(0xFFC62828);
            cardBgColor = Colors.red.shade50;
            cardIcon = Icons.warning_amber_rounded;
            break;
          case RecommendationType.rainExpected:
          case RecommendationType.rainPossible:
          case RecommendationType.recentRainfall:
            headerColor = const Color(0xFF0288D1);
            cardBgColor = Colors.lightBlue.shade50;
            cardIcon = Icons.thunderstorm_outlined;
            break;
          case RecommendationType.missed:
            headerColor = Colors.orange.shade900;
            cardBgColor = Colors.orange.shade50;
            cardIcon = Icons.warning_amber_rounded;
            break;
          case RecommendationType.completed:
            headerColor = const Color(0xFF2E7D32);
            cardBgColor = const Color(0xFFF1F8E9);
            cardIcon = Icons.check_circle_outline;
            break;
          case RecommendationType.upcoming:
          case RecommendationType.noSchedule:
            headerColor = const Color(0xFF2E7D32);
            cardBgColor = Colors.white;
            cardIcon = Icons.lightbulb_outline;
            break;
        }

        final isRainWarning = rec.type == RecommendationType.rainExpected || rec.type == RecommendationType.rainPossible;

        return Card(
          elevation: 4,
          color: cardBgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(cardIcon, color: headerColor, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rec.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: headerColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  rec.message,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    color: Colors.grey.shade900,
                  ),
                ),
                if (rec.primaryActionLabel != null) ...[
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (rec.secondaryActionLabel != null) ...[
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: headerColor,
                          ),
                          onPressed: rec.onSecondaryAction,
                          child: Text(
                            rec.secondaryActionLabel!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: headerColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          if (isRainWarning) {
                            _showSkipConfirmationDialog(context, rec);
                          } else if (rec.onPrimaryAction != null) {
                            rec.onPrimaryAction!();
                          }
                        },
                        child: Text(
                          rec.primaryActionLabel!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSkipConfirmationDialog(BuildContext context, RecommendationResult rec) {
    final l10n = AppLocalizations.of(context);
    final lang = SettingsService().language;

    final title = l10n?.confirmSkipTitle ?? AppTranslations.tr('confirmSkipTitle', lang);
    final cancelText = l10n?.cancel ?? AppTranslations.tr('cancel', lang);
    final skipText = l10n?.skipOnce ?? AppTranslations.tr('skipOnce', lang);

    final schedName = rec.targetSchedule?.name ?? 'Scheduled Irrigation';
    final timeStr = rec.targetSchedule?.formattedStartTime ?? '';
    final durStr = rec.targetSchedule?.formattedDuration ?? '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$schedName ($timeStr)',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              '${AppTranslations.tr('duration', lang)}: $durStr',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.grain, color: Colors.blue.shade800, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Rain probability is high (${rec.rainProbability ?? 70}%) around scheduled time.',
                      style: TextStyle(fontSize: 12, color: Colors.blue.shade900, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Future occurrences of this schedule will remain active.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(cancelText),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0288D1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              if (rec.onPrimaryAction != null) {
                rec.onPrimaryAction!();
              }
            },
            child: Text(skipText, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
