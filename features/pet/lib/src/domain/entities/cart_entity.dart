class CartItemEntity {
  final int petId;
  final String name;
  final String category;
  final List<String> photoUrls;

  const CartItemEntity({
    required this.petId,
    required this.name,
    required this.category,
    required this.photoUrls,
  });
}
