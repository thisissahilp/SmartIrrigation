import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/irrigation_session.dart';
import '../services/irrigation_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  IrrigationStatus? _selectedFilter;

  String _getDayHeader(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final sessionDate = DateTime(date.year, date.month, date.day);

    if (sessionDate == today) {
      return l10n?.today ?? 'TODAY';
    } else if (sessionDate == yesterday) {
      return l10n?.yesterday ?? 'YESTERDAY';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final irrigationService = IrrigationService();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: AppBar(
        title: Text(
          l10n?.historyScreenTitle ?? 'IRRIGATION HISTORY',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white, letterSpacing: 1.1),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            tooltip: l10n?.clearHistory ?? 'Clear History',
            onPressed: () {
              _showClearConfirmation(context, irrigationService);
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: irrigationService,
        builder: (context, _) {
          List<IrrigationSession> sessions = irrigationService.history;

          if (_selectedFilter != null) {
            sessions = sessions.where((s) => s.status == _selectedFilter).toList();
          }

          // Group by date
          final Map<String, List<IrrigationSession>> grouped = {};
          for (final s in sessions) {
            final header = _getDayHeader(context, s.startTime);
            grouped.putIfAbsent(header, () => []).add(s);
          }

          return Column(
            children: [
              // Filter Chips
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: Text(l10n?.all ?? 'All'),
                        selected: _selectedFilter == null,
                        selectedColor: const Color(0xFF2E7D32).withValues(alpha: 0.2),
                        checkmarkColor: const Color(0xFF2E7D32),
                        onSelected: (_) => setState(() => _selectedFilter = null),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: Text('🟢 ${l10n?.completed ?? 'Completed'}'),
                        selected: _selectedFilter == IrrigationStatus.completed,
                        selectedColor: Colors.green.withValues(alpha: 0.2),
                        onSelected: (_) => setState(() => _selectedFilter = IrrigationStatus.completed),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: Text('🟠 ${l10n?.interrupted ?? 'Interrupted'}'),
                        selected: _selectedFilter == IrrigationStatus.interrupted,
                        selectedColor: Colors.orange.withValues(alpha: 0.2),
                        onSelected: (_) => setState(() => _selectedFilter = IrrigationStatus.interrupted),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: Text('🔴 ${l10n?.missed ?? 'Missed'}'),
                        selected: _selectedFilter == IrrigationStatus.missed,
                        selectedColor: Colors.red.withValues(alpha: 0.2),
                        onSelected: (_) => setState(() => _selectedFilter = IrrigationStatus.missed),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: Text('⚪ ${l10n?.cancelled ?? 'Cancelled'}'),
                        selected: _selectedFilter == IrrigationStatus.cancelled,
                        selectedColor: Colors.grey.withValues(alpha: 0.2),
                        onSelected: (_) => setState(() => _selectedFilter = IrrigationStatus.cancelled),
                      ),
                    ],
                  ),
                ),
              ),

              // Sessions List
              Expanded(
                child: sessions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history_toggle_off, size: 60, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(
                              l10n?.noHistoryEntries ?? 'No irrigation history entries.',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                            ),
                          ],
                        ),
                      )
                    : _buildGroupedListView(grouped),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGroupedListView(Map<String, List<IrrigationSession>> grouped) {
    final headers = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: headers.length,
      itemBuilder: (context, index) {
        final header = headers[index];
        final daySessions = grouped[header]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 8, bottom: 8),
              child: Text(
                header,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            ...daySessions.map((s) => _buildSessionCard(context, s)),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  Widget _buildSessionCard(BuildContext context, IrrigationSession session) {
    final l10n = AppLocalizations.of(context);
    Color statusColor;
    IconData statusIcon;

    switch (session.status) {
      case IrrigationStatus.completed:
        statusColor = const Color(0xFF2E7D32);
        statusIcon = Icons.check_circle;
        break;
      case IrrigationStatus.interrupted:
        statusColor = Colors.orange.shade800;
        statusIcon = Icons.warning_amber_rounded;
        break;
      case IrrigationStatus.missed:
        statusColor = Colors.red.shade700;
        statusIcon = Icons.cancel;
        break;
      case IrrigationStatus.cancelled:
        statusColor = Colors.grey.shade600;
        statusIcon = Icons.remove_circle_outline;
        break;
    }

    final sourceLabel = _getSourceText(l10n, session.source);
    final statusLabel = _getStatusText(l10n, session.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.15),
          child: Icon(statusIcon, color: statusColor, size: 22),
        ),
        title: Row(
          children: [
            Text(
              session.formattedStartTime,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                sourceLabel,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              session.scheduleName != null
                  ? '${session.scheduleName} • ${session.formattedRuntime}'
                  : '${l10n?.pumpRuntime ?? "Runtime"}: ${session.formattedRuntime}',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
            ),
            if (session.interruptionReason != null)
              Text(
                session.interruptionReason!,
                style: TextStyle(fontSize: 11, color: statusColor, fontStyle: FontStyle.italic),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              statusLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: statusColor,
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
          ],
        ),
        onTap: () => _showSessionDetailsDialog(context, session),
      ),
    );
  }

  String _getSourceText(AppLocalizations? l10n, IrrigationSource source) {
    switch (source) {
      case IrrigationSource.manual:
        return l10n?.manual ?? 'Manual';
      case IrrigationSource.timer:
        return l10n?.timer ?? 'Timer';
      case IrrigationSource.scheduled:
        return l10n?.scheduled ?? 'Scheduled';
    }
  }

  String _getStatusText(AppLocalizations? l10n, IrrigationStatus status) {
    switch (status) {
      case IrrigationStatus.completed:
        return l10n?.completed ?? 'Completed';
      case IrrigationStatus.interrupted:
        return l10n?.interrupted ?? 'Interrupted';
      case IrrigationStatus.missed:
        return l10n?.missed ?? 'Missed';
      case IrrigationStatus.cancelled:
        return l10n?.cancelled ?? 'Cancelled';
    }
  }

  void _showSessionDetailsDialog(BuildContext context, IrrigationSession session) {
    final l10n = AppLocalizations.of(context);
    final statusLabel = _getStatusText(l10n, session.status);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Color(0xFF2E7D32)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n?.sessionDetails ?? 'Session Details',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (session.scheduleName != null) ...[
              Text('${l10n?.scheduleName ?? "Schedule Name"}: ${session.scheduleName}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
            ],
            Text('${l10n?.startTime ?? "Start Time"}: ${session.formattedStartTime}'),
            const SizedBox(height: 4),
            Text('Status: $statusLabel'),
            const SizedBox(height: 4),
            Text('${l10n?.requestedDuration ?? "Requested Duration:"} ${session.formattedRequestedDuration}'),
            const SizedBox(height: 4),
            Text('${l10n?.confirmedRuntime ?? "Confirmed Runtime:"} ${session.formattedRuntime}'),
            const SizedBox(height: 8),
            if (session.interruptionReason != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  session.interruptionReason!,
                  style: TextStyle(fontSize: 12, color: Colors.orange.shade900, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n?.close ?? 'Close'),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context, IrrigationService service) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n?.clearHistoryTitle ?? 'Clear History'),
        content: Text(l10n?.clearHistoryConfirm ?? 'Are you sure you want to delete all irrigation history entries?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              service.clearHistory();
              Navigator.pop(ctx);
            },
            child: Text(l10n?.clearAll ?? 'Clear All', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
