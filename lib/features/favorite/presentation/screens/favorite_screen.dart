import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animals_tasks/core/styling/app_colors.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  int selectedFilterIndex = 0;

  final List<String> filters = [
    'All',
    'Cats',
    'Dogs',
    'Birds',
    'Fish',
    'Reptiles',
  ];

  final List<DogEntity> pets = [
    DogEntity(
      id: '1',
      name: 'Joli',
      imageUrl: 'https://cdn2.thecatapi.com/images/MTY3ODIyMQ.jpg',
      gender: 'Female',
      age: '1 Year',
      distance: '1.6 km away',
    ),
    DogEntity(
      id: '2',
      name: 'Oliver',
      imageUrl:
          'https://cdn.download.ams.birds.cornell.edu/api/v1/asset/172246541/1800',
      gender: 'Male',
      age: '2 Years',
      distance: '2 km away',
    ),
    DogEntity(
      id: '3',
      name: 'Tom',
      imageUrl: 'https://cdn2.thedogapi.com/images/BJa4kxc4X.jpg',
      gender: 'Male',
      age: '1 Year',
      distance: '2.7 km away',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🐾 Title
              const Text(
                'Your Favorite Pets',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // 🟢 Filter Chips
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final isSelected = index == selectedFilterIndex;
                    return GestureDetector(
                      onTap: () => setState(() => selectedFilterIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          filters[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // 🐶 Pet Cards Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: pets.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return _buildPetCard(pet);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🐾 Pet Card Widget
  Widget _buildPetCard(DogEntity pet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🐶 Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: CachedNetworkImage(
              imageUrl: pet.imageUrl,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: Icon(Icons.pets, size: 40, color: Colors.grey),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.broken_image,
                color: Colors.redAccent,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 🐾 Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 14),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        pet.distance ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),

          // ❤️ Favorite Icon
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 8),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F2F1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.favorite, color: Colors.teal, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 10,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      currentIndex: 1,
      onTap: (index) {},
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: '',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],
    );
  }
}
