import 'package:feature_pet/src/domain/entities/cart_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';
import '../../data/repositories/cart_repository.dart';
import '../../domain/entities/pet_entity.dart';
import '../../domain/usecases/get_pet_detail_usecase.dart';
import '../../domain/usecases/checkout_order_usecase.dart';
import '../cubit/pet_detail_cubit.dart';
import '../cubit/pet_detail_state.dart';
import 'cart_screen.dart';

class PetDetailScreen extends StatelessWidget {
  final int petId;
  const PetDetailScreen({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    final sl = GetIt.instance;
    return BlocProvider(
      create: (_) => PetDetailCubit(
        getPetDetailUseCase: sl<GetPetDetailUseCase>(),
        checkoutOrderUseCase: sl<CheckoutOrderUseCase>(),
      )..fetchPetDetail(id: petId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Hewan', style: AppTypography.headline),
          backgroundColor: AppColors.background,
          elevation: 0,
        ),
        body: BlocListener<PetDetailCubit, PetDetailState>(
          listenWhen: (previous, current) =>
          previous.stateCheckout != current.stateCheckout,
          listener: (context, state) {
            final scaffold = ScaffoldMessenger.of(context);
            final checkout = state.stateCheckout;
            if (checkout.state.isLoading) {
              scaffold.showSnackBar(
                const SnackBar(content: Text('Memproses pesanan...')),
              );
            } else if (checkout.state.isError) {
              scaffold.showSnackBar(
                SnackBar(
                    content:
                    Text('Pesanan gagal: ${checkout.message ?? 'unknown'}')),
              );
            } else if (checkout.state.isHasData) {
              scaffold.showSnackBar(
                const SnackBar(content: Text('Pesanan berhasil')),
              );
            }
          },
          child: BlocBuilder<PetDetailCubit, PetDetailState>(
            builder: (context, state) {
              return AppStateWidget<PetEntity>(
                viewData: state.statePetDetail,
                onRetry: () => context.read<PetDetailCubit>().fetchPetDetail(
                  id: (state.statePetDetail.data?.id) ?? 0,
                ),
                onHasData: (pet) => _PetDetailBody(pet: pet),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PetDetailBody extends StatelessWidget {
  final PetEntity pet;
  const _PetDetailBody({required this.pet});

  @override
  Widget build(BuildContext context) {
    final imageUrl = pet.photoUrls.isNotEmpty ? pet.photoUrls.first : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () async {
                final sl = GetIt.instance;
                final scaffold = ScaffoldMessenger.of(context);
                final cartRepo = sl<CartRepository>();
                final item = CartItemEntity(
                  petId: pet.id,
                  name: pet.name,
                  category: pet.category,
                  photoUrls: pet.photoUrls,
                );
                final res = await cartRepo.addToCart(item);
                if (res.isOk) {
                  scaffold.showSnackBar(
                    const SnackBar(
                        content: Text('Berhasil disimpan ke Keranjang Adopsi')),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                } else {
                  scaffold.showSnackBar(
                    SnackBar(
                        content: Text(
                            'Gagal menyimpan: ${res.failure.message ?? 'unknown'}')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: Text(
                'Simpan ke Keranjang Adopsi',
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Hero(
              tag: 'pet-image-${pet.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 240,
                  height: 240,
                  child: AppNetworkImage(
                    url: imageUrl,
                    borderRadius: 16,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: AppTypography.headline.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.pets,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  pet.category,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            pet.status,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: pet.tags.isNotEmpty
                        ? pet.tags.map((t) {
                      return Chip(
                        label: Text(
                          t,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                        backgroundColor:
                        AppColors.primary.withOpacity(0.06),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }).toList()
                        : [
                      Text(
                        'Tidak ada tag',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.text),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
