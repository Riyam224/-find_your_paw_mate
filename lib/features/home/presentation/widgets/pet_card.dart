
// ignore_for_file: dead_code
import 'package:animals_tasks/core/di/di.dart';
import 'package:animals_tasks/features/details/presentation/screens/details_screen.dart';
import 'package:animals_tasks/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PetCard extends StatefulWidget {
  final DogEntity dog;
  const PetCard({required this.dog, super.key});

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  bool _isAddingToFavorite = false;

  void _toggleFavorite() async {
    // Check if imageId is available
    if (widget.dog.imageId == null || widget.dog.imageId!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot add to favorites: No image available'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() => _isAddingToFavorite = true);

    try {
      await getIt<FavoriteCubit>().addFavorite(imageId: widget.dog.imageId!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.dog.name} added to favorites'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.teal,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add to favorites'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingToFavorite = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        // Navigate to DetailsScreen with dog ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsScreen(dogId: widget.dog.id),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // 🖼️ Dog Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: widget.dog.imageUrl,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Icon(Icons.pets, color: Colors.grey, size: 50),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image, color: Colors.redAccent),
                ),
              ),
              const SizedBox(width: 16),

              // 🐾 Dog Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.dog.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.dog.gender ?? ''} • ${widget.dog.age ?? ''}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.red,
                        ),
                        Text(widget.dog.distance ?? ''),
                      ],
                    ),
                  ],
                ),
              ),

              // Favorite button
              IconButton(
                onPressed: _isAddingToFavorite ? null : _toggleFavorite,
                icon: _isAddingToFavorite
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                        ),
                      )
                    : const Icon(Icons.favorite_border, color: Colors.teal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
