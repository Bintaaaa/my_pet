import 'package:feature_pet/src/presentation/screens/pet_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';
import '../widgets/pet_card.dart';
import '../../domain/entities/pet_entity.dart';
import '../../domain/usecases/get_pets_usecase.dart';
import '../cubit/pet_list_cubit.dart';
import '../cubit/pet_list_state.dart';
import 'cart_screen.dart';

class PetListScreen extends StatelessWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sl = GetIt.instance;
    return BlocProvider(
      create: (_) {
        final cubit = PetListCubit(usecase: sl<GetPetsUseCase>());
        cubit.fetchPets();
        return cubit;
      },
      child: const _PetListView(),
    );
  }
}

class _PetListView extends StatelessWidget {
  const _PetListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pet Store', style: AppTypography.headline),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
            icon: Icon(Icons.shopping_cart, color: AppColors.text),
          ),
        ],
      ),
      body: BlocBuilder<PetListCubit, PetListState>(
        builder: (context, state) {
          return AppStateWidget<List<PetEntity>>(
            viewData: state.statePetList,
            onRefresh: () => context.read<PetListCubit>().fetchPets(),
            onRetry: () => context.read<PetListCubit>().fetchPets(),
            onHasData: (pets) => _buildPetList(context, pets),
          );
        },
      ),
    );
  }

  Widget _buildPetList(BuildContext context, List<PetEntity> pets) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        final imageUrl = pet.photoUrls.isNotEmpty ? pet.photoUrls.first : null;
        return PetCard(
          pet: Pet(
            id: pet.id.toString(),
            name: pet.name,
            imageUrl: imageUrl,
            category: pet.category,
            isFavorite: false,
          ),
          onTap: () {
            Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (_) => PetDetailScreen(petId: pet.id),
              ),
            );
          },
        );
      },
    );
  }
}
