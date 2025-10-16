import 'package:animals_tasks/features/favorite/presentation/screens/favorite_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animals_tasks/core/di/di.dart';
import 'package:animals_tasks/core/styling/app_colors.dart';

import 'package:animals_tasks/features/home/presentation/widgets/category_chip.dart';
import 'package:animals_tasks/features/home/presentation/widgets/search_bar.dart';
import 'package:animals_tasks/features/home/presentation/widgets/pet_card.dart';
import 'package:animals_tasks/features/home/presentation/widgets/pet_card_shimmer.dart';

import 'package:animals_tasks/features/home/presentation/widgets/search_results_widget.dart';
import 'package:animals_tasks/features/home/presentation/widgets/breed_filter_bottom_sheet.dart';

import 'package:animals_tasks/features/home/presentation/cubit/get_dogs/get_dogs_cubit.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_dogs/get_dogs_state.dart';
import 'package:animals_tasks/features/home/presentation/cubit/search_dogs/search_dogs_cubit.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_categories/get_categories_cubit.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_categories/get_categories_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<GetDogsCubit>()..fetchDogs(), // 🐾 Fetch on load
        ),
        BlocProvider(
          create: (_) => getIt<SearchDogsCubit>(), // 🔍 Search cubit
        ),
        BlocProvider(
          create: (_) =>
              getIt<GetCategoriesCubit>()
                ..fetchCategories(), // 🏷️ Categories cubit
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int selectedCategoryId = 0;
  String selectedCategoryName = 'All';
  bool _isSearching = false;
  String? _selectedBreedGroup;
  int selectedIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    FavoriteScreen(),
    HomeScreen(),
    HomeScreen(),
  ];

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BreedFilterBottomSheet(
        selectedBreedGroup: _selectedBreedGroup,
        onFilterApplied: (breedGroup) {
          setState(() {
            _selectedBreedGroup = breedGroup;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Find Your Forever Pet',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black87,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBarWidget(
              onSearch: (query) {
                setState(() {
                  _isSearching = query.isNotEmpty;
                });
              },
              onFilterTap: _showFilterBottomSheet,
            ),
            // Show active filter chip
            if (_selectedBreedGroup != null && _selectedBreedGroup!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.filter_list,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _selectedBreedGroup!,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedBreedGroup = null;
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Categories',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            const SizedBox(height: 12),
            BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
              builder: (context, state) {
                if (state is GetCategoriesLoading) {
                  return const SizedBox(
                    height: 45,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is GetCategoriesLoaded) {
                  final categories = state.categories;
                  return SizedBox(
                    height: 45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryChip(
                          label: category.name,
                          isSelected: selectedCategoryId == category.id,
                          onTap: () {
                            setState(() {
                              selectedCategoryId = category.id;
                              selectedCategoryName = category.name;
                              // Reset breed filter when selecting a category
                              _selectedBreedGroup = null;
                            });

                            // Fetch data based on category
                            if (category.id == 0) {
                              // "All" category - fetch dogs
                              context.read<GetDogsCubit>().fetchDogs();
                            } else {
                              // Specific category - fetch cats by category
                              context.read<GetDogsCubit>().fetchCatsByCategory(
                                category.id,
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                } else if (state is GetCategoriesError) {
                  return SizedBox(
                    height: 45,
                    child: Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
                return const SizedBox(height: 45);
              },
            ),
            const SizedBox(height: 16),

            // Dogs List Section — Show search results or normal list
            Expanded(
              child: _isSearching
                  ? const SearchResultsWidget()
                  : BlocBuilder<GetDogsCubit, GetDogsState>(
                      builder: (context, state) {
                        if (state is GetDogsLoading) {
                          // Show shimmer loading effect
                          return ListView.builder(
                            itemCount: 5, // Show 5 shimmer placeholders
                            itemBuilder: (context, index) =>
                                const PetCardShimmer(),
                          );
                        } else if (state is GetDogsLoaded) {
                          var dogs = state.dogs;

                          // Apply breed group filter if selected (only for "All" category with dogs)
                          if (_selectedBreedGroup != null &&
                              _selectedBreedGroup!.isNotEmpty &&
                              selectedCategoryId == 0) {
                            dogs = dogs.where((dog) {
                              // Handle null or empty breed groups
                              final dogBreedGroup =
                                  dog.breedGroup?.toLowerCase() ?? '';
                              final selectedGroup = _selectedBreedGroup!
                                  .toLowerCase();

                              // Match if breed group contains the selected filter
                              return dogBreedGroup.contains(selectedGroup);
                            }).toList();
                          }

                          // Show message if no dogs match the filter
                          if (dogs.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.pets_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No dogs found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _selectedBreedGroup != null ||
                                            selectedCategoryId != 0
                                        ? 'Try a different filter'
                                        : 'Pull to refresh',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: () async =>
                                context.read<GetDogsCubit>().fetchDogs(),
                            child: ListView.builder(
                              itemCount: dogs.length,
                              itemBuilder: (context, index) =>
                                  PetCard(dog: dogs[index]),
                            ),
                          );
                        } else if (state is GetDogsError) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
            ),
          ],
        ),
      ),

      // // todo add bottom navigation __________
    );
  }
}
