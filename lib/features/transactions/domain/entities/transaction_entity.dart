import 'package:equatable/equatable.dart';

enum TransactionStatus { pending, completed, failed, canceled }

extension TransactionStatusX on TransactionStatus {
  String get value => name; // 'pending', 'completed', …

  static TransactionStatus fromString(String? s) => switch (s) {
        'completed' => TransactionStatus.completed,
        'failed' => TransactionStatus.failed,
        'canceled' => TransactionStatus.canceled,
        _ => TransactionStatus.pending,
      };

  String get labelEs => switch (this) {
        TransactionStatus.pending => 'Pendiente',
        TransactionStatus.completed => 'Completada',
        TransactionStatus.failed => 'Fallida',
        TransactionStatus.canceled => 'Cancelada',
      };
}

class TransactionEntity extends Equatable {
  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.receiverId,
    this.date,
    this.paymentMethod,
    this.description,
    this.senderId,
    this.sentAmount,
    this.receivedAmount,
    this.exchangeRate,
    this.transferMethod,
    this.status = TransactionStatus.pending,
    this.intermediaryId,
  });

  final String id;
  final double amount;
  final String receiverId;
  final DateTime? date;
  final String? paymentMethod;
  final String? description;
  final String? senderId;
  final double? sentAmount;
  final double? receivedAmount;
  final double? exchangeRate;
  final String? transferMethod;
  final TransactionStatus status;
  final String? intermediaryId;

  TransactionEntity copyWith({
    String? id,
    double? amount,
    String? receiverId,
    DateTime? date,
    String? paymentMethod,
    String? description,
    String? senderId,
    double? sentAmount,
    double? receivedAmount,
    double? exchangeRate,
    String? transferMethod,
    TransactionStatus? status,
    String? intermediaryId,
  }) =>
      TransactionEntity(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        receiverId: receiverId ?? this.receiverId,
        date: date ?? this.date,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        description: description ?? this.description,
        senderId: senderId ?? this.senderId,
        sentAmount: sentAmount ?? this.sentAmount,
        receivedAmount: receivedAmount ?? this.receivedAmount,
        exchangeRate: exchangeRate ?? this.exchangeRate,
        transferMethod: transferMethod ?? this.transferMethod,
        status: status ?? this.status,
        intermediaryId: intermediaryId ?? this.intermediaryId,
      );

  @override
  List<Object?> get props => [
        id, amount, receiverId, date, paymentMethod, description,
        senderId, sentAmount, receivedAmount, exchangeRate,
        transferMethod, status, intermediaryId,
      ];
}
