class StreakHistoryEntry {
  final int? id;
  final DateTime activityDate;
  final int streakCount;
  final int xpEarned;
  final String description;

  const StreakHistoryEntry({
    this.id,
    required this.activityDate,
    required this.streakCount,
    required this.xpEarned,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'activity_date': activityDate.toIso8601String(),
      'streak_count': streakCount,
      'xp_earned': xpEarned,
      'description': description,
    };
  }

  factory StreakHistoryEntry.fromMap(Map<String, dynamic> map) {
    return StreakHistoryEntry(
      id: map['id'] as int?,
      activityDate: DateTime.tryParse(map['activity_date']?.toString() ?? '') ??
          DateTime.now(),
      streakCount: map['streak_count'] as int? ?? 0,
      xpEarned: map['xp_earned'] as int? ?? 0,
      description: map['description']?.toString() ?? '',
    );
  }
}
