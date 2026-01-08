import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Payment {
  final String paymentId;
  final String tenantId;
  final String roomId;
  double amount;
  final DateTime dueDate;
  bool isPaid;
  DateTime? paidDate;

  Payment({
    String? paymentId,
    required this.tenantId,
    required this.roomId,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
    this.paidDate,
  }) : paymentId = paymentId ?? uuid.v4();

  int _lateDays = 0;

  void markAsPaid(DateTime date) {
    paidDate = date;
    _lateDays = date.isAfter(dueDate) ? date.difference(dueDate).inDays : 0;
    isPaid = true;
  }

  bool get isLate => !isPaid && DateTime.now().isAfter(dueDate);

  int get daysLate {
    if (isPaid) return _lateDays;
    if (DateTime.now().isAfter(dueDate)) {
      return DateTime.now().difference(dueDate).inDays;
    }
    return 0;
  }

  int get daysUntilDue {
    final diff = dueDate.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  int get year => dueDate.year;
  int get month => dueDate.month;
}
