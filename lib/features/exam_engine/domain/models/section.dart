class ExamSection {
  final String id;
  final String name;
  final String tamilName;
  final List<int> questionIndices;
  final int allottedSeconds; // e.g. 15 minutes = 900 seconds
  final bool isLocked;

  const ExamSection({
    required this.id,
    required this.name,
    required this.tamilName,
    required this.questionIndices,
    this.allottedSeconds = 900, // 15 mins default
    this.isLocked = false,
  });

  ExamSection copyWith({
    String? id,
    String? name,
    String? tamilName,
    List<int>? questionIndices,
    int? allottedSeconds,
    bool? isLocked,
  }) {
    return ExamSection(
      id: id ?? this.id,
      name: name ?? this.name,
      tamilName: tamilName ?? this.tamilName,
      questionIndices: questionIndices ?? this.questionIndices,
      allottedSeconds: allottedSeconds ?? this.allottedSeconds,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}
