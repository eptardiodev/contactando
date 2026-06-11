import '../../../../core/constants/remote_constants.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionModel {
  const TransactionModel({
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
    this.transactionStatus = 'pending',
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
  final String transactionStatus;
  final String? intermediaryId;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json[RC.id] as String,
        amount: (json[RC.transactionAmount] as num).toDouble(),
        receiverId: json[RC.transactionReceiverId] as String,
        date: json[RC.transactionDate] != null
            ? DateTime.parse(json[RC.transactionDate] as String)
            : null,
        paymentMethod: json[RC.transactionPaymentMethod] as String?,
        description: json[RC.transactionDescription] as String?,
        senderId: json[RC.transactionSenderId] as String?,
        sentAmount: (json[RC.transactionSentAmount] as num?)?.toDouble(),
        receivedAmount: (json[RC.transactionReceivedAmount] as num?)?.toDouble(),
        exchangeRate: (json[RC.transactionExchangeRate] as num?)?.toDouble(),
        transferMethod: json[RC.transactionTransferMethod] as String?,
        transactionStatus:
            json[RC.transactionStatus] as String? ?? 'pending',
        intermediaryId: json[RC.transactionIntermediaryId] as String?,
      );

  Map<String, dynamic> toJson() => {
        RC.transactionAmount: amount,
        RC.transactionReceiverId: receiverId,
        if (date != null) RC.transactionDate: date!.toIso8601String(),
        if (paymentMethod != null)
          RC.transactionPaymentMethod: paymentMethod,
        if (description != null) RC.transactionDescription: description,
        if (senderId != null) RC.transactionSenderId: senderId,
        if (sentAmount != null) RC.transactionSentAmount: sentAmount,
        if (receivedAmount != null)
          RC.transactionReceivedAmount: receivedAmount,
        if (exchangeRate != null) RC.transactionExchangeRate: exchangeRate,
        if (transferMethod != null)
          RC.transactionTransferMethod: transferMethod,
        RC.transactionStatus: transactionStatus,
        if (intermediaryId != null)
          RC.transactionIntermediaryId: intermediaryId,
      };

  factory TransactionModel.fromEntity(TransactionEntity e) => TransactionModel(
        id: e.id,
        amount: e.amount,
        receiverId: e.receiverId,
        date: e.date,
        paymentMethod: e.paymentMethod,
        description: e.description,
        senderId: e.senderId,
        sentAmount: e.sentAmount,
        receivedAmount: e.receivedAmount,
        exchangeRate: e.exchangeRate,
        transferMethod: e.transferMethod,
        transactionStatus: e.status.value,
        intermediaryId: e.intermediaryId,
      );

  TransactionEntity toEntity() => TransactionEntity(
        id: id,
        amount: amount,
        receiverId: receiverId,
        date: date,
        paymentMethod: paymentMethod,
        description: description,
        senderId: senderId,
        sentAmount: sentAmount,
        receivedAmount: receivedAmount,
        exchangeRate: exchangeRate,
        transferMethod: transferMethod,
        status: TransactionStatusX.fromString(transactionStatus),
        intermediaryId: intermediaryId,
      );
}
