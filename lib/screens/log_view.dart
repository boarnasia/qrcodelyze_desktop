import 'package:flutter/material.dart';
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
    final logs = appLogBuffer.logs;
    final latest = appLogBuffer.latest;
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: Container(
        width: double.infinity,
        height: expanded ? null : 40,
        margin: expanded ? EdgeInsets.zero : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: expanded ? const Color(0xFFDFF5E1) : Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: expanded
            ? Scrollbar(
                child: ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) => Text(
                    logs[index],
                    style: const TextStyle(fontSize: 14, color: Colors.green),
                  ),
                ),
              )
            : Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  latest,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.green),
                ),
              ),
      ),
    );
  }
} 