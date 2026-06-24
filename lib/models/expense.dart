class Expense {
  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.createdAt,
    this.receiptImagePath,
  });

  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final DateTime date;
  final String? receiptImagePath;
  final DateTime createdAt;

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    String? categoryId,
    DateTime? date,
    String? receiptImagePath,
    bool clearReceiptImage = false,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      receiptImagePath: clearReceiptImage
          ? null
          : receiptImagePath ?? this.receiptImagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'categoryId': categoryId,
      'date': date.toIso8601String(),
      'receiptImagePath': receiptImagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, Object?> map) {
    return Expense(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      categoryId: map['categoryId'] as String,
      date: DateTime.parse(map['date'] as String),
      receiptImagePath: map['receiptImagePath'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
