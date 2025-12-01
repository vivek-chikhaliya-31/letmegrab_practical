import 'package:flutter/material.dart';

class TodoModel {
  int? id;
  String title;
  String description;
  int totalSeconds;
  int remainingSeconds;
  String status; // todo | in-progress | paused | done

  // ⭐ Optional field — does NOT break your flow
  // Stores when the timer started (epoch seconds)
  int? startTimestamp;

  TodoModel({
    this.id,
    required this.title,
    required this.description,
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.status,
    this.startTimestamp, // added but optional
  });

  // --- STATUS COLOR MAP ---
  Color get statusColor {
    switch (status) {
      case "in-progress":
        return Colors.blue;
      case "paused":
        return Colors.orange;
      case "done":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String get statusLabel {
    switch (status) {
      case "in-progress":
        return "In Progress";
      case "paused":
        return "Paused";
      case "done":
        return "Done";
      default:
        return "Todo";
    }
  }

  // ⭐ Timer running indicator (non-breaking)
  bool get isRunning => status == "in-progress" && startTimestamp != null;

  // ⭐ Auto-calculate remaining seconds IF timer is running
  int get calculatedRemainingSeconds {
    if (!isRunning) return remainingSeconds;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final passed = now - (startTimestamp ?? 0);
    final remain = totalSeconds - passed;

    return remain <= 0 ? 0 : remain;
  }

  // ⭐ Progress value 0 – 1
  double get progress {
    if (totalSeconds == 0) return 0;
    return 1 - (calculatedRemainingSeconds / totalSeconds);
  }

  // *** FROM MAP ***
  factory TodoModel.fromMap(Map<String, dynamic> json) => TodoModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    totalSeconds: json["totalSeconds"],
    remainingSeconds: json["remainingSeconds"],
    status: json["status"],
    startTimestamp: json["startTimestamp"], // ⭐ new field (optional)
  );

  // *** TO MAP ***
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "totalSeconds": totalSeconds,
      "remainingSeconds": remainingSeconds,
      "status": status,
      "startTimestamp": startTimestamp, // ⭐ added safely
    };
  }

  // ⭐ Copy method (needed for provider updates)
  TodoModel copyWith({
    int? id,
    String? title,
    String? description,
    int? totalSeconds,
    int? remainingSeconds,
    String? status,
    int? startTimestamp,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
      startTimestamp: startTimestamp ?? this.startTimestamp,
    );
  }
}
