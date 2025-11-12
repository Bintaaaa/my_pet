import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';
import 'package:feature_pet/src/presentation/screens/pet_detail_screen.dart';
import '../../domain/entities/cart_entity.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sl = GetIt.instance;
    return BlocProvider<CartCubit>(
      create: (_) => CartCubit(
        cartRepository: sl(),
        checkoutCartUseCase: sl(),
      )..loadCart(),
      child: const _CartView(),
    );
  }
}

class _CartView extends StatelessWidget {
  const _CartView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Adopsi'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return AppStateWidget<List<CartItemEntity>>(
            viewData: state.stateCart,
            onRetry: () => context.read<CartCubit>().loadCart(),
            onHasData: (items) => _buildList(context, items),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => context.read<CartCubit>().checkout(),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColors.primary),
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 14),
                ),
                elevation: const MaterialStatePropertyAll(4),
              ),
              child: Text(
                'Checkout',
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
    );
  }

  Widget _buildList(BuildContext context, List<CartItemEntity> items) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'Keranjang kosong',
          style: AppTypography.body.copyWith(color: AppColors.text),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final imageUrl = item.photoUrls.isNotEmpty ? item.photoUrls.first : null;
        return _CartItemCard(
          item: item,
          imageUrl: imageUrl,
          onRemove: () => context.read<CartCubit>().removeFromCart(item.petId),
          onTap: () {
            Navigator.push<void>(
              context,
              MaterialPageRoute(builder: (_) => PetDetailScreen(petId: item.petId)),
            );
          },
        );
      },
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItemEntity item;
  final String? imageUrl;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  const _CartItemCard({
    required this.item,
    this.imageUrl,
    this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 72,
                height: 72,
                child: AppNetworkImage(
                  url: imageUrl,
                  borderRadius: 10,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.category,
                    style: AppTypography.caption.copyWith(color: AppColors.text.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onRemove,
              icon: Icon(Icons.delete_outline),
              color: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }
}
