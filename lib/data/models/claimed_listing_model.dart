class ClaimedListingModel {
  final String id;
  final String farmerId;
  final String buyerId;
  final DateTime claimedDateTime;
  final String listingId;

  ClaimedListingModel({
    required this.id,
    required this.farmerId,
    required this.buyerId,
    required this.claimedDateTime,
    required this.listingId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'buyerId': buyerId,
      'claimedDateTime': claimedDateTime.toIso8601String(),
      'listingId': listingId,
    };
  }

  factory ClaimedListingModel.fromJson(Map<String, dynamic> json) {
    return ClaimedListingModel(
      id: json['id'] ?? '',
      farmerId: json['farmerId'] ?? '',
      buyerId: json['buyerId'] ?? '',
      claimedDateTime: DateTime.parse(json['claimedDateTime']),
      listingId: json['listingId'] ?? '',
    );
  }
} 