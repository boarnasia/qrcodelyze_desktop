import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../log/logger.dart';

class LogView extends StatelessWidget {
  final bool expanded;
  final void Function(bool expanded)? onExpandChanged;
  const LogView({super.key, required this.expanded, this.onExpandChanged});

  void _handleDoubleTap() {
    onExpandChanged?.call(!expanded);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: Container(
        width: double.infinity,
        height: expanded ? double.infinity : 40,
        margin: expanded ? EdgeInsets.zero : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: expanded ? const Color(0xFFDFF5E1) : Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: expanded
            ? StreamBuilder<List<LogEntry>>(
                stream: appLogBuffer.stream,
                initialData: appLogBuffer.logs,
                builder: (context, snapshot) {
                  final logs = snapshot.data ?? [];
                  return Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: logs.map((log) => Text(
                          '[${log.level}] ${log.message}',
                          style: TextStyle(
                            color: log.level == Level.SEVERE
                                ? Colors.red
                                : log.level == Level.WARNING
                                    ? Colors.orange
                                    : Colors.black,
                          ),
                        )).toList(),
                      ),
                    ),
                  );
                },
              )
            : StreamBuilder<List<LogEntry>>(
                stream: appLogBuffer.stream,
                initialData: appLogBuffer.logs,
                builder: (context, snapshot) {
                  final logs = snapshot.data ?? [];
                  final latest = logs.isNotEmpty ? logs.last : null;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      latest?.message ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: latest?.level == Level.SEVERE
                            ? Colors.red
                            : latest?.level == Level.WARNING
                                ? Colors.orange
                                : Colors.green,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
} 