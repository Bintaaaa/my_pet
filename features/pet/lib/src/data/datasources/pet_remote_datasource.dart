import 'package:core/core.dart';
import '../models/pet_model.dart';
import '../models/order_model.dart';

abstract class PetRemoteDataSource {
  Future<List<PetModel>> getPets(String status);
  Future<PetModel> getPetDetail(int id);
  Future<OrderModel> checkoutPet(OrderModel order);
}

class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final NetworkHelper network;

  PetRemoteDataSourceImpl(this.network);

  @override
  Future<List<PetModel>> getPets(String status) async {
    final response = await network.safeRequest(
          () => network.dio.get('/pet/findByStatus', queryParameters: {'status': status}),
    );

    final data = response.data;
    if (data is List) {
      return data.map((e) => PetModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }

  @override
  Future<PetModel> getPetDetail(int id) async {
    final response = await network.safeRequest(
          () => network.dio.get('/pet/$id'),
    );
    final data = response.data;
    if (data is Map) {
      return PetModel.fromJson(Map<String, dynamic>.from(data));
    }
    return const PetModel();
  }

  @override
  Future<OrderModel> checkoutPet(OrderModel order) async {
    final response = await network.safeRequest(
          () => network.dio.post('/store/order', data: order.toJson()),
    );
    final data = response.data;
    if (data is Map) {
      return OrderModel.fromJson(Map<String, dynamic>.from(data));
    }
    return const OrderModel();
  }
}
