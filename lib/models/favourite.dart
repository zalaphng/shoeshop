class Favourite {
  String userId;
  List<String> productIds;

  Favourite({required this.userId, required this.productIds});

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'productIds': productIds,
  };

  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
      userId: json['userId'],
      productIds: List<String>.from(json['productIds']),
    );
  }
}