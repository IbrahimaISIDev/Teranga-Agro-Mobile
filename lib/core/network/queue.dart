import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/logger.dart';
import 'network_info.dart';

class QueueManager {
  static const _queueKey = 'offline_queue';
  final NetworkInfo networkInfo;

  QueueManager(this.networkInfo);

  Future<void> addToQueue(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> queue = prefs.getStringList(_queueKey) ?? [];
    queue.add(jsonEncode(data));
    await prefs.setStringList(_queueKey, queue);
    logInfo('Added to queue: $data');
  }

  Future<void> syncQueue() async {
    if (await networkInfo.isConnected) {
      final prefs = await SharedPreferences.getInstance();
      List<String> queue = prefs.getStringList(_queueKey) ?? [];
      for (var item in queue) {
        // TODO: Send item to API (e.g., POST /parcelles or /cultures)
        logInfo('Syncing: $item');
      }
      await prefs.setStringList(_queueKey, []);
      logInfo('Queue synchronized');
    } else {
      logInfo('No connection, sync skipped');
    }
  }
}