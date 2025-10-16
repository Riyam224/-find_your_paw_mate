// // ignore_for_file: dead_code

// import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// class PetCard extends StatelessWidget {
//   final DogEntity dog;
//   const PetCard({required this.dog, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Row(
//           children: [
//             // 🖼️ Dog Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: CachedNetworkImage(
//                 imageUrl: dog.imageUrl,
//                 height: 100,
//                 width: 100,
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) =>
//                     const Icon(Icons.pets, color: Colors.grey, size: 50),
//                 errorWidget: (context, url, error) =>
//                     const Icon(Icons.broken_image, color: Colors.redAccent),
//               ),
//             ),
//             const SizedBox(width: 16),

//             // 🐾 Dog Info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     dog.name,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "${dog.gender ?? ''} • ${dog.age ?? ''}",
//                     style: TextStyle(color: Colors.grey.shade700),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.location_on,
//                         size: 16,
//                         color: Colors.red,
//                       ),
//                       Text(dog.distance ?? ''),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const Icon(Icons.favorite_border, color: Colors.teal),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: dead_code
import 'package:animals_tasks/features/details/presentation/screens/details_screen.dart';
import 'package:animals_tasks/features/home/data/models/dog_model.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final DogEntity dog;
  const PetCard({required this.dog, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        // Navigate to DetailsScreen
        final dogModel = DogModel(
          id: dog.id,
          name: dog.name,
          imageUrl: dog.imageUrl,
          gender: dog.gender,
          age: dog.age,
          weight: dog.weight,
          distance: dog.distance,
          lifeSpan: dog.lifeSpan,
          breedGroup: dog.breedGroup,
          description: dog.description,
          isFavorite: dog.isFavorite,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailsScreen(dog: dogModel)),
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
                  imageUrl: dog.imageUrl,
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
                      dog.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${dog.gender ?? ''} • ${dog.age ?? ''}",
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
                        Text(dog.distance ?? ''),
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(Icons.favorite_border, color: Colors.teal),
            ],
          ),
        ),
      ),
    );
  }
}
