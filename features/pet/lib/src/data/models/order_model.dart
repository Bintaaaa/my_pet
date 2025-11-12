class OrderModel {
  final int? id;
  final int? petId;
  final int? quantity;
  final DateTime? shipDate;
  final String? status;
  final bool? complete;

  const OrderModel({
    this.id,
    this.petId,
    this.quantity,
    this.shipDate,
    this.status,
    this.complete,
  });

  factory OrderModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const OrderModel();
    DateTime? parseDate(Object? v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    return OrderModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      petId: json['petId'] is int ? json['petId'] : int.tryParse('${json['petId']}'),
      quantity: json['quantity'] is int ? json['quantity'] : int.tryParse('${json['quantity']}'),
      shipDate: parseDate(json['shipDate']),
      status: json['status']?.toString(),
      complete: json['complete'] is bool ? json['complete'] : (json['complete'] == null ? null : json['complete'].toString().toLowerCase() == 'true'),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (petId != null) 'petId': petId,
    if (quantity != null) 'quantity': quantity,
    if (shipDate != null) 'shipDate': shipDate!.toUtc().toIso8601String(),
    if (status != null) 'status': status,
    if (complete != null) 'complete': complete,
  };
}
